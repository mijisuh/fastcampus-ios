//
//  MainViewController.swift
//  SearchDaumBlog
//
//  Created by mijisuh on 2024/03/09.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class MainViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    let searchBar = SearchBar()
    let blogListView = BlogListView()
    
    let alertActionTapped = PublishRelay<AlertAction>()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        bind()
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        // SearchBar에 입력된 텍스트로 네트워크 통신
        let blogResult = searchBar.shouldLoadResult
            .flatMapLatest { query in
                SearchBlogNetwork().searchBlog(query: query)
            }
            .share() // 스트림을 새로 만들지 않고 공유
        
        let blogValue = blogResult
            .compactMap { data -> DKBlog? in
                guard case .success(let value) = data else { return nil }
                return value
            }
        
        let blogError = blogResult
            .compactMap { data -> String? in
                guard case .failure(let error) = data else { return nil }
                return error.localizedDescription
            }
        
        // 네트워크를 통해 가져온 값을 cellData로 만듬
        let cellData = blogValue
            .map { blog -> [BlogListCellData] in
                return blog.documents
                    .map { doc in
                        let thumnailURL = URL(string: doc.thumbnail ?? "") // String -> URL
                        return BlogListCellData(thumbnailURL: thumnailURL, name: doc.name, title: doc.title, datetime: doc.datetime)
                    }
            }
        
        // FilterView를 선택했을 때 나오는 alertSheet를 선택했을 때 type
        let sortedType = alertActionTapped
            .filter {
                switch $0 {
                case .title, .datetime: return true
                default: return false
                }
            }
            .startWith(.title) // 아무 것도 선택하지 않았을 때 초기값
        
        // MainViewController -> BlogLisView
        Observable.combineLatest(
            sortedType,
            cellData
        ) { type, data -> [BlogListCellData] in
            switch type {
            case .title: return data.sorted { $0.title ?? "" < $1.title ?? "" }
            case .datetime: return data.sorted { $0.datetime ?? Date() > $1.datetime ?? Date() } // 최신 날짜 부터
            default: return data
            }
        }
        .bind(to: blogListView.cellData)
        .disposed(by: disposeBag)
        
        // 에러 처리
        let alertForErrorMessage = blogError
            .map { message -> Alert in
                return (
                    title: "앗!",
                    message: "예상치 못한 오류가 발생했습니다. 잠시 후 다시 시도해주세요. \(message)",
                    actions: [.confirm],
                    style: .alert
                )
            }
        
        let alertSheetForSorting = blogListView.headerView.sortButtonTapped
            .map { _ -> Alert in
                return (title: nil, message: nil, actions: [.title, .datetime, .cancel], style: .actionSheet)
            }
        
        Observable
            .merge(
                alertSheetForSorting,
                alertForErrorMessage
            )
            .asSignal(onErrorSignalWith: .empty())
            .flatMapLatest { alert -> Signal<AlertAction> in
                let alertController = UIAlertController(title: alert.title, message: alert.message, preferredStyle: alert.style)
                return self.presentAlertController(alertController, actions: alert.actions)
            }
            .emit(to: alertActionTapped)
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        title = "다음 블로그 검색"
        view.backgroundColor = .systemBackground
    }
    
    private func layout() {
        [searchBar, blogListView].forEach { view.addSubview($0) }
        
        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        blogListView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
}

// Alert
extension MainViewController {
    
    typealias Alert = (title: String?, message: String?, actions: [AlertAction], style: UIAlertController.Style)
    
    enum AlertAction: AlertActionConvertible {
        case title, datetime, cancel
        case confirm
        
        var title: String {
            switch self {
            case .title: return "Title"
            case .datetime: return "Datetime"
            case .cancel: return "취소"
            case .confirm: return "확인"
            }
        }
        
        var style: UIAlertAction.Style {
            switch self {
            case .title, .datetime: return .default
            case .cancel, .confirm: return .cancel
            }
        }
    }
    
    // Alert 액션을 받았을 때 AlertController 생성
    func presentAlertController<Action: AlertActionConvertible>(_ alertController: UIAlertController, actions: [Action]) -> Signal<Action> {
        if actions.isEmpty { return .empty() }
        return Observable
            .create { [weak self] observer in
                guard let self = self else { return Disposables.create() }
                
                for action in actions {
                    alertController.addAction(
                        UIAlertAction(
                            title: action.title,
                            style: action.style
                        ) { _ in
                            observer.onNext(action)
                            observer.onCompleted()
                        }
                    )
                }
                
                self.present(alertController, animated: true)
                
                return Disposables.create {
                    alertController.dismiss(animated: true)
                }
            }
            .asSignal(onErrorSignalWith: .empty())
    }
    
}
