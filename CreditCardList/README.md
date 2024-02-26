# 💳 신용카드 추천 앱

> - Firebase Realtime Database와 Cloud Firestore를 이용해 카드 정보를 저장한다. 
> - 데이터베이스로부터 각 카드 정보를 읽어와서 상세 화면에 보여준다.
> - 데이터베이스의 카드 정보를 수정한다.
> - 데이터베이스에서 카드 정보를 삭제한다.

![Simulator Screen Recording - iPhone 14 - 2024-02-27 at 00 21 26](https://github.com/mijisuh/fastcampus-ios/assets/57468832/7f78825c-74d7-4f2a-9acc-17d1c031bdb0)

## 주요 개념 정리

<details>
<summary>Firebase - Realtime Database</summary>

## Database

- 데이터의 집합체
- 일반적으로 ‘관계형 데이터베이스’ 형태 → 행과 열을 가지는 테이블 형태로 이루어져 있으며 각각의 테이블과 관계를 맺고 있음

## Firebase - Realtime Database

- 비관계형 클라우드 데이터베이스
    - 대량의 데이터를 대규모로 처리하고 수집하는 모바일, 웹 어플리케이션 개발에 적합
    - 여러 테이블에 산재되어 있던 열들을 모든 갖는 **하나의 단일 문서** 내에 속성으로 저장
    - **JSON 기반의 데이터**를 가져오고 내보내고 관리하는 것에 최적화
- 실시간
    - HTTP 요청이 아닌 **동기화 방식**
    - 보통 데이터베이스에 값을 요청할 때 HTTP 통신을 통해서 진행되지만 Realtime Database의 경우 **옵져버나 스냅샷과 같은 객체을 제공하는 SDK를 통해서 클라이언트와 실시간으로 동기화** 함
- 오프라인
    - 앱이 오프라인 상태일 때도 사용자 액션에 변경사항을 로컬에 저장했다가 앱이 다시 네트워크 연결될 경우 자동적으로 Realtime Database에 동기화
    - 반대로 클라이언트 기기가 오프라인 상태일 때 놓쳤던 서버의 변경사항도 자동으로 수신해서 서버를 최신 상태로 동기화 함
- 서버 없이
    - 별도의 서버 개발 없이 데이터베이스와 클라이언트를 직접 액세스
    - 데이터를 읽거나 쓸 때 보안 규칙을 통해서 데이터베이스 접근 권한에 대한 보안, 데이터 검증을 제공하기 때문에 안전
</details>

<details>
<summary>Firebase - Cloud Firestore</summary>

## Firestore

- Realtime Database 이후에 나온 비교적 최근에 제공되기 시작한 플랫폼으로 Realtime Databse의 주요 기능과 동일하게 제공
    - 비관계형 클라우드 데이터베이스
    - 실시간
    - 오프라인
    - 서버 없이
    - 쿼리를 통한 데이터 검색, 정렬, 필터링
- **Realtime Database와의 차이**
    - 제공하는 데이터 모델이 다르기 때문에 앱의 특성에 따라 선택
        | Realtime Database | Cloud Firestore |
        | --- | --- |
        | 기본적인 데이터 동기화 | 고급 쿼리, 정렬, 트랜젝션 |
        | 적은 양의 데이터가 자주 변경 | 대용량 데이터가 자주 읽힘 |
        | 간단한 JSON 트리 | 구조화된 컬렉션 |
        | 많은 데이터베이스 | 단일 데이터베이스 |
    - Realtime Database는 데이터를 하나의 큰 JSON 트리로 저장하고 Firestore는 문서와 컬렉션의 조합을 이용
    - Realtime Database는 하나의 쿼리에 정렬 또는 필터링 가능해 동시 처리가 불가능하지만 Firestore는 정렬과 필터링을 동시에 진행 가능
    - Realtime Database는 깊고 좁은 쿼리를 제공해 결과값이 가지는 모든 하위 값을 반환하기 때문에 하위값까지 모두 액세스 가능, Firestore는 얕고 넓은 쿼리를 제공해 특정 컬렉션의 문서만 반환하고 해당 문서가 하위 컬렉션을 가지고 있더라도 하위 컬렉션은 반환하지 않음
    - Realtime Database는 데이터 세트가 커질수록 쿼리 성능이 떨어지고(32단계까지의 데이터 중첩만 허용) Firestore는 전체적인 데이터 세트 크기가 쿼리 성능에 직접적인 영향을 주지 않는다고 함
- 쿼리(Query)
    - 데이터베이스에 정보를 요청하는 행위
    - 특정 문자열, 단어, 값을 포함하는 데이터를 찾기 위해 사용
    - 특정 데이터베이스에서 원하는 조건의 데이터를 조작하는 명령문
</details>

## 구현 내용
1. UI 구현
    - UITableViewController를 상속받는 뷰 컨트롤러 생성
    - **UIViewController와 UITableViewController의 차이**
        - `UITableViewController`는 UITableView를 구성하기 위해 필요한 Delegate, DataSource를 기본 연결된 상태로 제공하기 때문에 별도로 선언해주지 않아도 되고 루트 뷰로 UITableView를 가지게 됨
        - `UIViewController`는 루트 뷰로 UIView를 가지고 있음
2. 카드 객체 생성(CreditCard, PromotionDetail)
    - Realtime Database로 데이터를 읽을 때 받게 될 JSON 형태대로 생성
        ```swift
        {
        	"Item0": {
        		"cardImageURL": "https://www.shinhancard.com/_ICSFiles/afieldfile/2019/04/26/190426_pc_mrlife_cardplate600x380.png",
        		"id": 0,
        		"rank": 1,
        		"name": "신한카드 Mr.Life",
        		"promotionDetail": {
        			"companyName": "신한",
        			"amount": 13,
        			"period": "2023.01.07(목)~2023.01.31(토)",
        			"benefitDate": "2023.03.01(월)이후",
        			"benefitDetail": "현금 10만원",
        			"benefitCondition": "이벤트 카드로 결제한 금액이 합해서 10만원이상 결제",
        			"condition": "온라인 채널을 통해 이벤트 카드를 보유하고, 혜택조건을 충족하신 분"
        		}
        	},
        	...
        }
        ```
3. UITableViewCell 생성
    - 셀을 커스텀으로 만들기 위해 별도의 **nib 파일**로 구성
    - UI 구성 후 아울렛 변수 선언
4. UITableView에 Cell Register
    - 코드로 nib 파일 셀 지정 →  스토리보드에서 CardListCell의 Custom Class에 아무 것도 지정 X
        ```swift
        let nibNAme = UINib(nibName: "CardListCell", bundle: nil)
        self.tableView.register(nibNAme, forCellReuseIdentifier: "CardListCell")
        ```  
    - 셀에 표현될 데이터를 설정하고 Delegate, DataSource 함수에 지정
    - imageURL을 imageView에 표시하기 위한 오픈소스 사용 - `pod 'Kingfisher’`
        ```swift
        import Kingfisher
        
        let imageURL = URL(string: creditCardList[indexPath.row].creditImgeURL)
        cell.cardImageView.kf.setImage(with: imageURL)
        ```
5. 셀 클릭 시 카드 혜택 상세 화면 이동
    - Accessory Action - Show
    - Lottie(에어비앤비에서 제공하는 오픈 소스) 사용해서 json 형태로 변환된 gif를 해석해서 화면에 뿌려줌 → `pod 'lottie-ios’`
        - UIView를 `AnimationView`로 변경
        - 아울렛 변수 정의
        - gif에 대한 JSON 파일 추가(이미지의 움직임을 표현하는 벡터 값 등 여러 속성 값을 담고 있음)
            ```swift
            let animationView = LottieAnimationView(name: "money") // json 파일 이름
            lottieView.contentMode = .scaleAspectFit
            lottieView.addSubview(animationView)
            animationView.frame = lottieView.bounds
            animationView.loopMode = .loop
            animationView.play()
            ```
    - 혜택 정보에 대한 아울렛 변수를 정의하고 화면에 표시할 수 있도록 코드 작성
    - 카드 리스트 뷰에서 셀 클릭 시 혜택 상세 화면으로 이동할 수 있도록 `didSelectRowAt` 메서드 작성
6. 파이어베이스 연결
    - 프로젝트 생성
    - iOS 어플리케이션 추가
        - 구성 파일 다운로드 후 Xcode 프로젝트에 추가
    - Realtime Database 생성 후 데이터 추가
        - Realtime Database에서 제공하는 타입: String, Number(Int, Float, Double), Dictionary, Array
        - ‘JSON 가져오기’로 데이터 불러옴
    - 코코아팟 설치 - `pod 'Firebase/Database’`
    - 파이어베이스 초기화 작업
7. 파이어베이스 Realtime Database에서 카드 정보 데이터 가져오기
    - 데이터베이스를 가져올 수 있는 레퍼런스(경로) 생성
        - 데이터베이스의 루트 데이터를 가져올 수 있음
            ```swift
            import FirebaseDatabase
            
            var ref: DatabaseReference! // Firebase Realtime Database
            
            self.ref = Database.database().reference() // 데이터 흐름을 주고 받을 수 있음
            ```
        - **레퍼런스에서 값을 지켜보고 있다가 스냅샷을 이용해 데이터를 불러옴**
            ```swift
            self.ref.observe(.value) { snapshot in // 레퍼런스가 value 값을 관찰하고 snapshot 찍음
                guard let value = snapshot.value as? [String: [String: Any]] else { return } // 저장된 데이터 형태에 따라 다름
                
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: value)
                    let cardData = try JSONDecoder().decode([String: CreditCard].self, from: jsonData)
                    let cardList = Array(cardData.values)
                    self.creditCardList = cardList.sorted { $0.rank < $1.rank }
                    
                    DispatchQueue.main.async { // UI를 표현하는 것으로 메인스레드에서 작동해야 함
                        self.tableView.reloadData()
                    }
                } catch let error {
                    print("Error JSON parsing \(error.localizedDescription)")
                }
            }
            ```
    1. 카드 리스트의 선택 여부를 데이터베이스에 저장
        - `didSelectRowAt` 에 업데이트 코드 작성 - **레퍼런스에 경로를 알려줘야 함**
            - 경로를 알고 있을 때
                ```swift
                let cardID = self.creditCardList[indexPath.row].id
                self.ref.child("Item\(cardID)/isSelected").setValue(true)
                ```
            - 키 값이 임의의 값으로 생성되어 알 수 없는 경우에는 **객체가 가지고 있는 고유의 값(Id)을 검색해서 객체의 경로를 알 수도 있음**
                ```swift
                self.ref.queryOrdered(byChild: "id").queryEqual(toValue: cardID).observe(.value) { [weak self] snapshot in // cardID와 값이 같으면 가져옴
                    guard let self = self,
                          let value = snapshot.value as? [String: [String: Any]],
                          let key = value.keys.first
                    else { return }
                    self.ref.child("\(key)/isSelected").setValue(true)
                }
                ```
        - 셀 선택시 실시간으로 Realtime Database에 값이 변경되는 것을 확인
    2. 카드 리스트에서 카드 데이터 삭제
        - 테이블 뷰 델리게이트 `commit` 메서드 정의 → 스와이프해서 해당 셀 삭제 가능
        - nil 값을 쓴다는 점에서 쓰기와 동일 - `self.ref.child("\(key)/isSelected").setValue(nil)`
        - 삭제를 위한 `removeValue` 함수 사용 가능
            ```swift
            override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
                return true
            }
            
            override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
                if editingStyle == .delete {
                    // Option 1 - 키 이름을 알고 있는 경우
                    let cardId = self.creditCardList[indexPath.row].id
                    self.ref.child("Item\(cardId)").removeValue()
                    
                    // Option 2 - 키 이름을 모르는 경우
                    self.ref.queryOrdered(byChild: "id").queryEqual(toValue: cardId).observe(.value) { [weak self] snapshot in
                        guard let self = self,
                              let value = snapshot.value as? [String: [String: Any]],
                              let key = value.keys.first // snapshot의 value는 배열로 전달되는데 id는 고유한 하나의 값만 가지므로
                        else { return }
                        
                        self.ref.child(key).removeValue()
                    }
                }
            }
            ```
    3. Firestore 생성 후 연결
        - 파이어베이스 콘솔에서 데이터베이스 생성
        - 코코아팟 설치 - `pod 'Firebase/Firestore'`, `pod 'FirebaseFirestoreSwift'`
        - 데이터 추가
            - Realtime Database처럼 JSON 가져오기를 지원하지 않음
            - 코드로 읽기 작업들을 Batch에 넣고 해당 Batch를 커밋하는 방식 사용 → Swift로 작성된 더미 데이터를 AppDelegate에서 데이터를 읽어오는 초기화 작업 최초 1회 실행
                ```swift
                import FirebaseFirestore
                
                let db = Firestore.firestore() // 파이어스토어 db 선언
                  
                db.collection("creditCardList").getDocuments { snapshot, _ in // "creditCardList" 컬렉션 생성
                    guard snapshot?.isEmpty == true else { return } // 스냅샷이 비어있을 경우(db에 아무것도 없는 경우)에만 실행
                    
                    let batch = db.batch()
                    let card0Ref = db.collection("creditCardList").document("card0")
                    let card1Ref = db.collection("creditCardList").document("card1")
                    ...
                
                    do {
                        try batch.setData(from: CreditCardDummy.card0, forDocument: card0Ref) // 경로를 지정해 데이터 쓰기
                        try batch.setData(from: CreditCardDummy.card1, forDocument: card1Ref)
                        ...
                    } catch let error {
                        print("ERROR writing card to Firestore \(error.localizedDescription)")
                    }
                    
                    batch.commit() // 반드시 커밋을 해줘야 업데이트에 반영이 됨
                }
                ```
        - 데이터 읽기
            ```swift
            import FirebaseFirestore
            
            var db = Firestore.firestore()
            
            // Firestore 읽기
            db.collection("creditCardList").addSnapshotListener { snapshot, error in // creditCardList라는 document를 바라보게 함
                guard let documents = snapshot?.documents else { // snapshot에 해당 document가 있을 경우에만 실행
                    print("ERROR Firestore fetching document \(String(describing: error))")
                    return
              }
                
                self.creditCardList = documents.compactMap { doc -> CreditCard? in
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: doc.data())
                        let creditCard = try JSONDecoder().decode(CreditCard.self, from: jsonData)
                        return creditCard
                    } catch let error {
                        print("ERROR JSON Pasring \(error.localizedDescription)")
                        return nil
                    }
                }.sorted { $0.rank < $1.rank }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            ```
        - 데이터 쓰기
            ```swift
            // Firestore 쓰기
            let cardID = self.creditCardList[indexPath.row].id
            
            // Option 1
            db.collection("creditCardList").document("card\(cardID)").updateData(["isSelected": true])
            
            // Option 2
            db.collection("creditCardList").whereField("id", isEqualTo: cardID).getDocuments { snapshot, _ in
                guard let document = snapshot?.documents.first else { // 검색 결과를 배열로 전달
                    print("ERROR Firestore fetching document")
                    return
                }
                
                document.reference.updateData(["isSelected": true])
            }
            ```
        - 데이터 삭제
            ```swift
            // Firestore 삭제
            let cardID = self.creditCardList[indexPath.row].id
            
            // Option 1
            db.collection("creditCardList").document("card\(cardID)").delete()
            
            // Option 2
            db.collection("creditCardList").whereField("id", isEqualTo: cardID).getDocuments { snapshot, _ in
                guard let document = snapshot?.documents.first else {
                    print("ERROR Firestore fetching document")
                    return
                }
                
                document.reference.delete()
            }
            ```

