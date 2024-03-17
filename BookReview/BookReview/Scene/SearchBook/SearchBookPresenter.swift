//
//  SearchBookPresenter.swift
//  BookReview
//
//  Created by mijisuh on 2024/03/17.
//

import UIKit

protocol SearchBookProtocol { // viewController에게 명령할 일
    func setupView()
    func dismiss()
    func reloadView()
}

protocol SearchBookDelegate {
    func selectBook(_ book: Book)
}

final class SearchBookPresenter: NSObject {
    private let viewController: SearchBookProtocol
    private let bookSearchManager = BookSearchManager()
    
    private let delegate: SearchBookDelegate
    
    private var books: [Book] = []
    
    init(
        viewController: SearchBookProtocol,
        delegate: SearchBookDelegate
    ) {
        self.viewController = viewController
        self.delegate = delegate
    }
    
    func viewDidLoad() {
        viewController.setupView()
    }
}

extension SearchBookPresenter: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        
        bookSearchManager.request(from: searchText) { [weak self] newBooks in
            self?.books = newBooks
            self?.viewController.reloadView()
        }
    }
}

extension SearchBookPresenter: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedBook = books[indexPath.row]
        delegate.selectBook(selectedBook)
        
        viewController.dismiss()
    }
}

extension SearchBookPresenter: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let selectedBook = books[indexPath.row]
        let cell = UITableViewCell()
        cell.textLabel? .text = "\(selectedBook.title)"
        return cell
    }
}
