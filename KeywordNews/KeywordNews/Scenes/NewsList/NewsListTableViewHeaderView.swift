//
//  NewsListTableViewHeaderView.swift
//  KeywordNews
//
//  Created by mijisuh on 2024/03/18.
//

import UIKit
import SnapKit
import TTGTags

final class NewsListTableViewHeaderView: UITableViewHeaderFooterView {
    static let identifier = "NewsListTableViewHeaderView"
    
    private var tags: [String] = ["IT", "아이폰", "개발자", "개발", "판교", "게임", "앱개발", "강남", "스타트업"]

    private lazy var tagCollectionView = TTGTextTagCollectionView()
    
    func setup() {
        contentView.backgroundColor = .systemBackground
        
        setupTagCollectionViewLayout()
        setupTagCollectionView()
    }
}

extension NewsListTableViewHeaderView: TTGTextTagCollectionViewDelegate {
    func textTagCollectionView(
        _ textTagCollectionView: TTGTextTagCollectionView!,
        didTap tag: TTGTextTag!,
        at index: UInt
    ) {
        guard tag.selected else { return }
        textTagCollectionView.allSelectedTags().forEach { $0.selected = false } // 선택한 태그 이외의 태그 선택 해제
        textTagCollectionView.updateTag(at: index, selected: true)
        textTagCollectionView.reload()
    }
}

private extension NewsListTableViewHeaderView {
    func setupTagCollectionViewLayout() {
        addSubview(tagCollectionView)
        
        tagCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func setupTagCollectionView() { // Tag 하나하나의 디자인
        tagCollectionView.numberOfLines = 1
        tagCollectionView.scrollDirection = .horizontal
        tagCollectionView.showsHorizontalScrollIndicator = false
//        tagCollectionView.selectionLimit = 1
        tagCollectionView.delegate = self
        
        let insetValue: CGFloat = 16.0
        tagCollectionView.contentInset = UIEdgeInsets(
            top: insetValue,
            left: insetValue,
            bottom: insetValue,
            right: insetValue
        )
        
        let cornerRadiusValue: CGFloat = 12.0
        let shadowOpacityValue: CGFloat = 0.0
        let extraSpaceValue = CGSize(width: 20.0, height: 12.0) // 글씨와 배경 사이 인셋
        let color = UIColor.systemOrange
        
        let style = TTGTextTagStyle()
        style.backgroundColor = color
        style.cornerRadius = cornerRadiusValue
        style.borderWidth = 0.0
        style.shadowOpacity = 0.0
        style.extraSpace = extraSpaceValue
        
        let selectedStyle = TTGTextTagStyle()
        selectedStyle.backgroundColor = .white
        selectedStyle.cornerRadius = cornerRadiusValue
        selectedStyle.shadowOpacity = shadowOpacityValue
        selectedStyle.extraSpace = extraSpaceValue
        selectedStyle.borderColor = color
        
        tags.forEach { tag in
            let font = UIFont.systemFont(ofSize: 14.0, weight: .semibold)
            let tagContents = TTGTextTagStringContent(
                text: tag,
                textFont: font,
                textColor: .white
            )
            let selectedTagContents = TTGTextTagStringContent(
                text: tag,
                textFont: font,
                textColor: color
            )
            let tag = TTGTextTag(
                content: tagContents,
                style: style,
                selectedContent: selectedTagContents,
                selectedStyle: selectedStyle
            )
            
            tagCollectionView.addTag(tag)
        }
        
        tagCollectionView.reload()
    }
}
