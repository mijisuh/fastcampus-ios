//
//  MovieReviewUITests.swift
//  MovieReviewUITests
//
//  Created by mijisuh on 2024/03/18.
//

import XCTest

final class MovieReviewUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false // 테스트 중 하나라도 실패할 경우 앱 자체 종료
        
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDown() {
        super.tearDown()
        
        app = nil
    }
    
    func test_navigationBar의_title이_영화평점으로_설정되어_있는지() {
        let existNavigationBar = app
            .navigationBars["영화 평점"]
            .exists // 모든 NavigationBar를 확인
        XCTAssertTrue(existNavigationBar)
    }
    
    func test_searchBar가_존재하는지() {
        let existSearchBar = app
            .navigationBars["영화 평점"]
            .searchFields["Search"]
            .exists // 모든 NavigationBar를 확인
        XCTAssertTrue(existSearchBar)
    }
    
    func test_searchBar의_cancel버튼이_존재하는지() {
        let navigationBar = app
            .navigationBars["영화 평점"]
        navigationBar
            .searchFields["Search"]
            .tap()
        
        let existSearchBarCancelButton = navigationBar
            .buttons["Cancel"]
            .exists
        
        XCTAssertTrue(existSearchBarCancelButton)
    }
    
    func test_test() {
        // 녹화 버튼을 누르면 테스트가 자동으로 작성됨
        // 현업에서 잘 사용되지 않지만 작성 방법에 대해 알 수 있음
    }
}
