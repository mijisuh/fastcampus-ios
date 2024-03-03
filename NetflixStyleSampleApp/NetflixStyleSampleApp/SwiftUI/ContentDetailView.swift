//
//  ContentDetailView.swift
//  NetflixStyleSampleApp
//
//  Created by mijisuh on 2024/03/03.
//

import SwiftUI

struct ContentDetailView: View {
    
    // 프로퍼티 랩퍼: 외부 작업없이 내부 상태가 어떻게 변화할 것인지 표시
    @State var item: Item?
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                ZStack(alignment: .bottom) {
                    if let item = item {
                        Image(uiImage: item.image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 200)
                        
                        Text(item.description)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.center)
                            .padding()
                            .foregroundColor(.primary)
                            .background(Color.primary
                                .colorInvert()
                                .opacity(0.75))
                        
                    } else {
                        Color.white
                    }
                }
            }
        }
    }
}

struct ContentDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let item0 = Item(description: "흥미진진, 판타지, 애니메이션, 액션, 멀티캐스팅", imageName: "poster0")
        ContentDetailView(item: item0)
    }
}
