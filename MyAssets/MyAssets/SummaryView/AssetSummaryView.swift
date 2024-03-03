//
//  AssetSummaryView.swift
//  MyAssets
//
//  Created by mijisuh on 2024/03/03.
//

import SwiftUI

struct AssetSummaryView: View {
    
    @EnvironmentObject var assetData: AssetSummaryData // 외부에서 데이터를 받아서 전체 상태를 변경시키고 표현
    
    var assets: [Asset] {
        return assetData.assets
    }
    
    var body: some View {
        VStack(spacing: 20) {
            ForEach(assets) { asset in
                switch asset.type {
                case .creditCard:
                    AssetCardSectionView(asset: asset)
                        .frame(idealHeight: 250)
                default:
                    AssetSectionView(assetSection: asset)
                }
            }
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding()
        }
    }
    
}

struct AssetSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        AssetSummaryView()
            .environmentObject(AssetSummaryData())
            .background(.gray.opacity(0.2))
    }
}
