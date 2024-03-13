//
//  EventSectionView.swift
//  Cafe
//
//  Created by mijisuh on 2024/03/13.
//

import SwiftUI

struct EventSectionView: View {
    @Binding var events: [Event]
    
    var body: some View {
        VStack {
            HStack {
                Text("Events")
                    .font(.headline)
                    .foregroundColor(.primary)
                Spacer()
                Button(action: {}) {
                    Text("See all")
                        .font(.subheadline)
                }
            }
            .padding(.horizontal, 16.0)
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 16) {
                    ForEach(events) { event in
                        EventSectionItemView(event: event)
                    }
                }
                .frame(maxWidth: .infinity, minHeight: 220, maxHeight: .infinity) // ScrollView 안에서 잘리지 않도록 설정
                .padding(.horizontal, 16.0)
            }
        }
    }
}

struct EventSectionItemView: View {
    let event: Event
    
    var body: some View {
        VStack {
            event.image
                .resizable()
                .scaledToFill()
                .frame(height: 150.0)
                .clipped() // 이미지를 자름
            Text(event.title)
                .frame(maxWidth: .infinity, alignment: .leading) // maxWidth: width의 최대값을 이미지에 맞춤
                .font(.headline)
            Text(event.description)
                .lineLimit(1)
                .font(.callout)
                .frame(maxWidth: .infinity, alignment: .topLeading)
        }
        .frame(width: UIScreen.main.bounds.width - 32.0)
    }
}

//struct EventSectionView_Previews: PreviewProvider {
//    static var previews: some View {
//        EventSectionView()
//    }
//}
