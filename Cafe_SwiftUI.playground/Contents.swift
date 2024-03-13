import UIKit

// MARK: UITabBarController vs TabView
// UITabBarController
// 2개의 UIViewController, 2개의 TabBar
final class FirstViewController: UIViewController {}
final class SecondViewController: UIViewController {}

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let firstViewController = FirstViewController()
        firstViewController.tabBarItem = UITabBarItem(
            title: "First",
            image: UIImage(systemName: "person"),
            tag: 0
        )
        
        let secondViewController = SecondViewController()
        secondViewController.tabBarItem = UITabBarItem(
            title: "Second",
            image: UIImage(systemName: "person"),
            tag: 0
        )
        
        viewControllers = [firstViewController, secondViewController]
    }
}

import SwiftUI

struct FirstView: View {
    var body: some View {
        Text("First Tab")
    }
}

struct SecondView: View {
    var body: some View {
        Text("Second Tab")
    }
}

struct SampleTabView: View { // View 프로토콜을 따르지만
    var body: some View { // body에서 리턴해주는 타입에 따라서 어떤 뷰 타입인지 결정
        TabView {
            FirstView()
                .tabItem {
                    Image(systemName: "person")
                    Text("First")
                }
            SecondView()
                .tabItem {
                    Image(systemName: "person")
                    Text("Second")
                }
        }
    }
}

// MARK: HStack vs LazyHStack vs List
// HStack
struct SampleHStack: View {
    var body: some View {
        ScrollView(.horizontal) {
            HStack { // 개별 컴포넌트의 개수는 10개까지 가능
                Text("HStack 알아보기")
                Text("HStack 알아보기")
                Text("HStack 알아보기")
                Text("HStack 알아보기")
                Text("HStack 알아보기")
                Text("HStack 알아보기")
                Text("HStack 알아보기")
                Text("HStack 알아보기")
                Text("HStack 알아보기")
                Text("HStack 알아보기")
            }
        }
    }
}

// LaztHStack
struct SampleLazyHStack: View {
    // ForEach에서 받는 배열은 Identifiable 프로토콜을 따라야 함(Identifiable의 ID로 각 셀을 구분해야 하기 때문에)
    struct Number: Identifiable {
        let value: Int
        var id: Int { value }
    }
    
    let numbers: [Number] = (0...100).map { Number(value: $0) }
    
    var body: some View {
        ScrollView(.horizontal) {
//            LazyHStack {
//                ForEach(numbers) { number in
//                    Text("\(number.value)")
//                }
//            }
            
            LazyHGrid(rows: [ // 행의 개수 설정
                GridItem(.fixed(20)),
                GridItem(.fixed(20))
            ]) {
                ForEach(numbers) { number in
                    Text("\(number.value)")
                }
            }
        }
    }
}

// List
struct SampleList: View {
    struct Number: Identifiable {
        let value: Int
        var id: Int { value }
    }
    
    let numbers: [Number] = (0...100).map { Number(value: $0) }
    
    var body: some View {
        List {
            Section(header: Text("Header")) {
                ForEach(numbers) { number in
                    Text("\(number.value)")
                }
            }
            Section(header: Text("Header"), footer: Text("Footer")) {
                ForEach(numbers) { number in
                    Text("\(number.value)")
                }
            }
        }
    }
}

struct Sample_Previews: PreviewProvider {
    static var previews: some View {
        SampleHStack()
        SampleLazyHStack()
        SampleList()
    }
}

// MARK: UINavigationController vs NavigationView
// UINavigationController = UIKit
let navigationController = UINavigationController(rootViewController: SampleViewController())

final class SampleViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Title"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "house.fill"),
            style: .plain,
            target: self,
            action: #selector(didTapRightBarButton)
        )
    }
    
    @objc private func didTapRightBarButton() {
        navigationController?.pushViewController(UIViewController(), animated: true)
    }
}

// NavigationView = SwiftUI
struct SampleView: View {
    var body: some View {
        Text("Sample")
    }
}
struct SampleNavigationView: View {
    var body: some View {
        NavigationView {
            NavigationLink("Push Button", destination: SampleView())
            Text("NavigaionView")
                .navigationTitle("Title")
                .navigationBarItems(
                    trailing: Button(action: {}) {
                        Image(systemName: "house.fil")
                    }
                )
        }
    }
}

// MARK: @State, @Binding, @ObservedObject
class ButtonModel: ObservableObject {
    @Published var isDisabled = true
}

struct ParentView: View {
//    @State private var isDisabled = true
    @ObservedObject var buttonModel = ButtonModel()
    
    var body: some View {
//        ChildView(isDisabled: $isDisabled)
        ChildView(isDisabled: $buttonModel.isDisabled)
    }
}

struct ChildView: View {
    @State private var currentText = ""
    @Binding var isDisabled: Bool
    
    var body: some View {
        VStack {
            TextField("텍스트를 입력해주세요.", text: $currentText) // 값을 바인딩시키는 경우 꼭 $ 표시
            Text(currentText)
            
            Toggle(isOn: $isDisabled) {
                Text("버튼을 활성화 시키겠습니까?")
            }
            
            Button("버튼") {}
                .disabled(isDisabled)
        }
    }
}
