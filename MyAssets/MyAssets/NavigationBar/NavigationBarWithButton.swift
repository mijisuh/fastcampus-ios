//
//  NavigationBarWithButton.swift
//  MyAssets
//
//  Created by mijisuh on 2024/03/03.
//

import SwiftUI

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
                .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black) // 내부를 채우지 않고 테두리만 보여줌
                )
            )
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                let appearance = UINavigationBarAppearance()
                appearance.configureWithOpaqueBackground() // 투명한 배경
                appearance.backgroundColor = UIColor(white: 1, alpha: 0.6) // 반투명
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

struct NavigationBarWithButton_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            Color.gray.edgesIgnoringSafeArea(.all)
                .navigationBarWithButtonStyle("내 자산")
        }
    }
}
