# 📆 일기 앱

> - 일기장 탭을 누르면 일기 리스트를 표시할 수 있다.
> - 즐겨찾기 탭을 누르면 즐겨찾기한 일기 리스트를 표시할 수 있다.
> - 일기를 등록, 수정, 삭제, 즐겨찾기 할 수 있다.

![Simulator Screen Recording - iPhone 14 - 2024-02-22 at 15 00 41](https://github.com/mijisuh/fastcampus-ios/assets/57468832/ef3fc98c-de76-42f8-b3bd-2939e1fa5c33)

## 주요 개념 정리

<details>
<summary>UITabBarController</summary>

### UITabView

> 앱에서 서로 다른 하위작업, 뷰, 모드 사이의 선택을 할 수 있도록, **탭 바(Tab Bar)에서 하나 이상의 버튼을 보여주는 컨트롤**

- `UITabBarItem`으로 구성됨
- 탭 바 아이템 클릭 시 그에 상응하는 화면이 나타남 → `UITabBarController`에서 관리

### UITabBarController

> **다중 선택 인터페이스를 관리하는 컨테이너 뷰 컨트롤러**로, 선택에 따라 어떤 자식 뷰 컨트롤러를 보여줄 것인지 결정

- 탭 바 뷰와 커스텀 컨텐트 뷰를 포함한 뷰(Assembled View)
- 탭 바 뷰는 사용자를 위해 선택 컨트롤러 제공하고 하나 이상의 탭 바 아이템으로 구성
- 탭 바 마다 다른 화면을 보여주는데 용이
</details>

<details>
<summary>UICollectionView</summary>

## UICollectionView

> 데이터 항목의 정렬된 컬렉션을 관리하고 **커스텀한 레이아웃**을 사용해 표시하는 객체

- 구성요소
    - Cell: 컬렉션 뷰의 콘텐츠 표시
    - Supplementary View: 섹션에 대한 정보 표시(헤더와 푸터)
    - Decoration View: 컬렉션 뷰에 대한 배경을 꾸밀 때 사용
- Layout
    - 레이아웃 객체를 이용해 컬렉션 뷰 내 아이템 배치 및 시각적 스타일을 결정
    - UICollectionViewLayout: 셀을 원하는 형태로 정렬
    - UICollectionFlowLayout: 셀의 성형 경로를 배치 → 다양한 형태 구현 가능
        
## UICollectionViewFlowLayout

- 구성 단계
    1. Flow 레이아웃 객체를 작성하고 컬렉션 뷰에 이를 할당
    2. **셀의 width, height를 정함(필수)** (아니면 0 되어 표시X)
    3. 필요한 경우 셀들 간의 좌우 또는 위아래 최소 간격을 설정
        - 섹션 자체에도 간격 설정 가능 -> `inset = UIEdgeInsetsMake(top, left, bottom, right)`
    4. 섹션의 header와 footer가 있다면 해당 크기를 지정
    5. 레이아웃의 스크롤 방향 설정

## UICollectionViewDataSource

> 컬렉션 뷰로 **보여지는 콘텐츠들을 관리**하는 객체(섹션의 개수, 특정 섹션의 셀의 개수, 어떤 뷰를 사용할 것인지에 대한 정보)

- 프로토콜 타입
- 필수 구현 메서드
    ```swift
    // 지정된 섹션에 표시할 셀의 개수를 묻는 메서드
    func collectionView(UICollectionView, numberOfItemsInSection: Int) -> Int
    
    // 컬렉션 뷰의 지정된 위치에 표시할 셀을 요청하는 메서드
    func collectionView(UICollectionView, cellForItemAt: IndexPath) -> UICollectionViewCell
    ```

## UICollectionViewDelegate

> **콘텐츠의 표현, 사용자와의 상호작용과 관련된 것들을 관리**하는 객체

- 필수 구현 메서드 없음


## CollectionView와 관련된 핵심 객체들의 관계
> 컬렉션 뷰는 **DataSource**에서 보여줄 셀에 대한 정보를 가져오고,
**Layout 객체**에서 해당 셀이 속하는 위치를 결정하고 하나 이상의 레이아웃 속성 객체로 컬렉션 뷰에 전송하여,
레이아웃 정보를 실제 셀이나 다른 뷰들과 결합하여 최종적으로 사용자에게 보여짐
>
</details>

<details>
<summary>NotificationCenter</summary>

- **등록된 이벤트가 발생**하면 **해당 이벤트들에 대한 행동**을 취하는 것
- 앱 내 아무데서나 메세지를 던지면 아무데서나 이 메세지를 받을 수 있게 해줌(Event Bus)
- 이벤트는 `post()` 메서드를 통해 전송하며, 이벤트를 받으려면 옵져버를 등록해서 post한 이벤트를 전달 받을 수 있음
- ex) 각 화면에서 일기 수정, 삭제, 즐겨찾기 이벤트를 관찰하고 있다가 이벤트가 발생하면 그에 따른 처리를 해줌
</details>

