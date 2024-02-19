//
//  ViewController.swift
//  LEDBoard
//
//  Created by mijisuh on 2024/02/19.
//

import UIKit

class ViewController: UIViewController, LEDBoardSettinfDelegate {

    @IBOutlet weak var contentsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.contentsLabel.textColor = .yellow
    }
    
    // Segueway 연결
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let settingViewController = segue.destination as? SettingViewController {
            settingViewController.delegate = self
            settingViewController.ledText = self.contentsLabel.text
            settingViewController.textColor = self.contentsLabel.textColor
            settingViewController.backgroundColor = self.view.backgroundColor ?? .black
        }
    }

    func changedSetting(text: String?, textColor: UIColor, backgroundColor: UIColor) {
        if let text = text { self.contentsLabel.text = text }
        self.contentsLabel.textColor = textColor
        self.view.backgroundColor = backgroundColor
    }
}

