//
//  WriteDiaryViewController.swift
//  Diary
//
//  Created by mijisuh on 2024/02/21.
//

import UIKit

enum DiaryEditMode {
    case new
    case edit(IndexPath, Diary) // 수정할 Diary 객체를 받음
}

protocol WriteDiaryViewDelegate: AnyObject {
    func didSelectRegister(diary: Diary) // 작성된 Diary를 전달
}

class WriteDiaryViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var confirmButton: UIBarButtonItem!
    
    weak var delegate: WriteDiaryViewDelegate?
    
    private let datePicker = UIDatePicker()
    private var diaryDate: Date?
    
    var diaryEditMode: DiaryEditMode = .new
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureContentsTextView()
        self.configureDatePicker()
        self.configureInputField()
        self.configureEditMode()
        self.confirmButton.isEnabled = false
    }
    
    private func configureEditMode() {
        switch diaryEditMode {
        case .edit(_, let diary): // 상세화면에서 전달받은 데이터를 화면에 보여줌
            self.titleTextField.text = diary.title
            self.contentsTextView.text = diary.contents
            self.dateTextField.text = self.dateToString(date: diary.date)
            self.diaryDate = diary.date
            self.confirmButton.title = "수정"
        default:
            break
        }
    }
    
    private func configureContentsTextView() {
        let borderColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0) // rgb 값은 0~1
        self.contentsTextView.layer.borderColor = borderColor.cgColor // 레이어 관련 색상 설정 시에는 cgColor 사용
        self.contentsTextView.layer.borderWidth = 0.5
        self.contentsTextView.layer.cornerRadius = 5.0
    }
    
    private func configureDatePicker() {
        self.datePicker.datePickerMode = .date
        self.datePicker.preferredDatePickerStyle = .wheels
        self.datePicker.locale = Locale(identifier: "ko-KR") // 데이터피커가 한국어로 나오고 연-월-일 순서로 변경
        self.datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        self.dateTextField.inputView = self.datePicker // 텍스트필드를 선택했을 때 키보드가 아닌 데이터피커가 표시되게 됨
    }
    
    private func configureInputField() {
        // 텍스트가 입력될 때마다 등록 버튼 활성화 여부 체크
        self.contentsTextView.delegate = self
        self.titleTextField.addTarget(self, action: #selector(titleTextFieldDidChange(_:)), for: .editingChanged) // 제목이 변경될 때마다 호출되는 함수 정의
        self.dateTextField.addTarget(self, action: #selector(dateTextFieldDidChange(_:)), for: .editingChanged) // 키보드로 입력한게 아니어서 따로 처리 필요
    }
    
    @objc func datePickerValueChanged(_ datePicker: UIDatePicker) {
        // 데이터피커에서 선택된 날짜를 텍스트필드에 보여줌
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일(EEEEE)" // EEEEE는 요일을 한글자로 표현
        formatter.locale = Locale(identifier: "ko_KR") // 날짜를 한글로 표시하기 위함
        self.diaryDate = datePicker.date
        self.dateTextField.text = formatter.string(from: datePicker.date) // Date를 formatter로 지정한 문자열로 변환해서 표시
        self.dateTextField.sendActions(for: .editingChanged)
    }
    
    @objc func titleTextFieldDidChange(_ textField: UITextField) {
        self.validateInputField()
    }
    
    @objc func dateTextFieldDidChange(_ textField: UITextField) {
        self.validateInputField()
    }
    
    @IBAction func tabConfirmButton(_ sender: UIBarButtonItem) {
        guard let title = self.titleTextField.text,
              let contents = self.contentsTextView.text,
              let date = self.diaryDate
        else { return }
                
        switch self.diaryEditMode {
        case .new:
            let diary = Diary(
                uuidString: UUID().uuidString,
                title: title,
                contents: contents,
                date: date,
                isStar: false
            )
            self.delegate?.didSelectRegister(diary: diary)
        case .edit(_, let diary):
            let diary = Diary(
                uuidString: diary.uuidString,
                title: title,
                contents: contents,
                date: date,
                isStar: diary.isStar
            )
            NotificationCenter.default.post(
                name: NSNotification.Name("editDiary"),
                object: diary,
                userInfo: nil
            )
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func validateInputField() {
        // 모든 항목이 입력되어 있을 때 등록 버튼 활성화
        self.confirmButton.isEnabled = !(self.titleTextField.text?.isEmpty ?? true) && !(self.dateTextField.text?.isEmpty ?? true) && !self.contentsTextView.text.isEmpty
    }
    
    private func dateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy년 MM월 dd일(EEEEE)"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
    
}

extension WriteDiaryViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) { // 텍스트필드에 텍스트가 입력될 때마다 호출
        self.validateInputField()
    }
    
}
