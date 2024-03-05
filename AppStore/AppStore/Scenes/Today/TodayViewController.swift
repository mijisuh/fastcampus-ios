//
//  TodayViewController.swift
//  AppStore
//
//  Created by mijisuh on 2024/03/04.
//

import UIKit
import SnapKit

final class TodayViewController: UIViewController { // TodayViewController를 계승할 서브 클래스가 없기 때문에 final로 정의
    
    private var todayList: [Today] = []

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout) // 레이아웃이 반드시 필요
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.backgroundColor = .systemBackground
        collectionView.register(TodayCollectionViewCell.self, forCellWithReuseIdentifier: "todayCell")
        collectionView.register(TodayCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "TodayCollectionHeaderView")
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(self.collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        fetchData()
    }

}

extension TodayViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return todayList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "todayCell", for: indexPath) as? TodayCollectionViewCell else { return UICollectionViewCell() }
        let today = todayList[indexPath.item]
        cell.setup(today: today)
        return cell
    }
    
}

extension TodayViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width - 32
        return CGSize(width: width, height: width)
    }
    
    // 헤더 사이즈를 설정하지 않으면 헤더가 보이지 않음
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = collectionView.frame.width - 32
        return CGSize(width: width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader, // Header나 Footer일 때 모두 불려지므로 구분 필요
              let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "TodayCollectionHeaderView", for: indexPath) as? TodayCollectionHeaderView
        else { return UICollectionReusableView() }
        header.setupViews() // 레이아웃 설정
        return header
    }
    
    // 헤더와 셀 사이 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let value: CGFloat = 16
        return UIEdgeInsets(top: value, left: value, bottom: value, right: value)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let today = todayList[indexPath.item]
        let vc = AppDetailViewController(appTitle: today.title, subTitle: today.subTitle, imageURL: today.imageURL)
        present(vc, animated: true)
    }
    
}

private extension TodayViewController {
    
    // Today.plist 데이터로 변수로 주입
    func fetchData() {
        guard let url = Bundle.main.url(forResource: "Today", withExtension: "plist") else { return }
        
        do {
            let data = try Data(contentsOf: url)
            let result = try PropertyListDecoder().decode([Today].self, from: data)
            todayList = result
        } catch { }
    }
    
}
