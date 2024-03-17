//
//  ReviewWritePresenter.swift
//  BookReview
//
//  Created by mijisuh on 2024/03/17.
//

import Foundation

protocol ReviewWriteProtocol {
    func setupNavigationBar()
    func showCloseAlertController()
    func close()
    func setupViews()
    func presentToSearchBookViewController()
    func updateViews(title: String, imageURL: URL?)
}

final class ReviewWritePresenter: NSObject {
    private let viewController: ReviewWriteProtocol
    private let userDefaultsManager: UserDefaultsManagerProtocol
    
    var book: Book?
    
    let contentsTextViewPlaceHolder = "내용을 입력해주세요."
    
    init(
        viewController: ReviewWriteProtocol,
        userDefaultsManager: UserDefaultsManagerProtocol = UserDefaultsManager()
    ) {
        self.viewController = viewController
        self.userDefaultsManager = userDefaultsManager
    }
    
    func viewDidLoad() {
        viewController.setupNavigationBar()
        viewController.setupViews()
    }
    
    func didTapLeftBarButtonItem() {
        viewController.showCloseAlertController()
    }
    
    func didTapRightBarButtonItem(contentsText: String?) {
        viewController.close()
        
        guard let book = book,
              let contentsText = contentsText,
              contentsText != contentsTextViewPlaceHolder
        else { return }
        let bookReview = BookReview(
            title: book.title,
            contents: contentsText,
            imageURL: book.imageURL
        )
        userDefaultsManager.setReview(bookReview)
    }
    
    func didTapBookTitleButton() {
        viewController.presentToSearchBookViewController()
    }
}

extension ReviewWritePresenter: SearchBookDelegate {
    func selectBook(_ book: Book) {
        self.book = book
        viewController.updateViews(title: book.title, imageURL: book.imageURL)
    }
}
