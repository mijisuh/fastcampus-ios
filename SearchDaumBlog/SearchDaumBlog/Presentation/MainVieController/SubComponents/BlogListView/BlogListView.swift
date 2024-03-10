//
//  BlogList.swift
//  SearchDaumBlog
//
//  Created by mijisuh on 2024/03/09.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class BlogListView: UITableView {
    
    let disposeBag = DisposeBag()
    
    let headerView = FilterView(
        frame: CGRect(
            origin: .zero,
            size: CGSize(
                width: UIScreen.main.bounds.width,
                height: 50
            )
        )
    )
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        attribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel: BlogListViewModel) {
        headerView.bind(viewModel.filterViewModel)
        
        viewModel.cellData
            .asDriver(onErrorJustReturn: [])
            .drive(self.rx.items) { tableView, row, data in // tableView의 item을 받아서 어떻게 전달할 것인지
                let indexPath = IndexPath(row: row, section: 0) // 첫번째 섹션
                let cell = tableView.dequeueReusableCell(withIdentifier: "BlogListCell", for: indexPath) as! BlogListCell
                cell.setDate(data)
                return cell
            }
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        backgroundColor = .systemBackground
        register(BlogListCell.self, forCellReuseIdentifier: "BlogListCell")
        separatorStyle = .singleLine
        rowHeight = 100
        tableHeaderView = headerView
    }
    
}


