//
//  ProfileViewController.swift
//  Tweet
//
//  Created by mijisuh on 2024/03/20.
//

import UIKit
import SnapKit
import Toast

final class ProfileViewController: UIViewController {
    private lazy var presenter = ProfilePresenter(viewController: self)
    
    private lazy var userNameTextField: UITextField = {
        let textField = UITextField()
        textField.font = .systemFont(ofSize: 20.0, weight: .medium)
        textField.delegate = self
        return textField
    }()
    
    private lazy var userAccountTextField: UITextField = {
        let textField = UITextField()
        textField.font = .systemFont(ofSize: 16.0, weight: .bold)
        textField.delegate = self
        return textField
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("저장하기", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15.0, weight: .bold)
        button.contentEdgeInsets = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
        button.layer.cornerRadius = 15.0
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
        return button
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter.viewWillAppear()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
    }
}

extension ProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool { // 리턴 키 클릭 시 키보드가 내려가도록 설정
        textField.resignFirstResponder()
        return true
    }
}

extension ProfileViewController: ProfileProtocol {
    func setupViews() {
        navigationItem.title = TabBarItem.profile.title
        
        [
            userNameTextField,
            userAccountTextField,
            saveButton
        ].forEach { view.addSubview($0) }
        
        let superViewInset: CGFloat = 16.0
        
        userNameTextField.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(superViewInset)
            $0.leading.trailing.equalToSuperview().inset(superViewInset)
        }
        
        userAccountTextField.snp.makeConstraints {
            $0.top.equalTo(userNameTextField.snp.bottom).offset(superViewInset)
            $0.leading.trailing.equalTo(userNameTextField)
        }
        
        saveButton.snp.makeConstraints {
            $0.top.equalTo(userAccountTextField.snp.bottom).offset(32.0)
            $0.leading.trailing.equalTo(userAccountTextField)
        }
    }
    
    func setViews(with user: User) {
        userNameTextField.text = user.name
        userAccountTextField.text = user.account
    }
    
    func endEditing() {
        view.endEditing(true)
    }
    
    func showToast() {
        view.makeToast("변경하고자 하는 내용을 입력해주세요.")
    }
}

private extension ProfileViewController {
    @objc func didTapSaveButton() {
        presenter.didTapSaveButton(name: userNameTextField.text, account: userAccountTextField.text)
    }
}
