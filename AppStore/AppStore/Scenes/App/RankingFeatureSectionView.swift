//
//  RankFeatureSectionView.swift
//  AppStore
//
//  Created by mijisuh on 2024/03/04.
//

import UIKit
import SnapKit

final class RankingFeatureSectionView: UIView {
    
    private var rankingFeatureList: [RankingFeature] = []
    
    private let presentClosure: ((String, String, String) -> Void)?
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .black)
        label.text = "iPhone이 처음이라면"
        return label
    }()
    
    private lazy var showAllAppsButton: UIButton = {
        let button = UIButton()
        button.setTitle("모두 보기", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        return button
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 32
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = .systemBackground
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.register(RankingFeatureCollectionViewCell.self, forCellWithReuseIdentifier: "RankingFeatureCollectionViewCell")
        
        return collectionView
    }()
    
    private let separator = SeparatorView(frame: .zero)
    
    init(frame: CGRect, presentClosure: ((String, String, String) -> Void)? = nil) {
        self.presentClosure = presentClosure
        super.init(frame: frame)
        
        setupViews()

        fetchData()
        collectionView.reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension RankingFeatureSectionView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        rankingFeatureList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RankingFeatureCollectionViewCell", for: indexPath) as? RankingFeatureCollectionViewCell else { return UICollectionViewCell() }
        let rankingFeature = rankingFeatureList[indexPath.item]
        cell.setup(rankingFeature: rankingFeature)
        return cell
    }
    
}

extension RankingFeatureSectionView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(
            width: collectionView.frame.width - 32,
            height: RankingFeatureCollectionViewCell.height // 셀의 높이 * 3
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let rankingFeature = rankingFeatureList[indexPath.item]
        presentClosure?(rankingFeature.title, rankingFeature.description, "")
    }
    
}

private extension RankingFeatureSectionView {
    
    func setupViews() {
        [titleLabel, showAllAppsButton, collectionView, separator].forEach { addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.top.equalToSuperview().inset(16)
            $0.trailing.equalTo(showAllAppsButton.snp.leading).offset(8)
        }
        
        showAllAppsButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalTo(titleLabel.snp.centerY)
        }
        
        collectionView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.height.equalTo(RankingFeatureCollectionViewCell.height * 3) // 셀에 3개를 표현하기 위해
        }
        
        separator.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.top.equalTo(collectionView.snp.bottom).offset(16)
        }
    }
    
    func fetchData() {
        guard let url = Bundle.main.url(forResource: "RankingFeature", withExtension: "plist") else { return }
        
        do {
            let data = try Data(contentsOf: url)
            let result = try PropertyListDecoder().decode([RankingFeature].self, from: data)
            rankingFeatureList = result
        } catch { }
    }
    
}
