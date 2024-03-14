//
//  BookmarkListViewController.swift
//  Translate
//
//  Created by mijisuh on 2024/03/14.
//

import UIKit
import SnapKit

final class BookmarkListViewController: UIViewController {
    private var bookmarks: [Bookmark] = []
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        let inset: CGFloat = 16.0
        layout.estimatedItemSize = CGSize(width: view.frame.width - inset * 2, height: 100.0) // 셀의 최소 사이즈
        layout.sectionInset = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset) // collectionView 자체의 inset
        layout.minimumInteritemSpacing = inset // 줄 사이 간격
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .secondarySystemBackground
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(BookmarkCollectionViewCell.self, forCellWithReuseIdentifier: BookmarkCollectionViewCell.identifier)
        return collectionView
    }()
    
    override func viewWillAppear(_ animated: Bool) { // 최신 정보를 보여줘야 하기 때문
        super.viewWillAppear(animated)
        
        bookmarks = UserDefaults.standard.bookmarks
        
        collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
    }
}

extension BookmarkListViewController: UICollectionViewDelegateFlowLayout {
    
}

extension BookmarkListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        bookmarks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookmarkCollectionViewCell.identifier, for: indexPath) as? BookmarkCollectionViewCell else { return UICollectionViewCell() }
        cell.setup(from: bookmarks[indexPath.item])
        return cell
    }
}

private extension BookmarkListViewController {
    func setupLayout() {
        navigationItem.title = "즐겨찾기"
        navigationController?.navigationBar.prefersLargeTitles = true // 무조건 largeTitle로 설정
        
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
