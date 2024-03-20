//
//  MockProfileViewController.swift
//  TweetTests
//
//  Created by mijisuh on 2024/03/20.
//

import XCTest
@testable import Tweet

final class MockProfileViewController: ProfileProtocol {
    var isCalledSetupViews = false
    var isCalledSetViews = false
    var isCalledEndEditing = false
    var isCalledShowToast = false
    
    func setupViews() {
        isCalledSetupViews = true
    }
    
    func setViews(with user: User) {
        isCalledSetViews = true
    }
    
    func endEditing() {
        isCalledEndEditing = true
    }
    
    func showToast() {
        isCalledShowToast = true
    }
}
