//
//  MockReviewListViewController.swift
//  BookReviewTests
//
//  Created by mijisuh on 2024/03/18.
//

import Foundation

@testable import BookReview

final class MockReviewListViewController: ReviewListProtocol {
    var isCalledSetupNavigationBar = false
    var isCalledSetupViews = false
    var isCalledPresentToReviewWriteViewController = false
    var isCalledReloadTableView = false
    
    func setupNavigationBar() {
        isCalledSetupNavigationBar = true
    }
    
    func setupViews() {
        isCalledSetupViews = true
    }
    
    func presentToReviewWriteViewController() {
        isCalledPresentToReviewWriteViewController = true
    }
    
    func reloadTableView() {
        isCalledReloadTableView = true
    }
}
