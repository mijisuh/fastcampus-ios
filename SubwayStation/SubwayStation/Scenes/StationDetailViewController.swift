//
//  StationDetailViewController.swift
//  SubwayStation
//
//  Created by mijisuh on 2024/03/05.
//

import UIKit
import SnapKit
import Alamofire

final class StationDetailViewController: UIViewController {
    
    private let station: Station
    private var realtimeArrivalList: [StationArrivalDataResponseModel.RealTimeArrival] = []
    
    private var timer: Timer?
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(fetchData), for: .valueChanged)
        return refreshControl
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(
            width: view.frame.width - 32,
            height: 100
        )
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(StationDetailCollectionViewCell.self, forCellWithReuseIdentifier: "StationDetailCollectionViewCell")
        collectionView.dataSource = self
        collectionView.refreshControl = refreshControl
        return collectionView
    }()
    
    init(station: Station) {
        self.station = station
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = station.stationName
        
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        fetchData()
        
        // 타이머 설정
        timer = Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(fetchData), userInfo: nil, repeats: true)
    }
    
    @objc private func fetchData() {
        let stationName = station.stationName
        let urlString = "http://swopenapi.seoul.go.kr/api/subway/sample/json/realtimeStationArrival/0/5/\(stationName.replacingOccurrences(of: "역", with: ""))" // 서울역은 요청 실패하기 때문에 이름에 "역"을 빼줌
        
        AF
            .request(urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
            .responseDecodable(of: StationArrivalDataResponseModel.self) { [weak self] response in
                guard let self = self else { return }
                self.refreshControl.endRefreshing()
                
                guard case .success(let data) = response.result else { return }
                self.realtimeArrivalList = data.realtimeArrivalList
                self.collectionView.reloadData()
                
                print("Updated: \(self.realtimeArrivalList)")
            }
            .resume()
    }
    
}

extension StationDetailViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return realtimeArrivalList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StationDetailCollectionViewCell", for: indexPath) as? StationDetailCollectionViewCell else { return UICollectionViewCell() }
        let realtimeArrival = realtimeArrivalList[indexPath.row]
        cell.setup(with: realtimeArrival)
        return cell
    }
    
}
