//
//  SelectRegionItem.swift
//  FindCoronaCenter
//
//  Created by mijisuh on 2024/03/12.
//

import SwiftUI

struct SelectRegionItem: View {
    
    var region: Center.Sido
    var count: Int
    var body: some View {
        ZStack {
            Color(white: 0.9) // 배경색
            VStack {
                Text(region.rawValue)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.init(uiColor: .darkGray))
                Text("(\(count))")
                    .font(.callout)
                    .fontWeight(.light)
                    .foregroundColor(.gray)
            }
            .padding()
        }
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    
}

struct SelectRegionItem_Previews: PreviewProvider {
    
    static var previews: some View {
        let region = Center.Sido.강원도
        SelectRegionItem(region: region, count: 3)
    }
    
}
