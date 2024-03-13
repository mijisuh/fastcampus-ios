# ☕️ 별다방 앱

> SwiftUI를 활용해 스타벅스 스타일의 앱 화면을 구현

![Simulator Screen Recording - iPhone 14 - 2024-03-13 at 19 38 17](https://github.com/mijisuh/fastcampus-ios/assets/57468832/12e7a951-0019-49d6-a3fb-5637606e4642)

## 개념 정리

<details>
<summary>List vs LazyHStack</summary>

- SwiftUI에서 목록을 구현하는 방법 → **Reuse: Cell의 재사용 여부와 정도에 따라 가장 크게 구분됨**
    
    |||
    | --- | --- |
    | H(V)Stack | 초기화 시점에 모든 View을 생성함  |
    | LazyH(V)Stack | 초기화 시점에 모든 Cell을 생성하지 않음<br>최대 index 31까지의 데이터의 Cell(View)을 생성<br>(나머지는 스크롤하면서 보임) |
    | List | 초기화 시점에 모든 Cell을 생성하지 않음<br>UITableView와 비슷함<br>(Cell의 삭제/추가 기능이 있음)<br>보여질 필요가 있는 Cell(View)만 생성 |
    |||
</details>

<details>
<summary>SwiftUI의 상태와 데이터 흐름</summary>

- `@State`: View State
    - String, Int, Bool과 같은 **간단한 값을 저장**하고 **View의 현재 상태를 표시**하기 위해 사용
    - **단순히 화면 표시를 위한 수단**으로 사용
    - 화면 내부에서만 사용하므로 private으로 선언
- `@Binding`
    - **자식 View에서 부모 View의 값을 표시**하고, 능동적으로 값이 변화할 때 사용
    - **자식 View에서 사용**됨
- `@ObservedObject`: Model Update
    - **별도의 모델에 실제 저장되거나 사용되는 데이터**로서 화면과 바인딩 가능
    - 직접적인 데이터에 관한 것
    - 한 화면에 국한되는 것이 아닌 **여러 화면에서도 액세스 가능**
</details>

## 전체 화면 구성

<img width="908" alt="1" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/8cd41e02-1029-4a7e-9306-5ec078c476c7">

## 구현 내용
1. 앱 화면 구현하기
    - TabView
        - Home/Other의 두 개의 Tab을 가짐
        - Tab의 경우 enum으로 정의해서 사용하는 것이 일반적
            - View는 표시만하고 실제 데이터는 enum에서 관리
                
                ```swift
                enum Tab {
                    case home
                    case other
                    
                    // associate value: enum의 변수를 특정한 형태로 바로 return 해줌
                    var textItem: Text {
                        switch self {
                        case .home:
                            return Text("Home")
                        case .other:
                            return Text("Other")
                        }
                    }
                    
                    var imageItem: Image {
                        switch self {
                        case .home:
                            return Image(systemName: "house.fill")
                        case .other:
                            return Image(systemName: "ellipsis")
                        }
                    }
                }
                ```
                
        - tintColor(UIKit) → accentColor(SwiftUI)
    - LazyHStack, List
        
        <img width="908" alt="2" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/7144071b-633d-4c23-acbe-37502cd274df">
        
        - LazyHStack: 배열을 기반으로 데이터를 유연하게 표시할 수 있고 배열을 Reuse하는 뷰로 구현 가능
            
            <img width="872" alt="3" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/507ed6f0-784a-4c57-9e81-4ec1345cea55">
            
        - List: Separator가 자동적으로 구현되어 있고 Section 활용 가능
        - ForEach로 배열 데이터를 불러와서 표시할 때 주의해야 할 사항
            - ForEach에서 받는 배열은 `Identifiable` 프로토콜을 따라야 함(Identifiable의 ID로 각 셀을 구분해야 하기 때문에)
    - HomeView
        
        <img width="872" alt="4" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/da7ce0ac-4243-46bf-a4dc-7df332a89ada">
        
    - OtherView
        
        <img width="806" alt="5" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/affdf7e8-b9ee-4e8b-a247-a9972f7228a8">
        
        - NavigationView
            - `.toolbar`로 이동
                
                ```swift
                NavigationView {
                    List {
                        ForEach(Menu.allCases) { section in
                            Section(header: Text(section.title)) {
                                ForEach(section.menu, id: \.hashValue) { raw in
                                    NavigationLink(raw, destination: Text("\(raw)"))
                                }
                            }
                        }
                    }
                    .listStyle(GroupedListStyle())
                    .navigationTitle("Other")
                    .toolbar {
                        NavigationLink(destination: Text("Destination")) {
                            Image(systemName: "gear")
                        }
                    }
                }
                ```
                
        - enum을 이용해 배열 데이터 생성
            - `CaseIterable`
                
                ```swift
                enum Menu: String, CaseIterable, Identifiable { // 하위 enum도 모두 Identifiable를 따라야 함
                    case service = "서비스"
                    case cs = "고객지원"
                    case terms = "약관 및 정책"
                    
                    var title: String { rawValue }
                    var id: String { rawValue }
                    
                    var menu: [String] {
                        switch self {
                        case .service: return Service.allCases.map { $0.title }
                        case .cs: return CS.allCases.map { $0.title }
                        case .terms: return Terms.allCases.map { $0.title }
                        }
                    }
                    
                    enum Service: String, CaseIterable, Identifiable { // CaseIterable: enum을 배열처럼 사용 가능하게 만드는 프로토콜(Service.allCases)
                        case frequency = "프리퀀시"
                        case reward = "리워드"
                        case coupon = "쿠폰"
                        case giftCard = "e-기프트카드"
                        case new = "What's New"
                        case notification = "알림"
                        case history = "히스토리"
                        case receipt = "전자영수증"
                        case myReview = "마이 스타벅스 리뷰"
                        
                        var title: String { rawValue }
                        var id: String { rawValue }
                    }
                    
                    enum CS: String, CaseIterable, Identifiable {
                        case storeCare = "스토어 케어"
                        case voiceOfCustomer = "고객의 소리"
                        case store = "매장 정보"
                        
                        var title: String { rawValue }
                        var id: String { rawValue }
                    }
                    
                    enum Terms: String, CaseIterable, Identifiable {
                        case terms = "이용약관"
                        case privacyTerms = "개인정보 처리 방침"
                        
                        var title: String { rawValue }
                        var id: String { rawValue }
                    }
                }
                ```
                
    - SettingView
        
        <img width="698" alt="6" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/9f99332b-5896-4164-9a35-c07ddc28ba16">
        
2. Combine을 사용한 데이터 표시하기
    
    <img width="796" alt="7" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/542b3565-7563-4ff4-bbdd-64d7d4689b91">
    
    - HomeView
        
        <img width="867" alt="8" src="https://github.com/mijisuh/fastcampus-ios/assets/57468832/f643e779-479e-4ed6-9cfb-ebd4636f98c9">
        
        - HeaderView에서 RightBarButtonItem이 탭되었을 때 바인딩되어 있는 isNeedToReload를 true로 변경
            
            ```swift
            struct HomeHeaderView: View {
                @Binding var isNeedToReload: Bool
                
                var body: some View {
                    VStack(spacing: 16.0) {
                        HStack(alignment: .top) {
                           ...
                            Button(action: {
                                isNeedToReload = true
                            }) {
                                Image(systemName: "arrow.2.circlepath")
                            }
                        }
                        ...
            }
            ```
            
        - Observed 하고 있는 SuperViewModel에게 array.shuffle() 요청
            
            ```swift
            class HomeViewModel: ObservableObject { // ObservableObject은 class로 정의해야 함
                @Published var isNeedToReload = false {
                    didSet {
                        guard isNeedToReload else { return }
                        coffeeMenu.shuffle()
                        events.shuffle()
                        isNeedToReload = false
                    }
                }
                
                @Published var coffeeMenu: [CoffeeMenu] = [
                    CoffeeMenu(image: Image("coffee"), name: "아메리카노"),
                    CoffeeMenu(image: Image("coffee"), name: "아이스 아메리카노"),
                    CoffeeMenu(image: Image("coffee"), name: "카페라떼"),
                    CoffeeMenu(image: Image("coffee"), name: "아이스 카페라떼"),
                    CoffeeMenu(image: Image("coffee"), name: "드립커피"),
                    CoffeeMenu(image: Image("coffee"), name: "아이스 드립커피"),
                ]
                
                @Published var events: [Event] = [
                    Event(image: Image("coffee"), title: "제주도 한정 메뉴", description: "제주도 한정 음료가 출시되었습니다! 꼭 드셔보세요."),
                    Event(image: Image("coffee"), title: "여름 한정 메뉴", description: "여름이니까 아이스 커피 ~")
                ]
            }
            ```
            
        - SuperViewModel와 바인딩되어 있는 자식 뷰의 array도 업데이트
            
            ```swift
            struct HomeView: View {
                @ObservedObject var viewModel = HomeViewModel()
                
                var body: some View {
                    ScrollView(.vertical) {
                        HomeHeaderView(isNeedToReload: $viewModel.isNeedToReload)
                        MenuSuggestionSectionView(coffeeMenu: $viewModel.coffeeMenu)
                        Spacer(minLength: 32.0) // 최소 마진
                        EventSectionView(events: $viewModel.events)
                    }
                }
            }
            ```
            
        - array가 업데이트됨에 따라 화면도 업데이트
            
            ```swift
            struct MenuSuggestionSectionView: View {
                @Binding var coffeeMenu: [CoffeeMenu]
                var body: some View {
                    VStack {
                        ...
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack {
                                ForEach(coffeeMenu) { menu in
                                    MenuSuggestionItemView(coffeeMenu: menu)
                                }
                            }
                            .padding(.horizontal, 16.0)
                        }
                    }
                }
            }
            ```

