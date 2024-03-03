//
//  ContentView.swift
//  NetflixStyleSampleApp
//
//  Created by mijisuh on 2024/03/03.
//

import SwiftUI

struct ContentView: View {
    let titles = ["Netflix Sample App"]
    var body: some View {
        // 네비게이션 바를 가지는 리스트
        NavigationView {
            List(titles, id: \.self) {
                let netflixVC = HomeViewControllerRepresentable()
                    .navigationBarHidden(true)
                    .edgesIgnoringSafeArea(.all)
                NavigationLink($0, destination: netflixVC) // present, show
            }
            .navigationTitle("SwiftUI to UIKit")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