## 화면에 따른 데이터 전달 흐름도
<img width="1001" alt="스크린샷 2024-02-22 오후 12 25 32" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/2e6b4079-10dd-4dfa-901d-b3b7da275517">

- WriteDiaryVC
    - <u>일기를 새롭게 작성하면</u> → WriteDiaryVC에 정의된 WriteDiaryViewDelegate의 `didSelectRegister()` 메서드가 호출되어 작성되 일기 데이터를 전달
    - <u>일기를 수정하면</u> → NotificationCenter를 통해 “editDiary”라는 이름의 Notification을 post 하여 수정된 일기 데이터를 일기 상세 화면, 일기장 화면, 즐겨찾기 화면에 전달하고 해당 일기 데이터 정보로 화면 업데이트
- DiaryDetailVC
    - <u>일기를 삭제하면</u> → NotificationCenter를 통해 “deleteDiary”라는 이름의 Notification을 post 하여 일기장 화면, 즐겨찾기 목록에 일기의 uuid를 전달하고 이 uuid를 통해 일기 리스트의 인덱스를 찾아서 해당 일기 삭제
    - <u>일기를 즐겨찾기하면</u> → NotificationCenter를 통해 “starDiary”라는 이름의 Notification을 post 하여 일기 상세 화면, 일기장 화면, 즐겨찾기 화면에 즐겨찾기 여부에 대한 데이터 전달
    - <u>일기장 탭과 즐겨찾기 탭에서 즐겨찾기 화면을 열었을 때 싱크가 안되는 문제</u> →  NotificationCenter를 통해 “starDiary”라는 이름의 Notification을 관찰해서 전달받은 데이터가 현재 일기장 상세 화면에 표시되는 일기 데이터와 같은 uuid라면 즐겨찾기 상태를 전달받은 상태로 업데이트

## 구현 내용
1. 스토리보드에 `Tab Bar Cotroller`, `Navigation Controller` 추가
    - 기본 뷰 컨트롤러를 네비게이션 컨트롤러의 루트 뷰 컨트롤러로 설정(일기장 화면)
    - 탭 바 컨트롤러와 탭 바 컨트롤러를 Relationship Segue로 연결
    - 네비게이션 컨트롤러에 표시된 탭 바를 선택 → 탭 바 아이템 설정 변경
        - 이미지 변경
        - 타이틀 변경
2. Navigation Controller와 View Controller를 하나 더 추가(즐겨찾기 화면)
3. 각 뷰 컨트롤러에 컬렉션 뷰를 추가
    - 셀의 identifier 설정
    - 셀의 width, height 설정(사이즈 인스펙션 → Size를 Custom으로 설정)
        - 셀이 행마다 2개씩 있도록 표시하려면 아이폰 해상도에 따라 셀의 width가 동적으로 변해야 함 → 코드로 구현
    - 일기장 화면의 경우, 각 셀에 일기장 제목과 날짜가 나오도록 라벨 추가
        - 제목 라벨이 늘어나도록 hugging priory를 날짜 라벨보다 낮게 만듬
        - 제목 라벨이 늘어날 때 날짜 라벨이 사라지지 않도록 compression resistance priority를 제목 라벨보다 높게 만듬
4. 커스템 셀을 클래스와 연결
    - `UICollectionViewCell` 타입 클래스 생성
    - 스토리보드에서 생성한 커스템 셀과 연결
        - 아울렛 변수 생성 가능해지고 클래스 안에서 뷰 객체에 접근하여 뷰 속성을 변경할 수 있게 됨
