# 🔤 번역기 앱

> - 한국어, 영어, 일본어, 중국어 간 번역이 가능
> - Localization으로 앱의 기본 언어로 한국어, 영어를 지원

![Simulator Screen Recording - iPhone 14 - 2024-03-16 at 21 40 48](https://github.com/mijisuh/fastcampus-ios/assets/57468832/38ce12b8-60ac-47ca-bce7-656526c61e8d)

## 개념 정리

<details>
<summary>NSAttributedString와 NSMutableAttributedString 비교</summary>

- NS-: Objective-C의 잔재
- **Mutable**: 변하기 쉬운

## NSAttributedString

```swift
class NSAttributedString: NSObject
```

<img width="1001" alt="1" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/56234b4b-b23e-4e3f-8469-cee56f0eec3c">

- **텍스트 자체에 스타일(색상, 자간, 행간 등)을 설정할 수 있는 텍스트 타입**
- 보통 String을 화면에 표시하기 위해 UILabel, UIText와 같은 UI 컴포넌트의 속성을 변화시켜서 사용했었는데 NSAttributedString은 **String 자체에 스타일 설정**
- 사용 예시
    
    ```swift
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineSpacing = 6.0 // 줄간
    
    let attributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 20.0, weight: .semibold),
        .foregroundColor: UIColor.systemBrown,
        .paragraphStyle: paragraphStyle
    ]
    
    let attributedText = NSAttributedString(
        string: textView.text,
        attributes: attributes
    )
    
    textView.attributedText = attributedText
    ```
    

## NSMutableAttributedString

```swift
class NSMutableAttributedString: NSObject
```

<img width="1001" alt="2" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/3d0d8779-4d34-403a-8fd4-e9cb66058f19">

- **NSAttributedString의 특정 범위(NSRange**)에 다양한 스타일(색상, 자간, 행간 등)을 설정할 수 있는 타입
- 텍스트의 일부분에만 적용하려는 스타일 정의
- **특정 키워드에 대해서 강조**를 하는 등 디자인적인 이유로 사용되는 경우가 많음
- 사용 예시
    
    ```swift
    let mutableAttributedString = NSMutableAttributedString(
        string: textView.text,
        attributes: attributes
    )
    
    // 추가되는 속성
    paragraphStyle.paragraphSpacing = 10.0 // 자간
    let additionalAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 30.0, weight: .thin),
        .foregroundColor: UIColor.systemPink,
        .paragraphStyle: paragraphStyle
    ]
    
    // 범위 설정
    mutableAttributedString.addAttributes(additionalAttributes, range: NSRange(location: 3, length: 10)) // 인덱스 3번쨰부터 10개(길이)까지
    
    textView.attributedText = mutableAttributedString
    ```
</details>

<details>
<summary>Localization</summary>

- iOS 앱에서 표시되는 **텍스트, 이미지, 날짜, 가격 및 통화 기호를 나라별로 다르게 표시될 수 있게 구현**하는 국제화를 위한 최적화 방법
- 아이폰의 기본 언어를 변경함으로 앱의 모든 텍스트가 해당 언어로 변경할 수 있음
- Key-Value 쌍의 데이터로 관리
    
    ```swift
    "키 값" = "표시될 언어의 값";
    ```
    
    <img width="1103" alt="3" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/4289687b-b457-4a91-a91d-d561c2ef7a18">
    
- lokalise: 실무에서 많이 사용하는 Localization 툴
    - 자동으로 strings 파일을 생성하고 갱신해줌
    - 일일히 수정할 필요가 없고 다른 플랫폼(안드로이드)에 동일하게 적용 가능
</details>

## 전체 화면 구성

<img width="946" alt="4" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/bb702071-90bc-43fd-85e2-b1c53381636d">

- 2개의 탭
    - 번역
        - 번역을 워하는 문구를 입력하고 네트워크 통신으로 받아온 번역 결과 값을 화면에 표시
        - 언어 변경
        - 북마크
        - 복사
    - 북마크

## 구현 내용

1. 텍스트 입력 및 번역 결과 화면 구현하기
    - UITabBarController
        - 2개의 ViewController로 구성
            - Translate
            - Bookmark
    - 텍스트 입력을 위한 ViewController로 present
        - UIView Tap 했을 경우 present
            - UIView는 UIButton처럼 addTarget에 대한 유저 액션의 Responder가 없음
            - UITabGestureRecognizer로 Tap 액션에 대한 동작 구현
        - SourceTextViewController
            - UITextView
            - UITextViewDelegate
    - 텍스트 입력 후 텍스트를 이전 ViewController에 전달
        - Delegate 패턴으로 구현
        - Rx로 구현 가능
    - 언어 변경 버튼에 액션 시트 설정
        - UIAlertController
        - 액션 시트에서 선택한 것을  화면에 반영
    - 북마크 버튼 기능 구현
        - DB로 UserDefaults 사용: (Key: “bookmark”, Type: [Bookmark])
            - 번역 전 텍스트 값
            - 번역 전 텍스트의 언어
            - 번역된 텍스트 값
            - 번역된 텍스트의 언어
    - 복사 버튼 기능 구현
        - 클립보드에 복사
            
            ```swift
            UIPasteboard.general.string = resultLabel.text
            ```
            
2. 즐겨찾기 화면 구현하기
    - UINavigationController에 임베드
    - UICollectionView
        - Custom UICollectionViewCell
        - **Dynamic height cell에 대응(UILabel의 줄 수에 의해서 가변)**
3. 네트워크 통신을 사용하여 번역 기능 구현하기
    - Google Cloud Translation API 사용
        - [참고 문서](https://cloud.google.com/translate/docs/overview?hl=ko)
4. Xcode Project에서 Localization에 대한 환경 설정하기
    - Localizable.strings 파일 생성
    - [프로젝트 정보] → [PROJECT] → [Info] → [Localizations] → + 버튼 → 언어 추가
    - [Localization.strings] → [File Inspector] → [Localization] → Localize… 버튼 클릭
    - 언어별로 파일이 생성됨
5. Localization 데이터 생성하기
    
    ```swift
    // TabBar Title
    "Translate" = "Translate";
    "Bookmark" = "Bookmark"; // Navigation Tite
    ```
    
    ```swift
    // TabBar Title
    "Translate" = "번역";
    "Bookmark" = "즐겨찾기"; // Navigation Titel
    ```
    
6. Localization 데이터와 UI를 연동하는 코드 구현하기
    - comment 파라미터는 개발자가 이해하기 쉽도록 주석의 역할을 함
        
        ```swift
        NSLocalizedString("Translate", comment: "번역")
        ```