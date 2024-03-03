//
//  BeerListViewController.swift
//  Brewery
//
//  Created by mijisuh on 2024/03/02.
//

import UIKit

class BeerListViewController: UITableViewController {
    
    var beerList = [Beer]()
    var currentPage = 1
    var dataTasks = [URLSessionTask]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureNavigationView()
        self.configureTableView()
        
        self.fetchBeer(of: currentPage)
    }
    
    private func configureNavigationView() {
        // UINavigationBar
        self.title = "브루어리"
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func configureTableView() {
        // TableViewCell 등록
        self.tableView.register(BeerListCell.self, forCellReuseIdentifier: "BeerListCell")
        self.tableView.rowHeight = 150
        self.tableView.prefetchDataSource = self
    }

}
 
// UITableView DataSource, Delegate
extension BeerListViewController: UITableViewDataSourcePrefetching {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beerList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BeerListCell") as? BeerListCell else { return UITableViewCell() }
        let beer = beerList[indexPath.row]
        cell.configure(with: beer)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedBeer = self.beerList[indexPath.row]
        let detailViewController = BeerDetailViewController()
        detailViewController.beer = selectedBeer
        self.show(detailViewController, sender: nil)
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard currentPage != 1 else { return } // 2번째 페이지부터 적용
        indexPaths.forEach {
            if ($0.row + 1) / 25 + 1 == currentPage { // 페이지수가 현재 페이지와 동일해졌을 때
                self.fetchBeer(of: currentPage)
            }
        }
    }
    
}

// Data Fetching
private extension BeerListViewController {
    
    func fetchBeer(of page: Int) {
        guard let url = URL(string: "https://api.punkapi.com/v2/beers?page=\(page)"),
              dataTasks.firstIndex(where: { $0.originalRequest?.url == url }) == nil // 새로 요청하는 url이 이전에 요청한 url과 중복되면 X
        else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let dataTask = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self,
                  error == nil,
                  let response = response as? HTTPURLResponse,
                  let data = data,
                  let beers = try? JSONDecoder().decode([Beer].self, from: data)
            else {
                print("ERROR: URLSession data task \(error?.localizedDescription)")
                return
            }
            
            switch response.statusCode {
            case (200...299): // 성공
                self.beerList += beers
                self.currentPage += 1
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case (400...499): // 클라이언트 에러
                print("""
                    ERROR: Client ERROR \(response.statusCode)
                    Response: \(response)
                """)
                
            case (500...599): // 서버 에러
                print("""
                    ERROR: Server ERROR \(response.statusCode)
                    Response: \(response)
                """)
                
            default:
                print("""
                    ERROR: ERROR \(response.statusCode)
                    Response: \(response)
                """)
            }
        }
        
        dataTask.resume()
        self.dataTasks.append(dataTask) // 한번 실행됐던 DataTask를 저장해서 중복 요청 여부 확인
    }
    
}
