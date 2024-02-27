//
//  NoticeViewController.swift
//  Notice
//
//  Created by mijisuh on 2024/02/27.
//

import UIKit

class NoticeViewController: UIViewController {

    var noticeContents: (title: String, detail: String, date: String)?
    
    @IBOutlet weak var noticeView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.configureView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func configureView() {
        self.noticeView.layer.cornerRadius = 6
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        guard let noticeContents = self.noticeContents else { return }
        self.titleLabel.text = noticeContents.title
        self.detailLabel.text = noticeContents.detail
        self.dateLabel.text = noticeContents.date
    }

    @IBAction func doneButtonTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}
