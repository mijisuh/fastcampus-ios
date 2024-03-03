//
//  MyView.swift
//  SwiftUIPractice
//
//  Created by mijisuh on 2024/03/03.
//

import SwiftUI

struct MyView: View { // View 프로토콜을 준수(SwiftUI가 화면에 그리는 요소의 동작을 나타냄)
    
    var greetinFont: Font?
    
    init(greetinFont: Font) {
        self.greetinFont = greetinFont
        // 입력 값이 변경되면 SwiftUI는 변경사항을 감지해서 인터페이스에 영향을 받는 부분만 다시 그림
        // 시스템은 언제든지 다시 뷰를 초기화할 수 있기 때문에 뷰의 초기화 코드에 중요한 작업을 수행하지 않는 것이 좋음
    }
    
    var body: some View { // View 프로토콜 필수 요구 사항 정의
        // View를 업데이트해야 할 때마다 이 body 속성의 값을 읽게 됨
        // 업데이트는 사용자의 입력, 시스템 이벤트에 대한 응답으로 뷰 수명동안 반복적으로 발생 가능
        // 뷰가 반환하는 값은 SwiftUI가 그리는 요소
        // some View: body의 속성이 View를 준수하고 있음을 나타냄(정확히 어떤 유형일 지는 body의 내용에 따라 달라짐
        // 즉 SwiftUI는 정확한 유형을 명시적으로 표현하지 않고 프레임워크 단에서 자동으로 추론하기 위해 some View라고 표현
        VStack {
            // 여러 서브 뷰를 사용하는 뷰는 일반적으로 ViewBuilder 속성으로 표시된 클로저를 사용해 그 내부에 나열해서 나타냄
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                .font(.title) // Modifier
                // body에서 뷰를 구성하려면 ViewModifier를 이용해 적용 가능
                // 모디파이어는 특정 뷰에서 호출되는 메서드라고 생각 ->  뷰 계층 구조에서 기본의 뷰를 대체하여 변경된 새 뷰를 반환
                // SwiftUI는 이러한 목적을 위해서 많은 메서드 세트로 View 프로토콜을 확장 View 프로토콜을 준수하는 모든 요소들은 어떤 방식으로든 뷰의 동작을 변경하는 이러한 메서드에 액세스 가능
            Text("만나서 반가워요")
                .font(greetinFont)
        }
    }
}

struct MyView_Previews: PreviewProvider {
    static var previews: some View {
        MyView(greetinFont: .body)
    }
}

// 커스텀 뷰도 다른 기본 뷰와 마찬가지로 다른 뷰에 통합 가능
