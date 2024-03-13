//
//  SettingView.swift
//  Cafe
//
//  Created by mijisuh on 2024/03/13.
//

import SwiftUI

struct SettingView: View {
    var body: some View {
        List {
            Section {
                SettingUserInfoSectionView()
            }
            
            Button("회원 정보 수정") { }
                    .foregroundColor(.primary)
            Button("회원 탈퇴") { }
                    .foregroundColor(.primary)
        }
        .listStyle(GroupedListStyle())
        .navigationTitle("설정")
        .navigationBarTitleDisplayMode(.inline) // default는 .automatic(.inline과 .large 혼재)
    }
}

struct SettingUserInfoSectionView: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4.0) {
                Text(User.shared.username)
                    .font(.title)
                Text(User.shared.account)
                    .font(.caption)
            }
            Spacer()
            Button(action: {}) {
                Text("로그아웃")
                    .font(.system(size: 14.0, weight: .bold, design: .default))
            }
            .padding(8.0) // 순서 중요
            .overlay(Capsule().stroke(.green))
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
