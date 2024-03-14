//
//  ViewController.swift
//  AttributedString
//
//  Created by mijisuh on 2024/03/14.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6.0 // 줄간
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 20.0, weight: .semibold),
            .foregroundColor: UIColor.systemBrown,
            .paragraphStyle: paragraphStyle
        ]
        
        // NSAttributedString
//        let attributedText = NSAttributedString(
//            string: textView.text,
//            attributes: attributes
//        )
        
//        textView.attributedText = attributedText
        
        // NSMutableAttributedString
        let mutableAttributedString = NSMutableAttributedString(
            string: textView.text,
            attributes: attributes
        )
        
        // 추가되는 속성
        paragraphStyle.paragraphSpacing = 10.0 // 자간
        let additionalAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 30.0, weight: .thin),
            .foregroundColor: UIColor.systemPink,
            .paragraphStyle: paragraphStyle
        ]
        
        // 범위 설정
        mutableAttributedString.addAttributes(additionalAttributes, range: NSRange(location: 3, length: 10)) // 인덱스 3번쨰부터 10개(길이)
        
        textView.attributedText = mutableAttributedString
    }
}

