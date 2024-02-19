//
//  ViewController.swift
//  ScreenTransitionExample
//
//  Created by mijisuh on 2024/02/18.
//

import UIKit

class ViewController: UIViewController, SendDataDelegate {

    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ViewController 뷰가 로드되었다.")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("ViewController 뷰가 나타날 것이다.")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("ViewController 뷰가 나타났다.")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("ViewController 뷰가 사라질 것이다.")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("ViewController 뷰가 사라졌다.")
    }
    
    // 세그웨이를 실행하기 직전에 시스템에 의해서 자동으로 호출
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? SeguePushViewController {
            viewController.name = "seom"
        }
    }

    @IBAction func tabCodePushButton(_ sender: Any) {
        // 스토리보드로 정의한 뷰컨트롤러를 인스턴스화
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "CodePushViewController") as? CodePushViewController else { return } // 각 타입에 맞는 뷰컨트롤러 타입으로 다운캐스팅할 경우 각 뷰컨트롤러에 정의 프로퍼티에 접근 가능
        
        viewController.name = "seom" // 데이터 전달
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    @IBAction func tabCodePresentButton(_ sender: Any) {
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "CodePresentViewController") as? CodePresentViewController else { return }
        
        viewController.name = "seom"
        
        viewController.delegate = self
        
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true)
    }
    
    func sendData(name: String) { // 프로토콜 준수
        self.nameLabel.text = name
        self.nameLabel.sizeToFit() // 텍스트에 맞게 라벨 사이즈 조절
    }
    
}

