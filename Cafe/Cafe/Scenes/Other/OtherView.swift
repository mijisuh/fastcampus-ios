//
//  OtherView.swift
//  Cafe
//
//  Created by mijisuh on 2024/03/13.
//

import SwiftUI

struct OtherView: View {
    init() {
        // List가 UITableView(UIKit)에 종속되어 있음
        // static 프로퍼티이므로 다른 곳에서 또 작성할 필요 X
        UITableView.appearance().backgroundColor = .systemBackground // 바뀌는게 없음
    }
    
    var body: some View {
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
                NavigationLink(destination: SettingView()) {
                    Image(systemName: "gear")
                }
            }
        }
    }
}

struct OtherView_Previews: PreviewProvider {
    static var previews: some View {
        OtherView()
    }
}