5. 일기 등록하고 목록 보여주기
    - Bar Button Item 추가하고 새로운 뷰 컨트롤러에 push 되도록 세그웨이 설정
    - 라벨, 텍스트필드, 텍스트 뷰 생성
        - TextField는 한 줄만 입력 받을 수 있기 때문에 여러 줄을 입력 받을 수 있는 TextView로 내용을 입력 받을 수 있도록 함
    - 아울렛 변수, 액션 함수 정의
        - Cell은 스토리보드 어시스턴트로 잘 안잡혀서 따로 탭 열어서 진행
    - TextView에 TextField처럼 테두리 생성
        - 설정하는 코드를 함수로 작성하고 해당 함수를 `viewDidLoad()`에서 호출
    - DatePicker 생성
        - 날짜와 시간을 선택할 수 있게 해주는 객체
        - 설정하는 코드를 함수로 작성하고 해당 함수를 `viewDidLoad()`에서 호출
        - `addTarget()`: UIViewController 객체가 이벤트에 응답하는 방식을 설정해주는 메서드
    - 빈 화면 클릭시 키보드나 DatePicker가 내려가게 하는 방법
        ```swift
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
                self.view.endEditing(true)
            }
        ```
    - 모든 항목이 입력되어야 등록 버튼이 활성화되도록 기능 추가
        - UITextView는 `UITextViewDelegate` 프로토콜을 준수해서 `textViewDidChange()` 메서드 구현
        - UITextField는 `addTarget()`의 for 파라미터를 `.editingChanged`로 지정
        - Date 정보를 보여주는 텍스트필드의 경우 날짜를 변경해도 키보드로 입력한 것이 아니기 때문에 `editingChanged` 상태가 아니어서 `addTarget`의 selector 함수가 호출되지 않음 → DatePicker로 날짜 변경 시 `self.dateTextField.sendActions(for: .editingChanged)` 를 호출해서 `editingChanged` 액션을 발생시킴
    - 작성한 일기를 컬렉션 뷰에 표시
        - 일기 정보를 담을 Diary 클래스 생성
        - 작성한 Diary를 전달하기 위해 Delegate 패턴 적용
        - `UICollectionViewDataSource` 프로토콜 채택해서 컬렉션 뷰에 일기 정보 표시
        - `UICollectionViewDelegateFlowLayout` 프로토콜 채택해서 콜렉션 뷰의 레이아웃 구성
    - `UserDefaults`에 일기 데이터 저장 및 로드
    - 일기를 최신 날짜 순으로 정렬
        - 일기를 등록할 때
        - 일기를 저장소에서 불러올 때
            ```swift
            self.diaryList = self.diaryList.sorted(by: {
                $0.date.compare($1.date) == .orderedDescending // 최신순으로 정렬
            })
            ```
    - 구분이 쉽도록 셀의 테두리 그리기
        - 코드로 정의
            ```swift
            class DiaryCell: UICollectionViewCell {
                
                @IBOutlet weak var titleLabel: UILabel!
                @IBOutlet weak var dateLabel: UILabel!
                
                required init?(coder: NSCoder) { // UIView가 xib나 스토리보드에서 생성이 될 때 이 생성자를 통해 객체 생성
                    super.init(coder: coder)
                    self.contentView.layer.cornerRadius = 3.0 // 셀의 루트 뷰 접근
                    self.contentView.layer.borderWidth = 1.0
                    self.contentView.layer.borderColor = UIColor.black.cgColor
                }
                
            }
            ```
