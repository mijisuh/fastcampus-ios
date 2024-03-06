//
//  ViewController.swift
//  SubwayStation
//
//  Created by mijisuh on 2024/03/05.
//

import UIKit
import SnapKit
import Alamofire

class StationSearchViewController: UIViewController {
    
    private var stations: [Station] = []
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isHidden = true
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationItems()
        setTableViewLayout()
    }
    
    private func setNavigationItems() {
        // navigationItem에 SearhController 설정
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "지하철 도착 정보"
        
        let searchController = UISearchController()
        searchController.searchBar.placeholder = "지하철 역을 입력해주세요."
        searchController.obscuresBackgroundDuringPresentation = false // true 설정 시 SearchController가 표시되고 있을 때 밑의 배경이 어둡게 표시
        searchController.searchBar.delegate = self
        
        navigationItem.searchController = searchController
    }
    
    private func setTableViewLayout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func requestStationName(from stationName: String) {
        stations = []
        self.tableView.reloadData()
        guard !stationName.isEmpty else { return }
        let urlString = "http://openapi.seoul.go.kr:8088/sample/json/SearchInfoBySubwayNameService/1/5/\(stationName)"
        AF
            .request(urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") // request에서 한글(영어가 아닌 모든 문자)을 내부적으로 인코딩하는 중에 이상한 특수문자로 깨지지 않도록 설정
            .responseDecodable(of: StationResponseModel.self) { [weak self] response  in
                guard let self = self, case .success(let data) = response.result else { return }
                let result = data.stations
                self.stations = [Station(stationName: stationName, lineNumber: result.reduce("| ") { $0 + "\($1.lineNumber) | " })]
                self.tableView.reloadData()
            }
            .resume()
    }

}

extension StationSearchViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        tableView.reloadData()
        tableView.isHidden = false
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        tableView.isHidden = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        requestStationName(from: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        stations = []
    }
    
}

extension StationSearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let station = stations[indexPath.row]
        let vc = StationDetailViewController(station: station)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension StationSearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stations.count // 초기 화면에 이 값이 있으면 SearchBar가 안보이는 문제가 있음
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        let station = stations[indexPath.row]
        cell.textLabel?.text = station.stationName
        cell.detailTextLabel?.text = station.lineNumber // style을 subtitle로 했기 때문에 사용 가능
        return cell
    }
    
}

