//
//  AssetMenuButtonStyle.swift
//  MyAssets
//
//  Created by mijisuh on 2024/03/03.
//

import SwiftUI

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

struct AssetMenuButtonStyle_Previews: PreviewProvider {
    
    static var previews: some View {
        HStack(spacing: 24) {
            Button("") {
                print("")
            }
            .buttonStyle(AssetMenuButtonStyle(menu: .creditScore))
            Button("") {
                print("")
            }
            .buttonStyle(AssetMenuButtonStyle(menu: .bankAccount))
            Button("") {
                print("")
            }
            .buttonStyle(AssetMenuButtonStyle(menu: .creditCard))
            Button("") {
                print("")
            }
            .buttonStyle(AssetMenuButtonStyle(menu: .cash))
        }
        .background(.gray.opacity(0.2))
    }
    
}
