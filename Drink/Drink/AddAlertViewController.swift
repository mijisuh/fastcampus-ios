//
//  AddAlertViewController.swift
//  Drink
//
//  Created by mijisuh on 2024/02/28.
//

import UIKit

class AddAlertViewController: UIViewController {
    
    var pickedDate: ((_ date: Date) -> Void)?

    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        // 설정한 시간 값을 부모 뷰에 전달
        pickedDate?(datePicker.date) // 클로저 이용
        self.dismiss(animated: true)
    }
    
}
