//
//  ViewController.swift
//  Diary
//
//  Created by mijisuh on 2024/02/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var collectionView: UICollectionView!
    
    private var diaryList = [Diary]() {
        didSet {
            self.saveDiaryList()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadDiaryList()
        self.configureCollectionView()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(editDiaryNotification(_:)),
            name: NSNotification.Name("editDiary"),
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(starDiaryNotification(_:)),
            name: NSNotification.Name("starDiary"),
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(deleteDiaryNotification(_:)),
            name: NSNotification.Name("deleteDiary"),
            object: nil
        )
    }
    
    private func configureCollectionView() {
        self.collectionView.collectionViewLayout = UICollectionViewFlowLayout() // 코드로 컬렉션 뷰 레이아웃을 구성
        self.collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10) // 좌우위아래
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }

    @objc func editDiaryNotification(_ notification: Notification) {
        guard let diary = notification.object as? Diary else { return }
        
        if let index = self.diaryList.firstIndex(where: { $0.uuidString == diary.uuidString }) {
            self.diaryList[index] = diary
            self.diaryList = self.diaryList.sorted(by: {
                $0.date.compare($1.date) == .orderedDescending
            })
            self.collectionView.reloadData()
        }
    }
    
    @objc func starDiaryNotification(_ notification: Notification) {
        guard let starDiary = notification.object as? [String: Any],
              let isStar = starDiary["isStar"] as? Bool,
              let uuidString = starDiary["uuidString"] as? String
        else { return }
        
        if let index = self.diaryList.firstIndex(where: { $0.uuidString == uuidString }) {
            self.diaryList[index].isStar = isStar
        }
    }
    
    @objc func deleteDiaryNotification(_ notification: Notification) {
        guard let uuidString = notification.object as? String else { return }
        
        if let index = self.diaryList.firstIndex(where: { $0.uuidString == uuidString }) {
            self.diaryList.remove(at: index)
            self.collectionView.deleteItems(at: [IndexPath(row: index, section: 0)])
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let writeDiaryViewController = segue.destination as? WriteDiaryViewController {
            writeDiaryViewController.delegate = self
        }
    }
    
    private func saveDiaryList() {
        let data = self.diaryList.map {
            [
                "uuidString": $0.uuidString,
                "title": $0.title,
                "contents": $0.contents,
                "date": $0.date,
                "isStar": $0.isStar
            ]
        }
        
        let userDefaults = UserDefaults.standard
        userDefaults.set(data, forKey: "diaryList")
    }
    
    private func loadDiaryList() {
        let userDefaults = UserDefaults.standard
        guard let data = userDefaults.object(forKey: "diaryList") as? [[String: Any]] else { return }
        self.diaryList = data.compactMap {
            guard let uuidString = $0["uuidString"] as? String,
                  let title = $0["title"] as? String,
                  let contents = $0["contents"] as? String,
                  let date = $0["date"] as? Date,
                  let isStar = $0["isStar"] as? Bool
            else { return nil }
            
            return Diary(uuidString: uuidString, title: title, contents: contents, date: date, isStar: isStar)
        }
        self.diaryList = self.diaryList.sorted(by: {
            $0.date.compare($1.date) == .orderedDescending // 최신순으로 정렬
        })
    }
    
    private func dateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy년 MM월 dd일(EEEEE)"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout { // 콜렉션 뷰의 레이아웃 구성
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize { // 셀의 사이즈를 설정
        return CGSize(width: (UIScreen.main.bounds.width / 2) - (10 * 2), height: 200) // 행 간 셀이 2개씩 표시(10*2는 Content Inset의 좌우값)
    }
    
}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.diaryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiaryCell", for: indexPath) as? DiaryCell else { return UICollectionViewCell() }
        
        let diary = self.diaryList[indexPath.row]
        cell.titleLabel.text = diary.title
        cell.dateLabel.text = self.dateToString(date: diary.date) // Date -> String
        return cell
    }
    
}

extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) { // 특정 셀이 선택되었음을 알리는 메서드
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "DiaryDetailViewController") as? DiaryDetailViewController else { return }
        let diary = self.diaryList[indexPath.row]
        viewController.diary = diary
        viewController.indexPath = indexPath
//        viewController.delegate = self
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}

extension ViewController: WriteDiaryViewDelegate {
    
    func didSelectRegister(diary: Diary) {
        self.diaryList.append(diary)
        self.diaryList = self.diaryList.sorted(by: {
            $0.date.compare($1.date) == .orderedDescending // 최신순으로 정렬
        })
        self.collectionView.reloadData()
    }
    
}

//extension ViewController: DiaryDetailViewDelegate {
    
//    func didSelectDelete(indexPath: IndexPath) {
//        self.diaryList.remove(at: indexPath.row)
//        self.collectionView.deleteItems(at: [indexPath])
//    }
    
//    func didSelectStar(indexPath: IndexPath, isStar: Bool) {
//        self.diaryList[indexPath.row].isStar = isStar
//    }
    
//}
