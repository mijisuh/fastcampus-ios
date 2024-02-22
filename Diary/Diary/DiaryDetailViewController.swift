//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by mijisuh on 2024/02/22.
//

import UIKit

//protocol DiaryDetailViewDelegate: AnyObject {
//    func didSelectDelete(indexPath: IndexPath)
//    func didSelectStar(indexPath: IndexPath, isStar: Bool)
//}

class DiaryDetailViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    
    var starButton: UIBarButtonItem?
    
//    weak var delegate: DiaryDetailViewDelegate?
    
    var diary: Diary?
    var indexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(starDiaryNotification(_:)),
            name: NSNotification.Name("starDiary"),
            object: nil
        )
    }
    
    private func configureView() {
        guard let diary = self.diary else { return }
        self.titleLabel.text = diary.title
        self.contentsTextView.text = diary.contents
        self.dateLabel.text = self.dateToString(date: diary.date)
        self.starButton = UIBarButtonItem(image: nil, style: .plain, target: self, action: #selector(tabStarButton))
        self.starButton?.image = diary.isStar ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
        self.starButton?.tintColor = .orange
        self.navigationItem.rightBarButtonItem = self.starButton
        
        let borderColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0) // rgb 값은 0~1
        self.contentsTextView.layer.borderColor = borderColor.cgColor
        self.contentsTextView.layer.borderWidth = 0.5
        self.contentsTextView.layer.cornerRadius = 5.0
    }
    
    private func dateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy년 MM월 dd일(EEEEE)"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
    
    @objc private func editDiaryNotification(_ notification: Notification) {
        guard let diary = notification.object as? Diary else { return } // Notification post에서 보낸 객체를 받을 수 있음
        
        self.diary = diary
        
        self.configureView()
    }
    
    @objc private func starDiaryNotification(_ notification: Notification) {
        guard let starDiary = notification.object as? [String: Any],
              let isStar = starDiary["isStar"] as? Bool,
              let uuidString = starDiary["uuidString"] as? String,
              let diary = starDiary["diary"] as? Diary
        else { return }
        
        if diary.uuidString == uuidString {
            self.diary?.isStar = isStar
            self.configureView()
        }
    }
    
    @IBAction func tabEditButton(_ sender: UIButton) {
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "WriteDiaryViewController") as? WriteDiaryViewController else { return }
        
        guard let indexPath = self.indexPath,
              let diary = self.diary
        else { return }
        viewController.diaryEditMode = .edit(indexPath, diary) // 열거형 연관값으로 전달
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(editDiaryNotification(_:)),
            name: NSNotification.Name("editDiary"),
            object: nil
        )
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func tabDeleteButton(_ sender: UIButton) {
        guard let uuidString = self.diary?.uuidString else { return }
//        self.delegate?.didSelectDelete(indexPath: indexPath)
        NotificationCenter.default.post(name: NSNotification.Name("deleteDiary"), object: uuidString)
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func tabStarButton() {
        guard let isStar = self.diary?.isStar,
              let indexPath = self.indexPath
        else { return }
        self.starButton?.image = isStar ? UIImage(systemName: "star") : UIImage(systemName: "star.fill")
        self.diary?.isStar = !isStar
//        self.delegate?.didSelectStar(indexPath: indexPath, isStar: self.diary?.isStar ?? false) // 즐겨찾기 정보 전달
        // -> NotificationCenter를 이용하는 방식으로 변경
        NotificationCenter.default.post(
            name: Notification.Name("starDiary"),
            object: [
                "diary": self.diary, // 즐겨찾기된 다이어리 전달
                "isStar": self.diary?.isStar ?? false,
                "uuidString": self.diary?.uuidString
            ]
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self) // 해당 인스턴스에 추가된 모든 옵저버가 삭제
    }
    
}
