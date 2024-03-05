# 📱 앱 스토어 앱 만들기

> - UICollectonView로 다양한 화면 구현
> - 메모 앱, 메세지 앱으로 공유하기 기능 구현 

![Simulator Screen Recording - iPhone 14 - 2024-03-05 at 03 13 51](https://github.com/mijisuh/fastcampus-ios/assets/57468832/923fd974-1a69-494d-acd0-9e43f19deb05)

## 개념 정리

<details>
<summary>Share Sheet</summary>

## UIActivityViewController

<img width="848" alt="2" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/8fee0d97-6040-4f6e-a858-1a54992d471b">

- **AirDrop, SMS, 이메일 등 다른 앱으로 공유할 수 있는 기능을 가진 UIViewController**
- URL 등 공유할 컨텐츠 `activityItems: [Any]`와 타입은 개발자가 지정 가능하고, AirDrop, Safari 등 처럼 공유될 목적지 `applicationActivities: [UIActivity]?` 또한 개발자 지정 가능
    - `init(activityItems: [Any], applicationActivities: [UIActivity]?)`
        - `activityItems: [Any]`: 앱에서 공유할 콘텐츠(앱 상세화면으로 이동할 URL)
        - `applicationActivities: [UIActivity]?)`: 공유될 목적지(iOS 기본 메시지 앱)
        - 어떤 앱을 우선 순위로 공유할 것인지, 어떤 앱을 공유에서 제외시킬 것인지 생각해야 함
- iOS 기본 앱 뿐만 아니라 다양한 앱에서 활용

</details>

## 전체 화면 구성

<img width="791" alt="3" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/c10a4173-2eb4-490c-b010-d8239e8b7863">

- 탭 바
    - 2개의 UIViewController
    - 투데이 탭
        - 스크롤 가능한 컬렉션 뷰
        - 셀 클릭 시 앱의 상세 화면으로 이동
        - 공유하기 버튼을 통해 앱 정보 공유
    - 앱 탭
        - 스크롤 가능한 컬렉션 뷰
        - 2개의 섹션

## 구현 내용
1. 앱 스토어 투데이 Tab 구현하기
    - UICollectionView로 구성
    - 화면 레이아웃 설정 값
        
        <img width="774" alt="4" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/8cb3a19b-4ae6-4a34-ba90-62508d9b8acd">
        
        - 헤더
        - 1개의 섹션
        - 셀 스타일 1개
2. 앱 스토어 앱 Tab 구현하기
    - 화면 레이아웃 설정 값
        
        <img width="834" alt="5" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/12cc3b8e-e845-4adb-8e35-f6fceff5f36f">
        
        - UINavigationController에 임베디드됨
        - 서브 뷰로 UIScrollView, UIStackView, UICollectionView를 가짐
            
            <img width="800" alt="6" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/c647ee5d-a70f-4fcf-a09c-32430de2065f">
            
            - UIScrollView + UIStackView의 장점: UIStackView는 자기가 가진 서브 뷰에 의해서 자신의 높이가 정해져서 서브 뷰의 높이 변동이 생기더라도 자동적으로 높이가 늘어나기 때문에 UIScrollView의 높이를 계산할 필요가 없음
            - scrollView에 contentView를 서브뷰로 추가하고 contentView에 stackView를 서브뷰로 추가
        - FeatureSectionView
            - UICollectionView로 구현
            - UICollectionViewCell 커스텀
                
                <img width="858" alt="7" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/2ca07da7-91b7-4c81-9d6e-00e84ac84d6c">
                
        - RankingFeatureSectionView
            - UICollectionView로 구현
                
                <img width="955" alt="8" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/884c00a4-3697-4072-a070-03d0f0432ec4">

                <img width="853" alt="스크린샷 2024-03-05 오전 2 23 23" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/867b32c0-baaa-4c66-a76e-2da4e5f609a7">
                
            - UICollectionViewCell 커스텀
                
                <img width="1117" alt="10" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/5052b4a8-e13b-476e-b17e-efd9a84816f8">
                
                <img width="1117" alt="11" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/fe5449e4-cbcb-4baa-a630-d4ef02f25297">
                
        - ExchangeCodeButtonView
            - 컴포넌트 설정 값
                
                <img width="850" alt="12" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/e2809033-5149-4a02-afd4-243fb13742a9">
                
            - 레이아웃 설정 값
                
                <img width="850" alt="13" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/06fa7358-114b-4077-b140-e8b10fa74543">
                
        - ExchangeCodeButtonView가 화면 하단에 있어 하단과의 여유 간격 필요
            - StackView에 임의의 높이 값만 갖는 UIView 추가
3. 앱 스토어 상세 화면 구현하기
    
    <img width="723" alt="14" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/410cde82-f306-4617-af1e-fcc5c8347fd8">

    - 컴포넌트 설정 값
        
        <img width="975" alt="15" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/e422ad1a-bf6d-4e18-97de-3440a0f4ace7">
        
    - 레이아웃 설정 값
        
        <img width="975" alt="16" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/58aafaff-6fb0-4409-808b-8f906f0b8796">
        
4. UI와 앱 스토어 데이터 연동하기
    - Today.plist
        - TodayViewController에서 사용
        - Today 데이터 모델 생성
        - plist 파일 디코딩해서 데이터 fetching
        - CollectionView Cell에 표시
        - 상세 화면에 데이터 전달
    - Feature.plist
        - AppViewController의 FeatureSectionView에서 사용
        - Feature 데이터 모델 생성
        - plist 파일 디코딩해서 데이터 fetching
        - CollectionView Cell에 표시
    - RankingFeature.plist
        - AppViewController의 RankingFeatureSectionView에서 사용
        - RankingFeature 데이터 모델 생성
        - plist 파일 디코딩해서 데이터 fetching
        - CollectionView Cell에 표시
5. 앱 상세화면에서 앱 공유 기능 구현하기
    
    ```swift
    @objc func didTapShareButton() {
        let activityItems: [Any] = [today.title]
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        present(activityViewController, animated: true)
    }
    ```
    
    - 앱에서 공유할 콘텐츠: 앱의 이름
    - 공유될 목적지: 메시지 앱

## 과제

1. 앱 탭의 UIScrollView 위에 UIStackView를 사용해서 구현했던 화면을 UICollectionView 또는 UITableView로 구현
    
    <img width="1280" alt="17" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/c1c36e36-6c25-4c01-8865-c909675c7b89">
    
2. 앱 탭의 셀을 클릭 했을 때 앱 상세 화면이 나오도록 화면 전환 구현 (Completed)
    
    <img width="1280" alt="18" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/a4b04114-4d1b-4289-b545-a292e9984421">
    
- AppViewController의 서브 뷰인 featureSectionView와 rankingFeatureSectionView에서 화면 이동을 구현하기 위해 presentClosure 정의
    
    ```swift
    // 클로저를 이용한 화면 이동
    let presentClosure: (String, String, String) -> Void = { [weak self] appTitle, subTitle, imageURL in
        guard let self = self else { return }
        let vc = AppDetailViewController(appTitle: appTitle, subTitle: subTitle, imageURL: imageURL)
    
        // 부모 뷰 컨트롤러에서 자식 뷰 컨트롤러로 전달하고 싶은 작업 수행
        self.present(vc, animated: true)
    }
    ```

- featureSectionView와 rankingFeatureSectionView 생성시 클로저 전달

    ```swift
    let featureSectionView = FeatureSectionView(frame: .zero, presentClosure: presentClosure)
    let rankingFeatureSectionView = RankingFeatureSectionView(frame: .zero, presentClosure: presentClosure)
    ```

- 각 collectionView의 `didSelectItemAt` 메서드에서 클로저 호출
    
    ```swift
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let feature = featureList[indexPath.item]
        presentClosure?(feature.appName, feature.description, feature.imageURL)
    }
    ```
    
    ```swift
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let rankingFeature = rankingFeatureList[indexPath.item]
        presentClosure?(rankingFeature.title, rankingFeature.description, "")
    }
    ```
        