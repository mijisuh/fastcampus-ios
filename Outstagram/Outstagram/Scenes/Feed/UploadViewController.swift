//
//  UploadViewController.swift
//  Outstagram
//
//  Created by mijisuh on 2024/03/06.
//

import UIKit
import SnapKit

final class UploadViewController: UIViewController {
    
    private let uploadImage: UIImage
    
    private let imageView = UIImageView()
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.text = "문구 입력..."
        textView.textColor = .secondaryLabel
        textView.font = .systemFont(ofSize: 15)
        textView.delegate = self
        return textView
    }()
    
    init(uploadImage: UIImage) {
        self.uploadImage = uploadImage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        setupNavigationBar()
        setupLayout()
        
        imageView.image = uploadImage
    }
    
}

extension UploadViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        guard textView.textColor == .secondaryLabel else { return } // placeHolder 상태일 때
        
        textView.text = nil // 텍스트를 지우고
        textView.textColor = .label // 텍스트 컬러를 검정색으로 변경
    }
    
}

private extension UploadViewController {
    
    func setupNavigationBar() {
        navigationItem.title = "새 게시물 작성"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "취소",
            style: .plain,
            target: self,
            action: #selector(didTabLeftButton)
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "공유",
            style: .plain,
            target: self,
            action: #selector(didTabRightButton)
        )
    }
    
    @objc func didTabLeftButton() {
        dismiss(animated: true)
    }
    
    @objc func didTabRightButton() {
        dismiss(animated: true)
    }
    
    func setupLayout() {
        [imageView, textView].forEach { view.addSubview($0) }
        
        let imageViewInset: CGFloat = 16
        
        imageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(imageViewInset)
            $0.leading.equalToSuperview().inset(imageViewInset)
            $0.width.equalTo(100)
            $0.height.equalTo(imageView.snp.width)
        }
        
        textView.snp.makeConstraints {
            $0.leading.equalTo(imageView.snp.trailing).offset(imageViewInset)
            $0.trailing.equalToSuperview().inset(imageViewInset)
            $0.top.equalTo(imageView.snp.top)
            $0.bottom.equalTo(imageView.snp.bottom)
            
        }
    }
    
}
