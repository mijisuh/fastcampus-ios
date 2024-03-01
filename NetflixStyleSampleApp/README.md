# 🎬 넷플릭스 스타일 영화 추천 앱

> - 서로 다른 크기와 형태를 가지는 셀의 목록을 구현해서 넷플릭스 스타일의 화면을 보여줌

![Simulator Screen Recording - iPhone 14 - 2024-03-02 at 03 42 51](https://github.com/mijisuh/fastcampus-ios/assets/57468832/3987b61a-2cd3-469b-9ff8-d812a31b26d1)

## 주요 개념 정리

<details>
<summary>UICollectionView</summary>

## UICollectionView

- **유연하게 변경 가능한 레이아웃을 사용**하여 **특정 타입의 형태로 정렬된 데이터 집합을 표시**하는 방법
- 가장 일반적인 용도는 항목을 격자와 같은 배열로 표시하는 것이지만 iOS의 CollectionView는 그저 행과 열의 나열 뿐만 아니라 다양한 배열 구현이 가능
- UICollectionView는 **데이터와 해당 데이터를 표시하는데 사용되는 시각적 요소(레이아웃)를 엄격히 구분**
    - 데이터를 어떻게 관리할지, 데이터를 어떻게 나타낼지 모두 별도로 고려해서 개발
    - 데이터(컨텐츠) 영역, 레이아웃 영역은 각각 분리되어 각자 역할에 맞는 정보를 제공하고 UICollectionView는 이런 두 구분을 종합해서 최종 형태 구축
    - 퍼포먼스를 위해서 리유저블 뷰 채택
- UICollectionView를 구현하기 위한 Class와 Protocol
    
    | 역할 | Classes/Protocols |  |
    | --- | --- | --- |
    | Top-level containment, management | UICollectionView, UICollectionViewController | - 시각적인 요소 정의UIScrollView 상속 <br> - Layout 정보 기반 데이터 표시 |
    | Content management | UICollectionViewDataSource, UICollectionViewDelegate | - DataSource(필수 요소): Content 관리 및 Content 표시에 필요한 View 생성 <br> - Delegate(선택 요소): 특정 상황에서 View 동작 custom |
    | Presentation | UICollectionReusableView, UICollectionViewCell |   - UICollectionView에 표시되는 모든 뷰는 UICollectionReusableView의 인스턴스여야 함 <br> - Header, Footer, … <br> - 재사용 가능(성능 향상) |
    | Layout | UICollectionViewLayout, UICollectionViewLayoutAttributes, UICollectionViewUpdateItem | - UICollectionView만 가지고 있는 속성 <br> - 각 항목 배치 등 시각적 스타일 담당 <br> - View를 직접 소유하지 않는 대신 Attributes 생성 <br> - 데이터 항목 수정 시 UpdateItem 인스턴스 수신 <br> → 이런 책임 분리를 통해서 앱에서 관리하는 데이터 객체를 변경하지 않고도 레이아웃을 동적으로 변경 가능 |
    | Flow layout | UICollectionViewFlowLayout, UICollectionViewDelegateFlowLayout | - Grid, Line-based Layout 구현 <br> - 레이아웃 정보를 동적으로 custom |

- 5가지 요소를 합쳐 CollectionView가 표시되는 모습
    
    <img width="747" alt="1" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/544b47bf-2e78-48d1-a38b-e7ec733a6f44">
    
    - CollectionView는 Data source에서 표시할 Cell에 대한 정보를 가져옴
    - DataSource와 Delegate 객체는 사용자 지정 객체(셀 선택, 강조 표시 등)를 포함해서 콘텐츠를 관리하는데 사용
    - Layout 객체들은 해당 셀이 속하는 위치를 결정하고 해당 정보를 하나 이상의 레이아웃 속성 객체 형태로 CollectionView에 보내는 역할을 함
    - CollectionView는 레이아웃 정보를 실제 Cell을 포함한 다른 ReusableView들과 병합해서 최종적으로 보여지는 presentation을 만듬

## UICollectionViewFlowLayout

- 다양한 레이아웃이 중첩된 형태 구현 가능
- 애플에서 UICollectionView는 FlowLayout만 이용해서 레이아웃을 설정하라고 권장
- iOS 13부터 UICollectionViewCompositionalLayout을 제공해 직관적인 간편한 레이아웃 구현 가능

## Compositional Layout

- 주요 내용
    - **구성가능하게**: 복잡한 결과를 단순한 구성요소로 구성하기
    - **유연하게**: 이것만으로 모든 레이아웃을 작성 가능하게 하기
    - **빠르게**: 프레임워크에서 자체 성능 최적화 수행
- 3가지 주요 구성 요소
    - **Item**: 개별 컨텐츠의 크기, 공간, 정렬 방법에 대한 청사진 역할
        
        <img width="904" alt="2" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/ec4b6256-c8ef-4024-aca6-0a349961994c">
        
        - size: (너비, 높이 값)의 dimension(치수)을 가짐 → `Absolute`, `Estimate`(런타임에 콘텐츠 크기가 변경될 수 있는 경우에 사용), `Fractional`(비율, 분수 값)
    - **Group**: item들이 서로 관련하여 배치되는 방법을 결정해서 결합(그룹핑)하는 역할
        
        <img width="965" alt="3" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/198560c5-02e3-4e52-b947-39810f6f50a1">
        
        - 항목을 가로(행), 세로(열) 또는 사용자 지정 배열로 배치 가능
        - 각 그룹을 자신의 사이즈를 지정할 때 item과 같이 Absolute, Estimate, Fractional 방식으로 표현 가능
        - 그룹이 그룹 표현 가능
            
            <img width="557" alt="4" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/f7f7e0d1-5dc6-4400-bb03-f2ff7b2296bf">
            
    - **Section**
        
        <img width="955" alt="5" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/bc5aeba5-0461-4876-9815-2b8428edef50">
        
        - group으로 이루어져 있음
        - CollectionView는 하나 이상의 section으로 이루어져 있음
        - section은 레이아웃을 각각의 영역으로 분리하는 방법을 제공
        - 각 section은 컬렉션 뷰의 다른 section과 레이아웃이 같거나 다를 수 있음 → 이러한 section의 레이아웃은 section을 만드는데 사용되는 group의 속성에 의해서 결정
- **Layout**
    
    <img width="921" alt="6" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/3c1f8154-3b4c-40a5-8bfe-2680bec82bbd">
    
    - item, group, section의 모든 구성 요소들을 반영
    - item > group > section > layout
</details>

<details>
<summary>SnapKit</summary>

## Xcode에서 UI 구현하기

- Interface Builder로 구현: Storyboard
- Code로 구현
    - AutoLayout도 코드로 작성 가능
- SwiftUI로 구현

## SnapKit

- 코드베이스로 UI를 구현하고 AutoLayout을 고려해야 할 때 직관적이고 간편하게 작성 할 수 있도록 도와주는 오픈소스 프레임워크

## Swift Package Manager

- CocoaPods처럼 외부 라이브러리를 활용하기 위해 사용
- 패키지를 사용하고자 하는 프로젝트에 dependency 주소를 추가하면 됨
</details>

## 구현 내용
1. 기본적으로 생성되는 UIViewController와 MainStoryboard 삭제
    - info.plist에서 Main storyboard file base name와 Application Scene Manifest → … → Storyboard Name 삭제
2. 새로운 VC 생성
    - 이니셜 뷰 컨트롤러로 지정 → SceneDelegate
        
        ```swift
        func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
            guard let windowScene = scene as? UIWindowScene else { return }
            self.window = UIWindow(windowScene: windowScene)
            
            let layout = UICollectionViewFlowLayout()
            let homeViewController = HomeViewController(collectionViewLayout: layout) // UICollectionView는 FlowLayout이 있어야만 생성 가능
            let rootNavigationController = UINavigationController(rootViewController: homeViewController)
            
            self.window?.rootViewController = rootNavigationController
            
            self.window?.makeKeyAndVisible() // 설정한 값들을 실제로 보여줌
        }
        ```
        
3. Swift Package Manager로 SnapKit 설치
    - Project 설정 → Package Dependencies → + 클릭 → 깃헙 주소 입력
4. Navigation Bar 커스텀
    - `#imageLiteral()` 로 Assets에 추가한 이미지 확인해서 추가 가능
        
        ```swift
        private func configureNavigationView() {
            self.navigationController?.navigationBar.backgroundColor = .clear
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.navigationController?.navigationBar.shadowImage = UIImage() // 투명하지만 그림자를 줘서 네비게이션 바의 경계 확인 가능
            self.navigationController?.hidesBarsOnSwipe = true
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "netflix_icon"), style: .plain, target: nil, action: nil)
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.crop.circle"), style: .plain, target: nil, action: nil)
        }
        ```
        
    - tint color로 보여지므로 Image Set 속성에서 Render를 Original Image로 변경
5. CollectionView에 뿌려줄 데이터 형태를 보고 그에 맞는 객체를 구조체 정의
    - Content.plist로 정의
        - [sectionType, sectionName, [contentItem]] 형태
        - contentItem은 [description, imageName]
    - 읽기 작업만 할 것이기 때문에 Decodable로 정의
        
        ```swift
        struct Content: Decodable {
            let sectionType: SectionType // 몇몇 케이스로 정해져 있음 -> enum
            let sectionName: String
            let contentItem: [Item]
         
            enum SectionType: String, Decodable {
                case basic
                case main
                case large
                case rank
            }
        }
        
        struct Item: Decodable {
            let description: String
            let imageName: String // 파일명과 일치 -> UIImage로 바로 만들 수 있음
            
            var image: UIImage {
                return UIImage(named: imageName) ?? UIImage()
            }
        }
        ```
        
6. 파일에서 데이터 가져오기
    - Content.plist에서 데이터 가져와서 [Content] 형태로 변환
        
        ```swift
        private func getContents() -> [Content] {
            guard let path = Bundle.main.path(forResource: "Content", ofType: "plist"), // 파일의 경로
                  let data = FileManager.default.contents(atPath: path),
                  let list = try? PropertyListDecoder().decode([Content].self, from: data)
            else { return [] }
            return list
        }
        ```
        
7. CollectionView의 DataSource 설정
    - 메서드 구현
    - 셀 생성
        
        ```swift
        import UIKit
        import SnapKit
        
        class ContentCollectionViewCell: UICollectionViewCell {
            
            let imageView = UIImageView()
            
            override func layoutSubviews() {
                super.layoutSubviews()
                
                // 셀의 레이아웃에는  기본 셀이 있고 contentView라는 기본 객체가 있음
                // contentView를 superView로 보고 그 안에 subView 추가
                self.contentView.backgroundColor = .white
                self.contentView.layer.cornerRadius = 5
                self.contentView.clipsToBounds = true
                
                self.imageView.contentMode = .scaleToFill
                
                self.contentView.addSubview(self.imageView)
                
                // imageView AutoLayout 설정
                self.imageView.snp.makeConstraints {
                    $0.edges.equalToSuperview()
                }
            }
            
        }
        ```
        
    - Header 생성: 반드시 `UICollectionReusableView` 타입이어야 함
        
        ```swift
        import UIKit
        import SnapKit
        
        class ContentCollectionViewHeader: UICollectionReusableView {
            
            let sectionNameLabel = UILabel()
            
            override func layoutSubviews() {
                super.layoutSubviews()
                
                self.sectionNameLabel.font = .systemFont(ofSize: 17, weight: .bold)
                self.sectionNameLabel.textColor = .white
                self.sectionNameLabel.sizeToFit()
                
                self.addSubview(sectionNameLabel)
                
                self.sectionNameLabel.snp.makeConstraints {
                    $0.centerY.equalToSuperview()
                    $0.top.bottom.leading.equalToSuperview().offset(10)
                }
            }
            
        }
        ```
        
    - CollectionView에 생성한 셀과 헤더를 register
        
        ```swift
            private func configureCollectionView() {
                // CollectionView Item(Cell) 설정
                self.collectionView.register(ContentCollectionViewCell.self, forCellWithReuseIdentifier: "ContentCollectionViewCell")
                
                // CollectionView Header 설정
                self.collectionView.register(ContentCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "ContentCollectionViewHeader")
            }
        ```
        
    - CollectionView 셀, 헤더 설정
        
        ```swift
        // 컬렉션 뷰 셀 설정
        override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            switch contents[indexPath.row].sectionType {
            case .basic, .large:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContentCollectionViewCell", for: indexPath) as? ContentCollectionViewCell else { return UICollectionViewCell() }
                cell.imageView.image = contents[indexPath.section].contentItem[indexPath.row].image
                return cell
            default:
                return UICollectionViewCell()
            }
        }
        
        // 헤더 뷰 설정
        override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
            if kind == UICollectionView.elementKindSectionHeader {
                guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ContentCollectionViewHeader", for: indexPath) as? ContentCollectionViewHeader else { fatalError("Could nor dequeue Header") }
                headerView.sectionNameLabel.text = contents[indexPath.row].sectionName
                return headerView
            } else {
                return UICollectionReusableView()
            }
        }
        ```
        
8. 배너 구현하기
    - SwiftUI Preview Provider 추가 → 시뮬레이터 빌드 작업 없이 UI 확인 가능
        
        ```swift
        // SwiftUI를 활용한 미리보기
        struct HomeViewControllerPreview: PreviewProvider {
            
            static var previews: some View {
                Container().edgesIgnoringSafeArea(.all)
            }
            
            struct Container: UIViewControllerRepresentable {
                
                func makeUIViewController(context: Context) -> UIViewController {
                    let layout = UICollectionViewLayout()
                    let homeViewController = HomeViewController(collectionViewLayout: layout)
                    return UINavigationController(rootViewController: homeViewController)
                }
                
                func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
                }
                
                typealias UIViewControllerType = UIViewController
            }
            
        }
        ```
        
    - 처음 CollectionViewController를 만들 때 SceneDelegate에서 아무 것도 설정하지 않은 FlowLayout을 만들어 설정했지만 실제로 뷰가 복잡해지면 각각의 데이터를 그에 맞는 레이아웃에 적용할 수 있게 해야 함
        - basic 타입: 기본 Compositional Layout
            
            ```swift
            private func createBasicTypeSection() -> NSCollectionLayoutSection {
                // item
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3), heightDimension: .fractionalHeight(0.75))
                
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = .init(top: 10, leading: 5, bottom: 0, trailing: 5)
                
                // group
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .estimated(200))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
                
                // section
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous // 스크롤의 행동
                section.contentInsets = .init(top: 0, leading: 5, bottom: 0, trailing: 5)
                
                return section
            }
            ```
            
        - large 타입: basic 타입에서 크기만 커짐
            
            ```swift
            // 큰 화면 Section Layout 설정
            private func createLargeTypeSection() -> NSCollectionLayoutSection {
                // item
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3), heightDimension: .fractionalHeight(0.75)) // basic과 같은 사이즈여도 group 사이즈를 조정하면 그 비율대로 더 커짐
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = .init(top: 10, leading: 5, bottom: 0, trailing: 5)
                
                // group
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .estimated(400))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
                
                // section
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                
                let sectionHeader = self.createSectionHeader()
                section.boundarySupplementaryItems = [sectionHeader]
                section.contentInsets = .init(top: 0, leading: 5, bottom: 0, trailing: 5)
                
                return section
            }
            ```
            
        - rank 타입: 포스터 이미지와 순위를 표시하는 라벨이 있는 셀 생성 후 collectionView 등록 작업 필요
            
            ```swift
            // 순위 표시 Section Layout 설정
            private func createRankTypeSection() -> NSCollectionLayoutSection {
                // item
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3), heightDimension: .fractionalHeight(0.9))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = .init(top: 10, leading: 5, bottom: 0, trailing: 5)
                
                // group
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .estimated(200))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
                
                //section
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                
                let sectionHeader = self.createSectionHeader()
                section.boundarySupplementaryItems = [sectionHeader]
                section.contentInsets = .init(top: 0, leading: 5, bottom: 0, trailing: 5)
                
                return section
            }
            ```
            
        - Section Header
            
            ```swift
            // Section Header Layout 설정
            private func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
                // Section Header 사이즈
                let layoutSectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(30))
                
                // Section Header Layout
                let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutSectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
                
                return sectionHeader
            }
            ```
            
    - 타입 별로 레이아웃 적용을 다르게 할 수 있도록 분기 설정
        - layout 함수 정의
            
            ```swift
            // 섹션에 따라 다른 레이아웃을 적용하기 위해 클로저로 분기
            // 각각의 섹션 타입에 대한 UICollectionViewLayout 생성
            private func layout() -> UICollectionViewLayout {
                return UICollectionViewCompositionalLayout { [weak self] sectionNumber, environment -> NSCollectionLayoutSection? in
                    guard let self = self else { return nil }
                    switch self.contents[sectionNumber].sectionType {
                    case .basic:
                        return self.createBasicTypeSection()
                    case .large:
                        return self.createLargeTypeSection()
                    case .rank:
                        return self.createRankTypeSection()
                    case .main:
                        return self.createMainTypeSection()
                    }
                }
            }
            ```
            
        - collectionView에 설정
            
            ```swift
            self.collectionView.collectionViewLayout = self.layout()
            ```
            
        - CellForRowAt 메서드
            
            ```swift
            // 컬렉션 뷰 셀 설정
            override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                switch contents[indexPath.section].sectionType {
                case .basic, .large:
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContentCollectionViewCell", for: indexPath) as? ContentCollectionViewCell else { return UICollectionViewCell() }
                    cell.imageView.image = contents[indexPath.section].contentItem[indexPath.row].image
                    return cell
                case .rank:
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContentCollectionViewRankCell", for: indexPath) as? ContentCollectionViewRankCell else { return UICollectionViewCell() }
                    cell.imageView.image = contents[indexPath.section].contentItem[indexPath.row].image
                    cell.rankLabel.text = String(describing: indexPath.row + 1)
                    return cell
                case .main:
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContentCollectionViewMainCell", for: indexPath) as? ContentCollectionViewMainCell else { return UICollectionViewCell() }
                    cell.imageView.image = mainItem?.image
                    cell.descriptionLabel.text = mainItem?.description
                    return cell
                }
            }
            ```
            
9. 리스트 구현하기
    - main 타입
        - Cell 생성 및 register
        - contents 중 랜덤으로 선택
            
            ```swift
            self.mainItem = contents.first?.contentItem.randomElement()
            ```
            
        - CellForRowAt
        - Layout 설정

