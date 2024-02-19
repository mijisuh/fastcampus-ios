//
//  SeguePresentViewController.swift
//  ScreenTransitionExample
//
//  Created by mijisuh on 2024/02/18.
//

import UIKit

class SeguePresentViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func tabBackButton(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true)
    }
}
