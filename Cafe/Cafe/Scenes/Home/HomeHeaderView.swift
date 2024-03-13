//
//  HomeHeaderView.swift
//  Cafe
//
//  Created by mijisuh on 2024/03/13.
//

import SwiftUI

struct HomeHeaderView: View {
    @Binding var isNeedToReload: Bool
    
    var body: some View {
        VStack(spacing: 16.0) {
            HStack(alignment: .top) {
                Text("""
                    \(User.shared.username)님~
                    반갑습니다! ☕️
                    """)
                    .font(.largeTitle)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .fixedSize(horizontal: false, vertical: true) // 세로 사이즈 고정(ScrollView의 영향X)
                Button(action: {
                    isNeedToReload = true
                }) {
                    Image(systemName: "arrow.2.circlepath")
                }
//                .frame(alignment: .top)
            }
            
            HStack {
                Button(action: {}) {
                    HStack {
                        Image(systemName: "mail")
                            .foregroundColor(.secondary) // accentColor 무효화
                        Text("What's New")
                            .foregroundColor(.primary)
                            .font(.system(size: 16.0, weight: .semibold, design: .default))
                    }
                }
                Button(action: {}) {
                    HStack {
                        Image(systemName: "ticket")
                            .foregroundColor(.secondary)
                        Text("Coupon")
                            .foregroundColor(.primary)
                            .font(.system(size: 16.0, weight: .semibold, design: .default))
                    }
                }
                
                Spacer()
                
                Button(action: {}) {
                    Image(systemName: "bell")
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(16.0)
    }
}

//struct HomeHeaderView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeHeaderView()
//    }
//}
