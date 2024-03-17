//
//  MockReviewWriteViewController.swift
//  BookReviewTests
//
//  Created by mijisuh on 2024/03/18.
//

import Foundation

@testable import BookReview

final class MockReviewWriteViewController: ReviewWriteProtocol {
    var isCalledSetupNavigationBar =  false
    var isCalledShowCloseAlertController = false
    var isCalledClose = false
    var isCalledSetupViews = false
    var isCalledPresentToSearchBookViewController = false
    var isCalledUpdateViews = false
    
    func setupNavigationBar() {
        isCalledSetupNavigationBar = true
    }
    
    func showCloseAlertController() {
        isCalledShowCloseAlertController = true
    }
    
    func close() {
        isCalledClose = true
    }
    
    func setupViews() {
        isCalledSetupViews = true
    }
    
    func presentToSearchBookViewController() {
        isCalledPresentToSearchBookViewController = true
    }
    
    func updateViews(title: String, imageURL: URL?) {
        isCalledUpdateViews = true
    }
}
