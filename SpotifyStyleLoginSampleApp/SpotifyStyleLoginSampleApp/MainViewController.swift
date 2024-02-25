//
//  MainViewController.swift
//  SpotifyLoginSampleApp
//
//  Created by mijisuh on 2024/02/25.
//

import UIKit
import FirebaseAuth

class MainViewController: UIViewController {

    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var resetPasswordButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        self.configureView()
        
        // 이메일/비밀번호로 로그인했는지 여부로 비밀번호 재설정 버튼을 보여줄지 결정
        let isEmailSignIn = Auth.auth().currentUser?.providerData[0].providerID == "password"
        self.resetPasswordButton.isHidden = !isEmailSignIn
        
        let email = Auth.auth().currentUser?.email ?? "고객"
        self.welcomeLabel.text = """
                환영합니다.
                \(email)님
            """
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func configureView() {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false // pop 제스쳐를 막음
        self.navigationController?.navigationBar.isHidden = true
    }

    @IBAction func logoutButtonTapped(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        
        do {
            try firebaseAuth.signOut() // 에러 처리를 위한 throw 함수
            self.navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print("ERROR: signout \(signOutError.localizedDescription)")
        }
    }
    
    @IBAction func resetPasswordButtonTapped(_ sender: UIButton) {
        let email = Auth.auth().currentUser?.email ?? ""
        Auth.auth().sendPasswordReset(withEmail: email) // 현재 사용자의 이메일로 비밀번호를 재설정할 수 있는 메일 전송
    }
    
    @IBAction func profileUpdateButtonTapped(_ sender: UIButton) {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = "seom" // 바꿀 닉네임
        changeRequest?.commitChanges { _ in // 커밋을 해줘야 수정사항이 반영됨
            let displayName = Auth.auth().currentUser?.displayName ?? Auth.auth().currentUser?.email ?? "고객"
            
            self.welcomeLabel.text = """
                    환영합니다.
                    \(displayName)님
                """
        }
    }
    
}
