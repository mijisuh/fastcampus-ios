//
//  CodePushViewController.swift
//  ScreenTransitionExample
//
//  Created by mijisuh on 2024/02/18.
//

import UIKit

class CodePushViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    var name: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let name = name {
            self.nameLabel.text = name
            self.nameLabel.sizeToFit()
        }
    }
    
    @IBAction func tabBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
