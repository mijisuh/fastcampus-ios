//
//  RepositoryListViewController.swift
//  GitHubRepository
//
//  Created by mijisuh on 2024/03/08.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class RepositoryListViewController: UITableViewController {
    
    private let organization = "Apple" // OR ReactiveX
    private let repositories = BehaviorSubject<[Repository]>(value: [])
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Navigation Bar Title
        title = organization + " Repositories"
        
        // GitHub API를 불러올 트리거가 되는 액션
        refreshControl = UIRefreshControl()
        
        let refreshControl = refreshControl!
        refreshControl.backgroundColor = .systemBackground
        refreshControl.tintColor = .darkGray
        refreshControl.attributedTitle = NSAttributedString(string: "당겨서 새로고침") // 인디케이터 아래에 있는 글자
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        tableView.register(RepositoryListCell.self, forCellReuseIdentifier: "RepositoryListCell")
        tableView.rowHeight = 140
    }
    
    @objc private func refresh() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            self.fetchRepositories(of: organization)
        }
    }
    
    private func fetchRepositories(of organization: String) {
        Observable.from([organization])
            .map { organization -> URL in
                return URL(string: "https://api.github.com/orgs/\(organization)/repos")!
            }
            .map { url -> URLRequest in
                var request = URLRequest(url: url)
                request.httpMethod = "GET"
                return request
            }
            .flatMap { urlRequest -> Observable<(response: HTTPURLResponse, data: Data)> in
                return URLSession.shared.rx.response(request: urlRequest) //.rx: Swift에서 기본적으로 제공하는 인자들을 rx로 변환
            }
            .filter { response, _ in
                return 200..<300 ~= response.statusCode
            }
            .map { _, data -> [[String: Any]] in
                guard let json = try? JSONSerialization.jsonObject(with: data),
                      let result = json as? [[String: Any]]
                else { return [] }
                return result
            }
            .filter { result in
                result.count > 0
            }
            .map { objects in
                return objects.compactMap { dic -> Repository? in // compactMap은 자동적으로 nil 값은 제거해서 반환
                    guard let id = dic["id"] as? Int,
                          let name = dic["name"] as? String,
                          let description = dic["description"] as? String,
                          let starGazersCount = dic["stargazers_count"] as? Int,
                          let language = dic["language"] as? String
                    else { return nil }
                    
                    return Repository(
                        id: id,
                        name: name,
                        description: description,
                        starGazersCount: starGazersCount,
                        language: language
                    )
                }
            } // 구독을 하기 전까지는 아무런 역할을 하지 않음
            .subscribe(
                onNext: { [weak self] newRepositories in
                    self?.repositories.onNext(newRepositories) // repositories는 초기값이 아닌 newRepositories 값을 받음
                    
                    // 아직 UI Bind를 배우지 않아서 DispatchQueue 사용
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                        self?.refreshControl?.endRefreshing()
                    }
                }
            )
            .disposed(by: disposeBag)
    }
    
}

extension RepositoryListViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        do {
            return try repositories.value().count
        } catch {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RepositoryListCell", for: indexPath) as? RepositoryListCell else { return UITableViewCell() }
        
        var currentRepo: Repository? {
            do {
                return try repositories.value()[indexPath.row]
            } catch {
                return nil
            }
        }
        
        cell.repository = currentRepo
        
        return cell
    }
    
}
