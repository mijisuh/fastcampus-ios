# To-Do List 앱 

> 해야 할 일을 추가 및 삭제가 가능하고 목록을 재정렬 할 수 있으며 데이터 저장소에 저장하여 앱 재실행시 데이터가 유지되는 To-do List 앱 ✅

![Simulator Screen Recording - iPhone 14 - 2024-02-20 at 17 39 17](https://github.com/mijisuh/fastcampus-ios/assets/57468832/cf2da4db-bfe5-4baf-ba66-d66b741c7354)

## 주요 개념 정리

<details>
<summary>UITableView</summary>

### UITableView
- **데이터를 목록 형태로 보여줄 수 있는** 가장 기본적인 UI 컴포넌트
    - UIScrollView를 상속 받아 스크롤이 가능하여 많은 정보를 보여줄 수 있음
    - 여러 개의 셀(Cell)을 가지고 있고, 하나의 열과 여러 줄의 행을 지니고 있으며, 수직으로만 스크롤이 가능
    - 섹션(Section)을 이용해 행을 그룹화하여 콘텐츠를 좀 더 쉽게 탐색 가능
    - 섹션의 header와 footer에 뷰를 구성하여 추가적인 정보 표현 가능
- Delegate, DataSource 프로토콜 채택해서 구현
    - **DataSource**: 데이터를 받아 뷰를 그려줌
    - **Delegate**: 테이블 뷰의 동작과 외관을 담당(뷰가 변경되는 사항)

### UITableViewDataSource

- **테이블 뷰를 생성하고 수정하는데 필요한 정보**를 테이블 뷰 객체에 제공
- 필수 구현 메서드 2가지
    ```swift
    // 각 섹션에 표시할 행의 개수를 묻는 메서드
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    ```
    ```swift
    // 특정 인덱스 Row의 Cell에 대한 정보를 넣어 Cell을 반환하는 메서드
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    ```
- ex) 테이블 뷰의 할 일 목록을 표시하고 삭제가 가능하며 순서를 재구성할 수 있게 함

### UITableViewDelegate

- **테이블 뷰의 시각적인 부분을 설정**하고, **행의 액션 관리, 액세서리 뷰 지원,  테이블 뷰의 개별 행 편집**을 도와줌
- 필수 구현 메서드 X
- ex) 할 일 목록을 선택했을 때 체크마크를 표시할 수 있도록 구성 가능
</details>

<details>
<summary>UIAlertController</summary>

- `UIAlertController`를 present 해서 알림 창을 띄울 수 있음
- 앱이나 기기의 상태와 관련된 중요한 정보를 전달하며 사용자에게 피드백 요청하기 위해 사용
- 제목, 메세지, 하나 이상의 버튼 및 입력을 수집하기 위한 텍스트필드로 이루어짐
</details>

<details>
<summary>UserDefaults</summary>

- 런타임 환경에 동작하면서 **앱이 실행되는 동안 기본 저장소에 접근해 데이터를 기록하고 가져오는 역할**을 하는 인터페이스
- <u>(키, 값) 쌍으로 저장</u>되고 <u>싱글톤 패턴</u>으로 설계되어 앱 전체에 단 한개의 인스턴스만 존재
- 여러 타입 저장 가능(기본 데이터 타입, NS 관련 타입)
</details>

## 구현 내용
1. Navigation Controller 추가 및 Root View Controller 설정
    - Bar Button Item을 추가하고 각각 Edit, + 버튼으로 만듬
        - +버튼: 속성 인스펙션에서 System Item을 Add로 변경
2. Table View 추가
    - 제약조건 설정
    - 속성 인스펙션에서 Prototype Cells를 1로 변경
    - Table View Cell의 Style을 Basic으로 변경하여 시스템에서 기본적으로 정의되어 있는 스타일로 구현
3. 아울렛 변수, 액션 함수 정의
    - TableView, Button을 아울렛 변수로 정의
        - EditButton의 Storage를 Strong으로 설정 → weak로 설정할 경우 Edit Button을 Done Button으로 바꿀 경우 Edit Button이 메모리에서 해제가 되어 더 이상 재사용할 수 없기 때문에
    - Edit 버튼과 + 버튼에 대한 액션 함수 정의
4. +버튼 클릭 시 Alert 창 띄우기
   - Action Sheet와 Alert
   - `UIAlertController` 정의 후 `present`
