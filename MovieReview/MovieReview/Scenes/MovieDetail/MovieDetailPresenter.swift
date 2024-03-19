//
//  MovieDetailPresenter.swift
//  MovieReview
//
//  Created by mijisuh on 2024/03/19.
//

import Foundation

protocol MovieDetailProtocol: AnyObject {
    
}

final class MovieDetailPresenter: NSObject {
    private let viewController: MovieDetailProtocol
    
    init(viewController: MovieDetailProtocol) {
        self.viewController = viewController
    }
    
    func viewDidLoad() {
        
    }
}
