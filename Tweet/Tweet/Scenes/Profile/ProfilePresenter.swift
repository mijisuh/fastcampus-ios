//
//  ProfilePresenter.swift
//  Tweet
//
//  Created by mijisuh on 2024/03/20.
//

import UIKit

protocol ProfileProtocol: AnyObject {
    func setupViews()
    func setViews(with user: User)
    func endEditing()
    func showToast()
}

final class ProfilePresenter {
    private weak var viewController: ProfileProtocol?
    
    private var user: User {
        get { User.shared }
        set { User.shared = newValue } // 별도의 메서드 구현 X
    }
    
    init(viewController: ProfileProtocol) {
        self.viewController = viewController
    }
    
    func viewWillAppear() {
        viewController?.setViews(with: user)
    }
    
    func viewDidLoad() {
        viewController?.setupViews()
    }
    
    func didTapSaveButton(name: String?, account: String?) {
        viewController?.endEditing()
        
        guard let name = name,
              let account = account,
              !name.isEmpty,
              !account.isEmpty
        else {
            viewController?.showToast()
            return
        }
        
        user = User(name: name, account: account)
        
        viewController?.setViews(with: user)
    }
}
