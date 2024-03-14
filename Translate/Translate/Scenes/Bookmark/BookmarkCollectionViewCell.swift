//
//  BookmarkCollectionViewCell.swift
//  Translate
//
//  Created by mijisuh on 2024/03/14.
//

import UIKit
import SnapKit

final class BookmarkCollectionViewCell: UICollectionViewCell {
    static let identifier = "BookmarkCollectionViewCell"
    
    private var sourceBookmarkStackView: BookmarkTextStackView! // 무조건 있다고 보장되는 값
    private var targetBookmarkStackView: BookmarkTextStackView!
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 16.0
        
        // stackView 자체의 inset 설정
        // $0.edges.equalToSuperview().inset(16.0)으로 하면 width가 문제
        stackView.layoutMargins = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
        stackView.isLayoutMarginsRelativeArrangement = true

        return stackView
    }()
    
    func setup(from bookmark: Bookmark) {
        backgroundColor = .systemBackground
        layer.cornerRadius = 12.0
        
        // stackView가 불려지는 타이밍 전에 값을 넣어야 함
        sourceBookmarkStackView = BookmarkTextStackView(
            language: bookmark.sourceLanguage,
            text: bookmark.sourceText,
            type: .source
        )
        
        targetBookmarkStackView = BookmarkTextStackView(
            language: bookmark.translatedLanguage,
            text: bookmark.translatedText,
            type: .target
        )
        
        // stackView의 subView을 다시 그려줌
        stackView.subviews.forEach {
            $0.removeFromSuperview() // 삭제를 안해주면 생성될 때마다 계속 쌓임
        }
        [sourceBookmarkStackView, targetBookmarkStackView].forEach { stackView.addArrangedSubview($0) }
        
        addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(UIScreen.main.bounds.size.width - 32.0)
        }
        
        // stackView가 레이아웃을 설정한 후에 전체적으로 다시 업데이트
        layoutIfNeeded()
    }
}
