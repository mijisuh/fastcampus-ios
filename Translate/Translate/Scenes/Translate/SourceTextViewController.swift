//
//  SourceTextViewController.swift
//  Translate
//
//  Created by mijisuh on 2024/03/14.
//

import UIKit
import SnapKit

protocol SourceTextViewControllerDelegate: AnyObject {
    func didReturnText(_ sourceText: String)
}

final class SourceTextViewController: UIViewController {
    private let placeHolderText = "텍스트 입력"
    
    private weak var delegate: SourceTextViewControllerDelegate? // TranslateViewController와도 연결되어 있으므로 메모리 누수 위험 있음
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.text = placeHolderText
        textView.textColor = .secondaryLabel
        textView.font = .systemFont(ofSize: 18.0, weight: .semibold)
        textView.returnKeyType = .done
        textView.delegate = self
        return textView
    }()
    
    init(delegate: SourceTextViewControllerDelegate?) {
        self.delegate = delegate // 파라미터로 주입
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(textView)
        textView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16.0)
        }
    }
}

extension SourceTextViewController: UITextViewDelegate {
    // PlaceHolder 기능 구현
    func textViewDidBeginEditing(_ textView: UITextView) {
        guard textView.textColor == .secondaryLabel else { return }
        
        textView.text = nil
        textView.textColor = .label
    }

    // return 버튼 클릭 시 dismiss
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // text에 returnKey 값이 들어왔을 때
        guard text == "\n" else { return true }
        dismiss(animated: true)
//        textView.resignFirstResponder() // 키보드는 현재 뷰컨트롤러에 종속되어 있기 때문에 따로 내려줄 필요 X
        delegate?.didReturnText(textView.text)
        return true
    }
}
