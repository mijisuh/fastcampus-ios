//
//  RoundButton.swift
//  Calculator
//
//  Created by mijisuh on 2024/02/20.
//

import UIKit

@IBDesignable // 변경사항을 스토리보드에서 실시간으로 확인 가능
class RoundButton: UIButton {
    
    @IBInspectable var isRound: Bool = false { // 스토리보드에서 isRound 값 변경 가능
        didSet {
            if isRound {
                self.layer.cornerRadius = self.frame.height / 2 // 정사각형 버튼 -> 원 / 아니면 테두리가 둥글어짐
            }
        }
    }

}
