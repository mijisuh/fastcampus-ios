//
//  LoginViewController.swift
//  SpotifyLoginSampleApp
//
//  Created by mijisuh on 2024/02/25.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn
import AuthenticationServices

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailLoginButton: UIButton!
    @IBOutlet weak var googleLoginButton: GIDSignInButton!
    @IBOutlet weak var appleLoginButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        // Navigation Bar 숨기기
        self.navigationController?.navigationBar.isHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureButton()
    }
    
    private func configureButton() {
        [emailLoginButton, googleLoginButton, appleLoginButton].forEach {
            $0?.layer.borderWidth = 1
            $0?.layer.borderColor = UIColor.white.cgColor
            $0?.layer.cornerRadius = 30
        }
    }
    
    private func showMainViewController() {
        guard let mainViewController = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController else { return }
        mainViewController.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(mainViewController, animated: true)
    }

    @IBAction func googleLoginButtonTapped(_ sender: UIButton) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] user, error in
            if let error = error {
                print("ERROR", error.localizedDescription)
                return
            }
            
            guard let user = user?.user,
                  let idToken = user.idToken
            else { return }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: user.accessToken.tokenString) // credential이란 구글 ID Token(Access Token)을 부여받은 것
            
            Auth.auth().signIn(with: credential) { _, _ in // 구글에서 전달 받은 토큰으로 로그인 시도
                self.showMainViewController()
            }
        }
    }
    
    @IBAction func appleLoginButtonTapped(_ sender: UIButton) { }
    
}
