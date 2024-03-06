//
//  StationDetailCollectionViewCell.swift
//  SubwayStation
//
//  Created by mijisuh on 2024/03/05.
//

import UIKit
import SnapKit

final class StationDetailCollectionViewCell: UICollectionViewCell {
    
    private lazy var lineLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .bold)
        return label
    }()
    
    private lazy var remainTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .medium)
        return label
    }()
    
    func setup(with realtimeArrival: StationArrivalDataResponseModel.RealTimeArrival) {
        layer.cornerRadius = 12
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 5
        
        backgroundColor = .systemBackground
        
        [lineLabel,remainTimeLabel].forEach { addSubview($0) }
        
        lineLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.top.equalToSuperview().inset(16)
        }
        
        remainTimeLabel.snp.makeConstraints {
            $0.leading.equalTo(lineLabel.snp.leading)
            $0.top.equalTo(lineLabel.snp.bottom).offset(16)
            $0.bottom.equalToSuperview().inset(16)
        }
        
        lineLabel.text = realtimeArrival.line
        remainTimeLabel.text = realtimeArrival.remainTime
    }
    
}
