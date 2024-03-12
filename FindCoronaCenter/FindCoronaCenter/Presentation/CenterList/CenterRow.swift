//
//  CenterRow.swift
//  FindCoronaCenter
//
//  Created by mijisuh on 2024/03/12.
//

import SwiftUI

struct CenterRow: View {
    
    var center: Center
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(center.facilityName)
                    .font(.headline)
                Text(center.centerType.rawValue)
                    .font(.caption)
                    .foregroundColor(.gray)
                Spacer()
            }
            Text(center.address)
                .font(.footnote)
            
            if let url = URL(string: "tel:" + center.phoneNumber) { // 전화번호가 있으면 클릭시 전화 연결 가능하도록 구현
                Link(center.phoneNumber, destination: url)
            }
        }
        .padding()
    }
    
}

struct CenterRow_Previews: PreviewProvider {
    
    static var previews: some View {
        let center0 = Center(id: 0, sido: .경기도, facilityName: "실내방상장 앞", address: "경기도 뫄뫄시 뫄뫄구", lat: "37.404476", lng: "126.9491998", centerType: .central, phoneNumber: "010-0000-0000")
        CenterRow(center: center0)
    }
    
}
