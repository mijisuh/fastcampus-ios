//
//  WriteViewController.swift
//  Tweet
//
//  Created by mijisuh on 2024/03/20.
//

import UIKit
import SnapKit

final class WriteViewController: UIViewController {
    private lazy var presenter = WritePresenter(viewController: self)
    
    private lazy var leftBarButtonItem = UIBarButtonItem(
        title: "닫기",
        style: .plain,
        target: self,
        action: #selector(didTapLeftBarButtonItem)
    )
    
    private lazy var rightBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(
            title: "트윗",
            style: .plain,
            target: self,
            action: #selector(didTapRightBarButtonItem)
        )
        barButtonItem.isEnabled = false
        return barButtonItem
    }()
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 16.0, weight: .medium)
        textView.text = "무슨 일이 일어나고 있나요?"
        textView.textColor = .secondaryLabel
        textView.delegate = self
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
    }
}

extension WriteViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        guard textView.textColor == .secondaryLabel else { return }
        textView.text = nil
        textView.textColor = .label
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.textColor == .secondaryLabel {
            textView.text = nil
            textView.textColor = .label
        } else {
            rightBarButtonItem.isEnabled = !textView.text.isEmpty
            
            if textView.text.isEmpty {
                textView.text = "무슨 일이 일어나고 있나요?"
                textView.textColor = .secondaryLabel
                textView.selectedRange = NSMakeRange(0, 0)
            }
        }
    }
}

extension WriteViewController: WriteProtocol {
    func setupViews() {
        view.backgroundColor = .systemBackground
        
        navigationItem.leftBarButtonItem = leftBarButtonItem
        navigationItem.rightBarButtonItem = rightBarButtonItem
        
        view.addSubview(textView)
        
        let superViewInset: CGFloat = 16.0
        textView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(superViewInset)
            $0.leading.trailing.equalToSuperview().inset(superViewInset)
            $0.height.equalTo(160.0)
        }
    }
    
    func dismiss() {
        navigationController?.dismiss(animated: true)
    }
}

private extension WriteViewController {
    @objc func didTapLeftBarButtonItem() {
        presenter.didTapLeftBarButtonItem()
    }
    
    @objc func didTapRightBarButtonItem() {
        presenter.didTapRightBarButtonItem(text: textView.text)
    }
}
