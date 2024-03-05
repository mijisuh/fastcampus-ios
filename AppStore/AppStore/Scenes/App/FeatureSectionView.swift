//
//  FeatureSectionView.swift
//  AppStore
//
//  Created by mijisuh on 2024/03/04.
//

import UIKit
import SnapKit

final class FeatureSectionView: UIView {
    
    private var featureList: [Feature] = []
    
    private let presentClosure: ((String, String, String) -> Void)?
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true // 가로로 스크롤 시 width에 딱딱 맞게 pagination 됨
        collectionView.backgroundColor = .systemBackground
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.register(FeatureSectionCollectionViewCell.self, forCellWithReuseIdentifier: "FeatureSectionCollectionViewCell")
        
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

extension FeatureSectionView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        featureList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeatureSectionCollectionViewCell", for: indexPath) as? FeatureSectionCollectionViewCell else { return UICollectionViewCell() }
        let feature = featureList[indexPath.item]
        cell.setup(feature: feature)
        return cell
    }
    
}
extension FeatureSectionView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width - 32, height: frame.width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16) // 해당 설정을 안해주면 가운데 정렬이 안됨
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        32
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let feature = featureList[indexPath.item]

        presentClosure?(feature.appName, feature.description, feature.imageURL)
        
//        if let parentViewController = findParentViewController() {
//            let vc = AppDetailViewController(feature: feature)
//            parentViewController.present(vc, animated: true)
//        }
    }
    
}

private extension FeatureSectionView {
    
    func setupViews() {
        [collectionView, separator].forEach { addSubview($0) }
        
        collectionView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.top.equalToSuperview().inset(16)
            $0.height.equalTo(snp.width)
            $0.bottom.equalToSuperview()
        }
        
        separator.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.top.equalTo(collectionView.snp.bottom).offset(16)
            $0.bottom.equalToSuperview()
        }
    }
    
    func fetchData() {
        guard let url = Bundle.main.url(forResource: "Feature", withExtension: "plist") else { return }
        
        do {
            let data = try Data(contentsOf: url)
            let result = try PropertyListDecoder().decode([Feature].self, from: data)
            featureList = result
        } catch { }
    }
    
    func findParentViewController() -> UIViewController? {
        var responder: UIResponder? = self
        while let nextResponder = responder?.next {
            if let viewController = nextResponder as? UIViewController {
                return viewController
            }
            responder = nextResponder
        }
        return nil
    }
    
}