6. 일기 목록에서 일기 삭제
    - 일기 상세 화면 생성하고 해당 뷰 컨트롤러에 delegate 프로토콜 정의 후 삭제 버튼 클릭 시 일기 목록 화면으로 pop 하면서 indexPath를 넘겨주고 이 정보로 diaryList에서 해당 데이터를 삭제하고 collectionView에서도 삭제
    - 일기 상세 화면에서 수정 버튼 클릭시 일기 작성 화면으로 이동
        - 일기 작성 화면에 열거형을 정의하여 편집 모드를 나눠줌(새로 생성, 기존 수정)
            ```swift
            enum DiaryEditMode {
                case new
                case edit(IndexPath, Diary) // 연관값을 이용해 수정할 Diary 객체를 받음
            }
            ```
        - 일기 작성 화면에 편집모드에 대한 `DiaryEditMode` 열거형 프로퍼티를 생성해서 일기 상세 화면에서 연관값에 데이터를 담아 전달함
        - edit 모드일 경우, 기존에 Bar Button Item 버튼을 ‘등록’ → ‘수정’으로 이름 변경
    - 일기 수정 화면에서 수정된 데이터를 `NotificationCenter`를 이용해 전달
        - 수정 버튼 클릭시 NotificationCenter의 post메서드를 를 통해서 수정된 객체를 전송하도록 함
            ```swift
            NotificationCenter.default.post(
                name: NSNotification.Name("editDiary"), // Notification의 이름을 설정: 옵저버에서 해당 이름으로 Notification 이벤트가 발생하였는지 관찰
                object: diary, // 전달할 객체
                userInfo: ["indexPath.row": IndexPath.row] // Notification과 관련된 값을 전달할 수 있음 -> 수정이 일어나면 collectionView에도 수정하기 위해
            )
            ```
        - 상세 화면에서 Edit 버튼 클릭 시 Notification을 옵저빙하고 수정된 데이터로 업데이트
            ```swift
            // 특정 이름의 Notification 이벤트가 발생하였는지 관찰하고 이벤트가 발생하면 특정 행위를 수행
            NotificationCenter.default.addObserver(
                self, // 어떤 인스턴스에서 옵저빙하는지
                selector: #selector(ediDiaryNotification(_:)), // 이벤트 발생 시 호출
                name: NSNotification.Name("editDiary"), // "editDiary" Notification 관찰
                object: nil
            )
            ```
            ```swift
            guard let diary = notification.object as? Diary,
                  let row = notification.userInfo?["indexPath.row"] as? Int
            else { return } // Notification post에서 보낸 객체를 받을 수 있음
            ```
        - 더이상 관찰할 필요가 없는 경우 NotificationCenter 옵져버 삭제
            ```swift
            deinit {
                NotificationCenter.default.removeObserver(self) // 해당 인스턴스에 추가된 모든 옵저버가 삭제
            }
            ```
    - 일기 목록 화면에도 Notification 옵저버 추가해서 collectioView에도 반영되게 함
7. 즐겨찾기
    - 일기 상세 화면에 즐겨찾기 정보를 나타내는 Bar Button Item 추가 → 토글이 가능하도록 구현
    - 즐겨찾기 버튼 클릭 시 delegate 함수를 통해 즐겨찾기 정보를 전달해서 해당 정보로 업데이트
    - `UICollectionViewDelegate`, `UICollectionViewDataSource`, `UICollectionViewDelegateFlowLayout` 프로토콜 채택해서 collectionView 설정
    - 즐겨찾기 화면에서 일기 클릭 시 상세 화면으로 이동하도록 `UICollectionViewDelegate` 의 `didSelectItemAt` 메서드 구현
8. 상세 화면에서 수정, 삭제 시 목록 화면, 즐겨찾기 화면 모두에 적용이 되도록 수정
    - delegate 패턴 사용시 1:1로만 적용이 가능하기 때문에(상세 화면 → 목록 화면 or 상세 화면 → 즐겨찾기 화면) NotificationCenter을 이용해서 이벤트를 전달하도록 변경
        - 상세 화면에서 Edit 버튼 클릭 시 NotificationCenter의 post 함수 호출
        - 목록 화면과 즐겨찾기 화면의 `viewDidLoad()`에 Notification 옵저버 추가(동기화)
9. 수정, 삭제, 즐겨찾기 상태 업데이트 시 오류 처리
    - 문제 파악: 삭제시, 상세 화면에서 삭제를 위한 Notification이 목록 화면, 즐겨찾기 화면에 동일한 indexPath 정보를 전달하는데 총 일기 개수와 즐겨찾기한 일기 개수가 다를 경우 오류 발생
    - 해결 방안
        - <u>일기를 특정할 수 있는 uuid(고유값))</u> 저장
            ```swift
            let diary = Diary(
                uuidString: UUID().uuidString,
                title: title,
                contents: contents,
                date: date,
                isStar: false
            )
            ```
        - indexPath 대신 일기 uuid 전달
        - 이벤트를 받는 쪽도 uuid로 전달 받도록 수정
            ```swift
            // Notification으로부터 diary를 받고, diary의 uuid가 현재 diaryList에 존재하면
            // 해당 diary를 전달받은 diary로 업데이트 
            if let index = self.diaryList.firstIndex(where: { $0.uuidString == diary.uuidString }) {
                self.diaryList[index] = diary
                ...
            }
            ```

