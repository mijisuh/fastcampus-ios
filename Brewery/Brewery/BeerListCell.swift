//
//  BeerListCell.swift
//  Brewery
//
//  Created by mijisuh on 2024/03/02.
//

import UIKit
import SnapKit
import Kingfisher

class BeerListCell: UITableViewCell {
    
    let beerImageView = UIImageView()
    let nameLabel = UILabel()
    let taglineLabel = UILabel()

    override func layoutSubviews() {
        super.layoutSubviews()
        
        [beerImageView, nameLabel, taglineLabel].forEach {
            self.contentView.addSubview($0)
        }
        
        self.beerImageView.contentMode = .scaleAspectFit
        
        self.nameLabel.font = .systemFont(ofSize: 18, weight: .bold)
        self.nameLabel.numberOfLines = 2
        
        self.taglineLabel.font = .systemFont(ofSize: 14, weight: .light)
        self.taglineLabel.textColor = .systemBlue
        self.taglineLabel.numberOfLines = 0
        
        self.beerImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.top.equalToSuperview().inset(20)
            $0.width.equalTo(80)
            $0.height.equalTo(120)
        }
        
        self.nameLabel.snp.makeConstraints {
            $0.leading.equalTo(self.beerImageView.snp.trailing).offset(10)
            $0.bottom.equalTo(self.beerImageView.snp.centerY)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        self.taglineLabel.snp.makeConstraints {
            $0.leading.trailing.equalTo(self.nameLabel)
            $0.top.equalTo(self.nameLabel.snp.bottom).offset(5)
        }
    }
    
    // 외부에서 셀에 접근하여 UI 컴포넌트와 데이터 연결해서 화면에 뿌려줌
    func configure(with beer: Beer) {
        let imageURL = URL(string: beer.imageURL ?? "")
        self.beerImageView.kf.setImage(with: imageURL, placeholder: #imageLiteral(resourceName: "beer_icon"))
        self.nameLabel.text = beer.name ?? "이름 없는 맥주"
        self.taglineLabel.text = beer.tagLine
        
        self.accessoryType = .disclosureIndicator // 셀의 우측에 > 모양의 UI 생성
        self.selectionStyle = .none // 셀을 탭하더라도 회색 음영 발생 X
    }
    
}