5. 할 일 추가 시 테이블 뷰에 추가
    - Task 구조체 정의
    - Alert 버튼 클릭 시 실행되는 클로저안에 정의
        - 선언부에 캡쳐 목록 정의하는 이유는 클로저는 클래스처럼 참조 타입이기 때문에 클로저의 본문에 self 키워드로 클래스의 인스턴스를 캡쳐(접근)할 때 **강한 순환 참조**가 발생할 수 있기 때문임
            <details>
            <summary>강한 순환 참조</summary>

            - 2개의 객체가 상호 참조하는 경우 강한 순환 참조가 되는데 순환 참조와 연관된 객체의 레퍼런스 카운트가 0에 도달하지 못하고 메모리 누수 발생
            - 클래스와 클로저 인스턴스 사이에 강한 순환 참조 문제는 클로저 선언부에서 캡쳐 목록을 정의하는 것으로 해결 가능 → `[weak self] _ in`
            </details>
    - 테이블 뷰 DataSoure를 뷰 컨트롤러에서 채택
        - `UITableViewDataSource` 프로토콜 채택
        - 필수 구현 메서드 정의
            ```swift
            public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                return self.tasks.count
            }
            
            public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { // indexPath에 위치한 셀을 재사용하기 위해 indexPath를 넘겨줌
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) // 스토리보드에 정의한 셀을 identifier 값으로 가져올 수 있음
                return cell // 스토리보드에 정의한 셀이 테이블 뷰에 표시됨
            }
            ```
        - `dequeueReusableCell()`: 지정된 재사용 식별자(identifier)에 대한 재사용 가능한 테이블 뷰의 셀 객체를 반환하고 이를 테이블 뷰에 추가하는 역할 → 모든 셀을 매번 생성하면 메모리 낭비가 심하기 때문에 셀을 Queue로 관리해서 재사용할 수 있게 만듬
            - 화면에 보여질 수 있는 셀이 5개라면 이 5개만으로 1억개의 셀을 표시할 수 있음
            - 스크롤을 통해 새로운 데이터가 보여질 경우 기존의 데이터는 reuse pool 이라는 곳에 enqueue, 나중에 해당 데이터를 보여줘야 하는 경우 dequeue
        - 할 일 추가 후 `tableView.reloadData()`를 호출해 테이블 뷰를 갱신하고 추가된 요소가 화면에 표시될 수 있음
        - `self.tableView.dataSource = self`를 통해 뷰 컨트롤러를 테이블 뷰의 dataSource로 설정
6. UserDefaults로 할 일 목록 데이터 저장
    - UserDefaults는 싱글톤 객체
        
        ```swift
        let userDefaults = UserDefaults.standard // UserDefaults에 접근
        userDefaults.set(data, forKey: "tasks") // UserDefaults에 데이터 저장
        userDefaults.object(forKey: "tasks") as? [[String: Any]] // UserDefaults에 저장된 데이터 로드
        ```
        
    - tasks 변수에 프로퍼티 옵져버 추가해서 할 일이 추가될 때마다 UserDefaults에 저장
    - `viewDidLoad()`에서 앱을 재실행 했을 때 UserDefaults에서 저장된 할 일 목록을 불러옴
7. 할 일 완료 시 체크마크 표시
    - 테이블 뷰 Delegate를 뷰 컨트롤러에서 채택
        - `UITableViewDelegate` 프로토콜 채택
            ```swift
            func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { // 셀 선택 시 어떤 셀이 선택되었는지 알려주는 메서드
                var task = self.tasks[indexPath.row]
                task.done = !task.done
                self.tasks[indexPath.row] = task
                self.tableView.reloadRows(at: [indexPath], with: .automatic) // 선택된 셀만 리로드
            }
            ```
        - 메서드 구현
    - cell의 `accessoryType`을 `.checkmark`로 선택 시 셀의 오른쪽 끝에 체크마크 표시를 할 수 있음
8. 테이블 뷰의 할 일 삭제 및 순서 변경
    - Edit 버튼 클릭시 Done 버튼으로 바뀌고 테이블 뷰를 편집 모드로 전환
        - doneButton이라는 `UIBarButtonItem`을 코드로 정의
        - Edit 버튼 클릭시 navigationItem의 leftBarButtonItem을 doneButton으로 변경
        - `self.tableView.setEditing(true, animated: true)`으로 테이블 뷰를 편집모드로 전환
    - 테이블 뷰에서 할 일 삭제
        - DataSource 프로토콜의 `commit` 메서드 구현
            ```swift
            // 편집모드에서 삭제 버튼을 눌렀을 때 해당 셀 정보를 알려주는 메서드
            func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
                self.tasks.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                
                if self.tasks.isEmpty { // 모든 할 일이 삭제되었으면
                    self.doneButtonTap() // 편집모드에서 빠져나옴
                }
            }
            ```
    - 테이블 뷰 할 일의 순서 변경
        - DataSource 프로토콜의 `canMoveRowAt`, `moveRowAt` 메서드 구현
            ```swift
            func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
                return true
            }
            
            // 행이 다른 위치로 이동하면 sourceIndexPath를 통해 원래 있었던 위치를 알려주고 destinationIndexPath를 통해 이동한 위치를 알려줌
            func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
                var tasks = self.tasks
                let task = tasks[sourceIndexPath.row]
                tasks.remove(at: sourceIndexPath.row)
                tasks.insert(task, at: destinationIndexPath.row)
                self.tasks = tasks
            }
            ```