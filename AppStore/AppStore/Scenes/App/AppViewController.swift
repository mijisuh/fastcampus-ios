//
//  AppViewController.swift
//  AppStore
//
//  Created by mijisuh on 2024/03/04.
//

import UIKit
import SnapKit

final class AppViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing // 간격만 동일하게 설정
        stackView.spacing = 0 // 서브 뷰가 자유롭게 자신의 높이를 설정
        
        // 클로저를 이용한 화면 이동
        let presentClosure: (String, String, String) -> Void = { [weak self] appTitle, subTitle, imageURL in
            guard let self = self else { return }
            let vc = AppDetailViewController(appTitle: appTitle, subTitle: subTitle, imageURL: imageURL)

            // 부모 뷰 컨트롤러에서 자식 뷰 컨트롤러로 전달하고 싶은 작업 수행
            self.present(vc, animated: true)
        }
        
        let featureSectionView = FeatureSectionView(frame: .zero, presentClosure: presentClosure)
        let rankingFeatureSectionView = RankingFeatureSectionView(frame: .zero, presentClosure: presentClosure)
        let exchangeCodeButtonView = ExchangeCodeButtonView(frame: .zero)
        
        let spacingView = UIView()
        spacingView.snp.makeConstraints {
            $0.height.equalTo(100)
        }
        
        [
            featureSectionView,
            rankingFeatureSectionView,
            exchangeCodeButtonView,
            spacingView
        ].forEach {
            stackView.addArrangedSubview($0)
        }
        
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationController()
        setupLayout()
    }
    
}

// 뷰를 설정하는 코드
private extension AppViewController {
    
    func setupNavigationController() {
        navigationItem.title = "앱"
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupLayout() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview() // width가 고정이 되어 세로 스크롤만 가능해짐
        }
        
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
}
