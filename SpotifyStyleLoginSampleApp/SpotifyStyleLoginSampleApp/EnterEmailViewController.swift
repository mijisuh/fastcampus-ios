//
//  EnterEmailViewController.swift
//  SpotifyLoginSampleApp
//
//  Created by mijisuh on 2024/02/25.
//

import UIKit
import Firebase

class EnterEmailViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    var navigationBar: UINavigationItem?
    
    override func viewWillAppear(_ animated: Bool) {
        self.configureView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureTextField()
    }
    
    private func configureView() {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.title = "이메일/비밀번호 입력하기"
        
        self.nextButton.layer.cornerRadius = 30
        self.nextButton.isEnabled = false
    }
    
    private func configureTextField() {
        self.emailTextField.delegate = self // 텍스트 필드로부터 텍스트 값을 가져오기 위함
        self.passwordTextField.delegate = self
        
        // 처음 화면에 들어섰을 때 자동으로 커서가 텍스트필드에 위치하도록 설정
        self.emailTextField.becomeFirstResponder()
    }
    
    private func showMainViewController() {
        guard let mainViewController = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController else { return }
        mainViewController.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(mainViewController, animated: true)
    }
    
    private func loginUser(withEmail email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] _, error in
            guard let self = self else { return }
            
            if let error = error {
                self.errorMessageLabel.text = error.localizedDescription
            } else {
                self.showMainViewController()
            }
        }
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        // Firebase 이메일/비밀번호 인증
        let email = self.emailTextField.text ?? ""
        let password = self.passwordTextField.text ?? ""
        
        // 신규 사용자 생성
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in // 클로저로 결과값 받음
            guard let self = self else { return }
            
            if let error = error {
                let code = (error as NSError).code
                switch code {
                case 17007: // 이미 가입한 계정일 때
                    self.loginUser(withEmail: email, password: password)
                default:
                    self.errorMessageLabel.text = error.localizedDescription
                }
            } else {
                self.showMainViewController()
            }
        }
    }
    
}

extension EnterEmailViewController: UITextFieldDelegate {
    
    // 이메일, 비밀번호 입력이 끝나면 키보드가 내려가도록
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let isEmailEmpty = self.emailTextField.text == ""
        let isPasswordEmpty = self.passwordTextField.text == ""
        
        self.nextButton.isEnabled = !isEmailEmpty && !isPasswordEmpty
    }
    
}
