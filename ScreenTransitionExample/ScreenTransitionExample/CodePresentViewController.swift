//
//  CodePresentViewController.swift
//  ScreenTransitionExample
//
//  Created by mijisuh on 2024/02/18.
//

import UIKit

protocol SendDataDelegate: AnyObject { // 이전 화면으로 데이터를 전달하기 위한 프로토콜(Delegate 패턴)
    func sendData(name: String)
}

class CodePresentViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    var name: String?
    weak var delegate: SendDataDelegate? // delegate 변수 앞에는 꼭 weak 붙여줘야 함! -> 강한 순환 참조가 생겨서 메모리 누수 발생 가능
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let name = name {
            self.nameLabel.text = name
            self.nameLabel.sizeToFit()
        }
    }

    @IBAction func tabBackButton(_ sender: Any) {
        self.delegate?.sendData(name: "seom") // 데이터를 전달받을 뷰컨트롤러에서 SendDataDelegate 프로토콜을 채택하고 delegate를 위임받으면 실행됨
        self.presentingViewController?.dismiss(animated: true)
    }
    
}
