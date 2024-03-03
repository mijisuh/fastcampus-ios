# 💳 자산관리 앱 만들기

> SwiftUI를 이용해 자산관리 앱 UI를 구성할 수 있음

![Simulator Screen Recording - iPhone 14 - 2024-03-03 at 22 11 49](https://github.com/mijisuh/fastcampus-ios/assets/57468832/609567bc-ed5a-4368-9605-354fa036e871)

## 주요 개념 정리

<details>
<summary>SwiftUI 기본 개념</summary>

## SwiftUI

> “The shortest path to a great app and great UI”

- 애플이 제공하는 모든 플랫폼에서 앱의 사용자 인터페이스와 동작을 선언
    - 앱의 사용자 인터페이스를 제공하기 위한 뷰, 컨트롤, 레이아웃을 구조체 형태로 제공
    - 탭이나 제스쳐 등 입력을 앱에 전달하기 위한 이벤트 핸들러와 앱 모델에서 사용자가 보고 상호작용을 할 뷰, 컨트롤에 대한 데이터 흐름을 관리할 도구 제공
- 완전히 새로운 프레임워크이지만 친숙함 → UIKit 프레임워크를 포함
- UIKit의 View는 UI 컴포넌트 중 하나지만 **SwiftUI의 View는 상태 함수**
    - 표현하고자 하는 UI의 속성을 상태로 표현하고 이러한 상태를 함수 형태의 인자로 전달하면 SwiftUI의 프레임워크가 알아서 해석해서 View로 표현
        
        <img width="533" alt="1" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/5ab69d58-c18c-4023-b736-80728f6ab984">
        
    - **Property Wrapper**: 데이터의 흐름이 외부/내부인지에 따라서 `@State`, `@ObservableObject`로 나누어짐
        
        | @State | @ObservableObject |
        | --- | --- |
        | View-local | External |
        | Value Type | Reference Type |
        | Framework Managed(프레임워크에서 자체적으로 관리) | Developer Managed(개발자가 직접 선언체 관리) |
    - Data Flow
        
        <img width="776" alt="2" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/ebbb97de-0423-41c6-b12a-2e47a488d5b9">
        
        1. User Interaction을 통한 액션 발생
        2. 액션을 통한 변화는 상태(@State)를 변화시킴
        3. 그에 대한 업데이트가 View에 전달
        4. 최종적으로 업데이트에 따라 View가 새롭게 Rendering
- **선언형 프로그래밍 방식**으로 코드 작성
- 명령형과 선언형 접근 방식
    - **명령형**: “어떻게”
        
        <img width="614" alt="3" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/b6ce3441-923d-47d3-8249-476cc4ef0567">
        
        - 컨트롤러 코드가 뷰를 인스턴스화 및 구성하고 조건이 변경됨에 따라 지속적으로 업데이트 해야 하는 부담이 있음
    - **선언형**: “무엇을”
        
        <img width="614" alt="4" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/f468ab9f-e35a-4a6a-a7a2-c3bfcfa8697b">
        
        - 인터페이스가 원하는 레이아웃을 미러링하는 계층 구조에서 뷰를 선언하고 사용자 인터페이스에 대한 간단한 설명을 만듬 → SwiftUI가 사용자 입력이나 상태 변경과 같은 이벤트에 대한 응답으로 뷰를 그리고 업데이트하는 것을 관리
        - SwiftUI는 사용자 인터페이스에서 뷰를 정의하고 구성하기 위한 도구를 제공
    - 사용자 관점에서는 큰 차이를 느낄 수 없지만 코드 작성과 성능 측면에서 차이가 있음
- SwiftUI와 기본의 UIKit 컴포넌트를 같이 활용하는 방법
    - SwiftUI는 모든 애플 플랫폼의 기존 UI 프레임워크와 원활하게 작동
    - UIKit의 View와 ViewController를 SwiftUI의 View 내에 배치 가능(반대도 가능)
    - NetfilxStyleSampleApp을 SwiftUI로 연결하도록 수정 가능
        - SwiftUI(루트 뷰) → NetflixStyleSampleApp(HomeViewController) → SwiftUI(상세 화면)
        - `UIHostingController`를 이용해서 연결
</details>

<details>
<summary>SwiftUI의 Container View</summary>

- UIKit에서 반복되는 컨텐츠를 그룹핑하고 나타내는 방법
    - ScrollView와 StackView 결합
    - TableView, CollectionView 사용
- SwiftUI에서도 여러 형태의 그룹핑 가능한 뷰를 제공

## Stack

<img width="864" alt="5" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/83ddcb70-8d5e-4fa6-bc35-26e650398879">

- SwiftUI에서 가장 기본적으로 사용하는 레이아웃 컨테이너
- 뷰 컨테이너를 수평, 수직 방향으로 배치하거나 겹쳐서 쌓아서 그룹화 가능
    - HStack
    - VStack
    - ZStack
- LazyStack
    
    <img width="772" alt="6" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/12412ad5-09c0-4bec-982d-2e261ac194fb">
    
    - 뷰 또는 뷰 그룹 반복
    - 콘텐츠가 컨테이너 범위를 넘어서서 확장될 수 있도록 스크롤 뷰 내부에 스택 뷰 배치
- **Stack vs LazyStack**
    - Stack은 자식 뷰를 한번에 모두 로드하기 때문에 레이아웃을 빠르고 안정적으로 보이게 만들 수 있음 → 로드할 때 시스템 단에서 하위 뷰의 크기와 모양을 다 알고 있기 때문에
    - LazyStack은 성능을 위해서 어느 정도 레이아웃 정확성을 등가 교환 → 하위 뷰가 표시될 때만 그 크기와 위치를 계산
    - **자식 뷰가 너무 많거나 예측 불가능한 경우에만 LazyStack을 사용하는 것을 권고**
- 스크롤 뷰를 포함하고 있지 않아 컨테이너 범위를 넘어가는 컨텐츠가 있는 경우에는 스크롤 뷰를 먼저 설정하고 내부에 정의

## Grid

<img width="769" alt="7" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/aad067f5-100c-4a24-a1ca-001a02d6093e">

- 뷰를 수평과 수직 동시에 배치하려면 LazyHGrid, LazyVGrid 사용
- 정사각형 컨테이너에 자연스럽게 표시되는 컨텐츠를 레이아웃하는데 적합한 컨테이너 뷰
- Grid는 더 큰 장치에 표시하기 위해서 사용자 인터페이스 레이아웃을 확장하는데 사용
    - 아이폰 앱 화면 → 아이패드 앱 화면 확장
- 스크롤 뷰 포함하지 않음

## List

<img width="418" alt="8" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/dee52fea-515e-4ebd-acf5-070c44d3a702">

- Divider나 Indicator와 같은 플랫폼에 적합한 시각적 스타일 포함
- 항목 삽입, 재정렬, 삭제 등 상호작용 지원
- 내부의 행이 Lazy하게 로드됨
- 스크롤 뷰가 포함됨

## Form

<img width="926" alt="9" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/ac696194-61d9-4367-8bf6-04a6d95fa0ae">

- 기본 설정 화면을 구축하는데 적합
- 플랫폼 별로 UI 구성을 다르게 개발할 필요 없이 동일한 코드를 자동으로 각 플랫폼에 적합한 방식으로 내용을 표시해줌
- Form 내부의 Control Layout은 플랫폼에 따라 다르게 보일 수 있음
</details>

## 구현 내용
1. 사용자 시스템의 라이트, 다트 모드에 상관없이 라이트 모드로만 앱 설정
    - info.plist → Appearance 항목 추가 → 값을 Light로 설정
2. TabView 생성
    - 하단에 표시될 탭 아이템을 enum으로 표현
        
        ```swift
        @State private var selection: Tab = .asset
            
            enum Tab { // 하단에 표시될 탭
                case asset
                case recommend
                case alert
                case setting
            }
            
            var body: some View {
                TabView(selection: $selection) {
                    Color.white
                        .tabItem {
                            Image(systemName: "dollarsign.circle.fill")
                            Text("자산")
                        }
                        .tag(Tab.asset)
                    Color.blue
                        .edgesIgnoringSafeArea(.all)
                        .tabItem {
                            Image(systemName: "hand.thumbsup.fill")
                            Text("추천")
                        }
                        .tag(Tab.recommend)
                    Color.yellow
                        .edgesIgnoringSafeArea(.all)
                        .tabItem {
                            Image(systemName: "bell.fill")
                            Text("알림")
                        }
                        .tag(Tab.alert)
                    Color.red
                        .edgesIgnoringSafeArea(.all)
                        .tabItem {
                            Image(systemName: "gearshape.fill")
                            Text("설정")
                        }
                        .tag(Tab.setting)
                }
            }
        ```
        
3. Navigation 생성
    - NavigationBar 커스텀 → ViewModifier를 통해서 별도의 구조체로 정의
    - ViewModifier를 뷰에 함수처럼 적용해서 ViewModifier가 표현하고 있는 내용을 그대로 적용 가능
        - ViewModifier 프로토콜 채택
            
            ```swift
            struct NavigationBarWithButtonStyle: ViewModifier {
                
                var title: String = ""
                
                func body(content: Content) -> some View {
                    return content // content에 어떤 설정을 할 것인가
                        .navigationBarItems(
                            leading: Text(title)
                                .font(.system(size: 24, weight: .bold))
                                .padding(),
                            trailing: Button(
                                action: {
                                    print("자산 추가 버튼  tapped")
                                },
                                label: {
                                    Image(systemName: "plus")
                                    Text("자산 추가")
                                        .font(.system(size: 12))
                                        .padding(.trailing, 8)
                                }
                            )
                            .accentColor(.black)
                            .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.black) // 내부를 채우지 않고 테두리만 보여줌
                            )
                        )
                        .navigationBarTitleDisplayMode(.inline)
                        .onAppear {
                            let appearance = UINavigationBarAppearance()
                            appearance.configureWithOpaqueBackground() // 투명한 배경
                            appearance.backgroundColor = UIColor(white: 1, alpha: 0.5) // 반투명
                            UINavigationBar.appearance().standardAppearance = appearance
                            UINavigationBar.appearance().compactAppearance = appearance // 줄어들었을 때
                            UINavigationBar.appearance().scrollEdgeAppearance = appearance
                        }
                }
                
            }
            
            extension View {
                func navigationBarWithButtonStyle(_ title: String) -> some View { // View가 직접적으로 이 함수를 사용할 수 있도록 정의
                    return self.modifier(NavigationBarWithButtonStyle(title: title))
                }
            }
            ```
            
4. Grid View 만들기
    - 버튼을 표현하기 위한 Entity 생성
        
        ```swift
        enum AssetMenu: String, Identifiable, Decodable {
            case creditScore
            case bankAccount
            case investment
            ...
            
            // Identifiable 프로토콜 요구사항 -> id 설정
            var id: String {
                return self.rawValue
            }
            
            var systemImageName: String {
                switch self {
                case .creditScore:
                    return "number.circle"
                case .bankAccount:
                    return "banknote"
                case .investment:
                    return "bitcoinsign.circle"
                ...
            }
            
            var title: String {
                switch self {
                case .creditScore:
                    return "신용점수"
                case .bankAccount:
                    return "계좌"
                case .investment:
                    return "투자"
                ...
            }
        }
        
        ```
        
    - 동일한 형태의 반복되는 버튼의 경우 재사용 가능하도록 `ButtonStyle` 사용해서 커스텀
        
        ```swift
        struct AssetMenuButtonStyle: ButtonStyle {
            
            let menu: AssetMenu
            
            func makeBody(configuration: Configuration) -> some View {
                return VStack {
                    Image(systemName: menu.systemImageName)
                        .resizable()
                        .frame(width: 30, height: 30)
                        .padding([.leading, .trailing], 10)
                    Text(menu.title)
                        .font(.system(size: 12, weight: .bold))
                }
                .padding()
                .foregroundColor(.blue)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10)) // 전체 모양을 오려내듯이 표현
            }
            
        }
        ```
        
    - AssetMenuGridView 생성
        
        ```swift
        struct AssetMenuGridView: View {
            
            let menuList: [[AssetMenu]] = [
                [.creditScore, .bankAccount, .investment, .loan],
                [.insurance, .creditCard, .cash, .realEstate]
            ]
            
            var body: some View {
                VStack(spacing: 20) {
                    ForEach(menuList, id: \.self) { row in
                        HStack(spacing: 10) {
                            ForEach(row) { menu in
                                Button("") {
                                    print("\(menu.title) 버튼 tapped")
                                }
                                .buttonStyle(AssetMenuButtonStyle(menu: menu)) // ButtonStyle 사용
                            }
                        }
                    }
                }
            }
            
        }
        ```
        
5. 배너 만들기
    - Asset 배너 Entity 생성
    - BannerCard 구현
        
        ```swift
        struct BannerCard: View {
            var banner: AssetBanner
            var body: some View {
                // ZStack으로 구현
                ZStack {
                    Color(banner.backgroundColor)
                    VStack {
                        Text(banner.title)
                            .font(.title)
                        Text(banner.description)
                            .font(.subheadline)
                    }
                }
                
                // overlay로 구현
        //        Color(banner.backgroundColor)
        //            .overlay {
        //                VStack {
        //                    Text(banner.title)
        //                        .font(.title)
        //                    Text(banner.description)
        //                        .font(.subheadline)
        //                }
        //            }
            }
        }
        ```
        
    - PagnViewController 생성: 좌우 스크롤
        - UIKit의 UIPageViewController 활용 → `UIViewControllerRepresentable` 프로토콜 준수
            
            ```swift
            struct PageViewController<Page: View>: UIViewControllerRepresentable { // Page 역할을 한 View를 받음
                
                var pages: [Page]
                @Binding var currentPage: Int // 현재 어떤 페이지가 보여지는지 상태 확인
                
                func makeCoordinator() -> Coordinator {
                    Coordinator(self)
                }
                
                func makeUIViewController(context: Context) -> UIPageViewController {
                    let pageViewController = UIPageViewController(
                        transitionStyle: .scroll,
                        navigationOrientation: .horizontal
                    )
                    
                    pageViewController.dataSource = context.coordinator
                    pageViewController.delegate = context.coordinator
                    
                    return pageViewController
                }
                
                func updateUIViewController(_ pageViewController: UIPageViewController, context: Context) {
                    pageViewController.setViewControllers(
                        [context.coordinator.controllers[currentPage]],
                        direction: .forward,
                        animated: true
                    )
                }
                
                class Coordinator: NSObject, UIPageViewControllerDataSource, UIPageViewControllerDelegate { // SwiftUI에서 UIPageViewController를 사용하려면 UIKit의 속성인 DataSource, Delegate 설정을 해야하는데 이를 위한 조정자 설정
                    var parent: PageViewController
                    var controllers = [UIViewController]()
                    
                    init(_ pageViewController: PageViewController) {
                        parent = pageViewController
                        controllers = parent.pages.map { UIHostingController(rootView: $0) } // UIHostingController로 감싸줘야 SwiftUI에서 사용 가능
                    }
                    
                    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
                        guard let index = controllers.firstIndex(of: viewController) else { return nil }
                        if index == 0 {
                            return controllers.last
                        }
                        return controllers[index - 1]
                    }
                    
                    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
                        guard let index = controllers.firstIndex(of: viewController) else { return nil }
                        if index + 1 == controllers.count {
                            return controllers.first
                        }
                        return controllers[index + 1]
                    }
                    
                    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
                        if completed,
                           let visibleViewController = pageViewController.viewControllers?.first,
                           let index = controllers.firstIndex(of: visibleViewController) {
                            parent.currentPage = index // 애니메이션이 끝나는 시점에 인덱스 설정
                        }
                    }
                }
                
            }
            ```
            
        - PageController 구현 → `UIViewRepresentable` 프로토콜 준수
            
            ```swift
            struct PageControl: UIViewRepresentable {
                
                var numberOfPages: Int
                @Binding var currentPage: Int
                
                func makeCoordinator() -> Coordinator {
                    Coordinator(self)
                }
                
                func makeUIView(context: Context) -> UIPageControl {
                    let control = UIPageControl()
                    control.numberOfPages = numberOfPages
                    control.addTarget(context.coordinator, action: #selector(Coordinator.updateCurrentPage(sender:)), for: .valueChanged)
                    return control
                }
                
                func updateUIView(_ uiView: UIPageControl, context: Context) {
                    uiView.currentPage = currentPage
                }
                
                class Coordinator: NSObject {
                    var control: PageControl
                    
                    init(_ control: PageControl) {
                        self.control = control
                    }
                    
                    @objc func updateCurrentPage(sender: UIPageControl) {
                        control.currentPage = sender.currentPage
                    }
                }
                
            }
            ```
            
    - AssetView에 추가
        - AssetBannerView 생성
            
            ```swift
            struct AssetBannerView: View {
                
                var bannerList: [AssetBanner] = [
                    AssetBanner(title: "공지사항", description: "공지사항을 확인하세요", backgroundColor: .red),
                    AssetBanner(title: "주말 이벤트", description: "주말 이벤트를 놓치지 마세요", backgroundColor: .yellow),
                    ...
            		]
                
                @State private var currentPage = 0
                var body: some View {
                    let bannerCards = bannerList.map { BannerCard(banner: $0) }
                    
                    ZStack(alignment: .bottomTrailing) {
                        PageViewController(pages: bannerCards, currentPage: $currentPage)
                        PageControl(numberOfPages: bannerList.count, currentPage: $currentPage)
                            .frame(width: CGFloat(bannerCards.count * 18))
                            .padding(.trailing)
                    }
                }
            }
            ```
            
        - AssetView에 추가
            
            ```swift
            AssetBannerView()
                .aspectRatio(5/2, contentMode: .fit)
            ```
            
6. 자산 관리 리스트 만들기
    - json 파일을 디코딩해서 Entity에 데이터 받아옴
        
        ```swift
        class Asset: Identifiable, ObservableObject, Decodable {
            let id: Int
            let type: AssetMenu
            let data: [AssetData]
            
            init(id: Int, type: AssetMenu, data: [AssetData]) {
                self.id = id
                self.type = type
                self.data = data
            }
        }
        
        class AssetData: Identifiable, ObservableObject, Decodable {
            let id: Int
            let title: String
            let amount: String
            
            init(id: Int, title: String, amount: String) {
                self.id = id
                self.title = title
                self.amount = amount
            }
        }
        ```
        
    - 외부에서 별도의 데이터 모델을 이용해서 데이터를 디코딩한 다음에 `ObservableObject`를 이용해서 데이터를 뿌려줌
        
        ```swift
        class AssetSummaryData: ObservableObject {
            
            @Published var assets: [Asset] = load("assets.json") // 어떤 데이터를 내보낼지 표현
            
        }
        
        func load<T: Decodable>(_ filename: String) -> T { // json 파일을 입력 받으면 원하는 형태로 디코딩해주는 함수
            let data: Data
            
            guard let url = Bundle.main.url(forResource: filename, withExtension: nil) else {
                fatalError(filename + "을 찾을 수 없습니다.")
            }
            
            do {
                data = try Data(contentsOf: url)
            } catch {
                fatalError(filename + "을 찾을 수 없습니다.")
            }
            
            do {
                let decoder = JSONDecoder()
                return try decoder.decode(T.self, from: data)
            } catch {
                fatalError(filename + "을 \(T.self)로 파싱할 수 없습니다.")
            }
        } 
        ```
        
    - 헤더 뷰 생성
    - 섹션 뷰 생성
        - 데이터 모델을 연결
            
            ```swift
            struct AssetSummaryView: View {
                
                @EnvironmentObject var assetData: AssetSummaryData // 외부에서 데이터를 받아서 전체 상태를 변경시키고 표현
                
                var assets: [Asset] {
                    return assetData.assets
                }
                
                var body: some View {
                    VStack(spacing: 20) {
                        ForEach(assets) { asset in
                            AssetSectionView(assetSection: asset)
                        }
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding()
                    }
                }
                
            }
            ```
            
    - AssetView에 추가
        
        ```swift
        AssetSummaryView()
            .environmentObject(AssetSummaryData())
        ```
        
    - 자산 리스트 내부에 TabMenu 추가
        - 헤더 뷰 구현: 빨간 색 점으로 업데이트 여부 표시
            
            ```swift
            struct TabMenuView: View {
                
                var tabs: [String]
                
                @Binding var selectedTab: Int
                @Binding var updated: CreditCardAmounts? // 업데이트 값이 있다면 빨간 점으로 표현
                
                var body: some View {
                    HStack {
                        ForEach(0..<tabs.count, id: \.self) { row in
                            Button(
                                action: {
                                   selectedTab = row
                                    UserDefaults.standard.set(true, forKey: "creditcard_update_checked: \(row)")
                                },
                                label: {
                                    VStack(spacing: 0) {
                                        HStack {
                                            if updated?.id == row { // 업데이트가 돼서 빨간점이 표현되어야 함
                                                let checked = UserDefaults.standard.bool(forKey: "creditcard_update_checked: \(row)")
                                                Circle()
                                                    .fill(
                                                        !checked
                                                        ? Color.red
                                                        : Color.clear
                                                    )
                                                    .frame(width: 6, height: 6)
                                                    .offset(x: 2, y: -8)
                                            } else {
                                                Circle()
                                                    .fill(Color.clear)
                                                    .frame(width: 6, height: 6)
                                                    .offset(x: 2, y: -8)
                                            }
                                            
                                            Text(tabs[row])
                                                .font(.system(.headline))
                                                .foregroundColor(
                                                    selectedTab == row
                                                    ? .accentColor
                                                    : .gray
                                                )
                                                .offset(x: -4, y: 0)
                                        }
                                        .frame(height: 52)
                                        
                                        Rectangle()
                                            .fill(
                                                selectedTab == row
                                                ? Color.secondary
                                                : Color.clear
                                            )
                                            .frame(height: 3)
                                            .offset(x: 4, y: 0)
                                    }
                                }
                            )
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .frame(height: 55)
                }
                
            }
            ```
            
        - 섹션 뷰 구현: 헤더 뷰 액션에 따라 뷰와 데이터가 달라짐
            
            ```swift
            struct AssetCardSectionView: View {
                
                @State private var selectedTab = 1
                @ObservedObject var asset: Asset
                
                var assetData: [AssetData] {
                    return asset.data
                }
                
                var body: some View {
                    VStack {
                        AssetSectionHeaderView(title: asset.type.title)
                        TabMenuView(tabs: ["지난달 결제", "이번달 결제", "다음달 결제"], selectedTab: $selectedTab, updated: .constant(.nextMonth(amount: "10,000")))
                        TabView(selection: $selectedTab) {
                            ForEach(0...2, id: \.self) { i in
                                VStack {
                                    ForEach(assetData) { data in
                                        HStack {
                                            Text(data.title)
                                                .font(.title)
                                                .foregroundColor(.secondary)
                                            Spacer()
                                            Text(data.creditCardAmounts![i].amount)
                                                .font(.title2)
                                                .foregroundColor(.primary)
                                        }
                                        Divider()
                                    }
                                }
                                .tag(1)
                            }
                        }
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    }
                    .padding()
                }
                
            }
            ``` 

