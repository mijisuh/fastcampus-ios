//
//  ViewController.swift
//  Calculator
//
//  Created by mijisuh on 2024/02/19.
//

import UIKit

enum Operation {
    case Add
    case Subtract
    case Multiply
    case Divide
    case Unknown
}

class ViewController: UIViewController {

    @IBOutlet weak var numberOutputLabel: UILabel!
    
    var displayNumber = ""
    var firstOperand = "" // 이전 결과 값(1번째 피연산자)
    var secondOperand = "" // 새롭게 입력된 값 저장(2번째 피연산자)
    var result = "" // 계산 결과 값
    var currentOperation: Operation = .Unknown // 현재 계산기에 어떤 연산이 저장되어 있는지
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func tabNumberButton(_ sender: UIButton) {
        guard let numberValue = sender.titleLabel?.text else { return }
        
        if self.displayNumber.count < 9 { // 최대 9자릿수만 입력 가능
            self.displayNumber += numberValue
            self.numberOutputLabel.text = self.displayNumber
        }
    }
    
    @IBAction func tapClearButton(_ sender: UIButton) {
        self.displayNumber = ""
        self.firstOperand = ""
        self.secondOperand = ""
        self.result = ""
        self.currentOperation = .Unknown
        
        self.numberOutputLabel.text = "0"
    }
    
    @IBAction func tapDotButton(_ sender: UIButton) {
        if self.displayNumber.count < 8, !self.displayNumber.contains(".") {
            self.displayNumber += self.displayNumber.isEmpty ? "0." : "."
            self.numberOutputLabel.text = self.displayNumber
        }
    }
    
    @IBAction func tapDivideButton(_ sender: UIButton) {
        self.operation(.Divide)
    }
    
    @IBAction func tapMultiplyButton(_ sender: UIButton) {
        self.operation(.Multiply)
    }
    
    @IBAction func tapSubtractButton(_ sender: UIButton) {
        self.operation(.Subtract)
    }
    
    @IBAction func tapAddButton(_ sender: UIButton) {
        self.operation(.Add)
    }
    
    @IBAction func tapEqualButton(_ sender: UIButton) {
        self.operation(self.currentOperation)
    }
    
    func operation(_ operation: Operation) {
        // 전달 받은 연산자에 따라 계산하고 계산된 값을 표시
        if self.currentOperation != .Unknown {
            if !self.displayNumber.isEmpty {
                self.secondOperand = self.displayNumber
                self.displayNumber = ""
                
                guard let firstOperand = Double(self.firstOperand),
                      let secondOperand = Double(self.secondOperand)
                else { return }
                
                switch currentOperation {
                case .Add:
                    self.result = "\(firstOperand + secondOperand)"
                case .Subtract:
                    self.result = "\(firstOperand - secondOperand)"
                case .Multiply:
                    self.result = "\(firstOperand * secondOperand)"
                case .Divide:
                    self.result = "\(firstOperand / secondOperand)"
                default:
                    break
                }
                
                if let result = Double(self.result), result.truncatingRemainder(dividingBy: 1) == 0 { // 1로 나눴을 때 나머지가 0이면
                    self.result = "\(Int(result))" // 소수점 버림
                }
                
                self.firstOperand = self.result // 누적 연산
                
                self.numberOutputLabel.text = self.result
            }
        } else {
            self.firstOperand = self.displayNumber
            self.displayNumber = "" // 새로운 숫자를 표시하기 위해
        }
        
        self.currentOperation = operation
    }
    
}

