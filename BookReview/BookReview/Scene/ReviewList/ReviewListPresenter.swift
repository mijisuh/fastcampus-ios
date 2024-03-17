//
//  ReviewListPresenter.swift
//  BookReview
//
//  Created by mijisuh on 2024/03/17.
//

import UIKit
import Kingfisher

protocol ReviewListProtocol { // ReviewListViewController가 해야 할 일
    func setupNavigationBar()
    func setupViews()
    func presentToReviewWriteViewController()
    func reloadTableView()
}

final class ReviewListPresenter: NSObject {
    private let viewController: ReviewListProtocol
    private let userDefaultsManager: UserDefaultsManagerProtocol
    
    private var reviews: [BookReview] = []
    
    init(
        viewController: ReviewListProtocol,
        userDefaultsManager: UserDefaultsManagerProtocol = UserDefaultsManager()
    ) {
        self.viewController = viewController
        self.userDefaultsManager = userDefaultsManager
    }
    
    func viewDidLoad() {
        viewController.setupNavigationBar() // View에게 NavigationBar를 setup하라고 명령
        viewController.setupViews()
    }
    
    func viewWillAppear() {
        reviews = userDefaultsManager.getReviews()
        viewController.reloadTableView()
    }
    
    func didTapRightBarButtonItem() {
        viewController.presentToReviewWriteViewController()
    }
}

extension ReviewListPresenter: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let review = reviews[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = "\(review.title)"
        cell.detailTextLabel?.text = "\(review.contents)"
        cell.imageView?.kf.setImage(with: review.imageURL) { _ in
            cell.setNeedsLayout() // 뷰가 그려지면 다시 업데이트되도록 설정
        }
        cell.selectionStyle = .none
        return cell
    }
}
