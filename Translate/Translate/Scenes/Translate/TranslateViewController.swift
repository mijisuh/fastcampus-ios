//
//  TranslateViewController.swift
//  Translate
//
//  Created by mijisuh on 2024/03/14.
//

import UIKit
import SnapKit

final class TranslateViewController: UIViewController {
    private var translationManager = TranslationManager()
    
    private lazy var sourceLanguageButton: UIButton = {
        let button = UIButton()
        button.setTitle(translationManager.sourceLanguage.title, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15.0, weight: .semibold)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .systemBackground
        button.layer.cornerRadius = 9.0
        button.addTarget(self, action: #selector(didTapSourceLanguageButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var targetLanguageButton: UIButton = {
        let button = UIButton()
        button.setTitle(translationManager.targetLanguage.title, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15.0, weight: .semibold)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .systemBackground
        button.layer.cornerRadius = 9.0
        button.addTarget(self, action: #selector(didTapTargetLanguageButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8.0
        
        [sourceLanguageButton, targetLanguageButton].forEach { stackView.addArrangedSubview($0) }
        
        return stackView
    }()
    
    private lazy var resultBaseView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private lazy var resultLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 23, weight: .bold)
        label.textColor = UIColor.mainTintColor
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var bookmarkButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "bookmark"), for: .normal)
        button.addTarget(self, action: #selector(didTapBookmarkButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var copyButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "doc.on.doc"), for: .normal)
        button.addTarget(self, action: #selector(didTapCopyButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var sourceBaseView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapSourceBaseView))
        view.addGestureRecognizer(tapGesture)
        
        return view
    }()
    
    private lazy var sourceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 23, weight: .semibold)
        // sourceLabel에 입력값이 추가되면, placeHolder 스타일 해지
        label.textColor = .tertiaryLabel
        label.text = NSLocalizedString("Enter_text", comment: "텍스트 입력")
        label.numberOfLines = 0
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
}

extension TranslateViewController: SourceTextViewControllerDelegate {
    func didReturnText(_ sourceText: String) {
        guard !sourceText.isEmpty else { return }
        
        sourceLabel.text = sourceText
        sourceLabel.textColor = .label
        
        bookmarkButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
        
        // Translate
        translationManager
            .translate(from: sourceText) { [weak self] translatedText in
            DispatchQueue.main.async {
                self?.resultLabel.text = translatedText
            }
        }
    }
}

private extension TranslateViewController {
    func setupViews() {
        view.backgroundColor = .secondarySystemBackground
        
        [
            buttonStackView,
            resultBaseView,
            resultLabel,
            bookmarkButton,
            copyButton,
            sourceBaseView,
            sourceLabel
        ].forEach { view.addSubview($0) }
        
        let defaultSpacing: CGFloat = 16.0
        
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide) // status 바 고려
            $0.leading.trailing.equalToSuperview().inset(defaultSpacing)
            $0.height.equalTo(50)
        }
        
        resultBaseView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(buttonStackView.snp.bottom).offset(defaultSpacing)
            // 컨텐츠 사이즈에 맞게 가변 높이를 가짐
            $0.bottom.equalTo(bookmarkButton).offset(defaultSpacing)
        }
        
        // 라벨의 height을 고정하지 않고 자유롭게 늘어날 수 있도록 설정
        resultLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(resultBaseView).inset(24.0)
        }
        
        bookmarkButton.snp.makeConstraints {
            $0.leading.equalTo(resultLabel)
            $0.top.equalTo(resultLabel.snp.bottom).offset(24.0)
            $0.width.equalTo(40)
            $0.height.equalTo(bookmarkButton.snp.width)
        }
        
        copyButton.snp.makeConstraints {
            $0.leading.equalTo(bookmarkButton.snp.trailing).inset(8.0)
            $0.top.equalTo(bookmarkButton)
            $0.width.equalTo(40)
            $0.height.equalTo(copyButton.snp.width)
        }
        
        sourceBaseView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(resultBaseView.snp.bottom).offset(defaultSpacing)
            // 탭 바 높이에 맞춰지도록
            $0.bottom.equalToSuperview().offset(tabBarController?.tabBar.frame.height ?? 0.0)
        }
        
        sourceLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(sourceBaseView).inset(24.0)
        }
    }
    
    @objc func didTapSourceBaseView() {
        let viewController = SourceTextViewController(delegate: self)
        present(viewController, animated: true)
    }
    
    // enum은 Objective-C에 없어서 @objc 메서드에서 사용 불가
    @objc func didTapSourceLanguageButton() {
        didTapLanguageButton(type: .source)
    }
    
    @objc func didTapTargetLanguageButton() {
        didTapLanguageButton(type: .target)
    }
    
    func didTapLanguageButton(type: LanguageType) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        Language.allCases.forEach { language in
            let action = UIAlertAction(title: language.title, style: .default) { [weak self] _ in
                switch type {
                case .source:
                    self?.translationManager.sourceLanguage = language
                    self?.sourceLanguageButton.setTitle(language.title, for: .normal)
                case .target:
                    self?.translationManager.targetLanguage = language
                    self?.targetLanguageButton.setTitle(language.title, for: .normal)
                }
            }
            alertController.addAction(action)
        }
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "취소하기"), style: .cancel)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    @objc func didTapBookmarkButton() {
        guard let sourceText = sourceLabel.text,
              let translatedText = resultLabel.text,
              bookmarkButton.imageView?.image == UIImage(systemName: "bookmark")
        else { return }
        
        bookmarkButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        
        let currentBookmarks: [Bookmark] = UserDefaults.standard.bookmarks
        let newBookmark = Bookmark(
            sourceLanguage: translationManager.sourceLanguage,
            translatedLanguage: translationManager.targetLanguage,
            sourceText: sourceText,
            translatedText: translatedText
        )
        
        UserDefaults.standard.bookmarks = [newBookmark] + currentBookmarks
        
        print(UserDefaults.standard.bookmarks)
    }
    
    @objc func didTapCopyButton() {
        UIPasteboard.general.string = resultLabel.text
    }
}

