//
//  MockWriteViewController.swift
//  TweetTests
//
//  Created by mijisuh on 2024/03/20.
//

import XCTest
@testable import Tweet

final class MockWriteViewController: WriteProtocol {
    var isCalledSetupViews = false
    var isCalledDismiss = false
    
    func setupViews() {
        isCalledSetupViews = true
    }
    
    func dismiss() {
        isCalledDismiss = true
    }
}
