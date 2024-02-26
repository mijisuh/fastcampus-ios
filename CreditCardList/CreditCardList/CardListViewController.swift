//
//  CardListViewController.swift
//  CreditCardList
//
//  Created by mijisuh on 2024/02/26.
//

import UIKit
import Kingfisher
import FirebaseDatabase

class CardListViewController: UITableViewController {
    var ref: DatabaseReference! // Firebase Realtime Database
    
    var creditCardList: [CreditCard] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UITableView Cell Register
        let nibNAme = UINib(nibName: "CardListCell", bundle: nil)
        self.tableView.register(nibNAme, forCellReuseIdentifier: "CardListCell")
        
        self.configureFirebase()
    }
    
    private func configureFirebase() {
        self.ref = Database.database().reference() // 데이터 흐름을 주고 받을 수 있음
        
        self.ref.observe(.value) { snapshot in // 레퍼런스가 value 값을 바라보는데 snapshot 제공
            guard let value = snapshot.value as? [String: [String: Any]] else { return } // 저장된 데이터 형태에 따라 다름
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: value)
                let cardData = try JSONDecoder().decode([String: CreditCard].self, from: jsonData)
                let cardList = Array(cardData.values)
                self.creditCardList = cardList.sorted { $0.rank < $1.rank }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch let error {
                print("Error JSON parsing \(error.localizedDescription)")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return creditCardList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "CardListCell", for: indexPath) as? CardListCell else { return UITableViewCell() }
        cell.rankLabel.text = "\(creditCardList[indexPath.row].rank)위"
        cell.promotionLabel.text = "\(creditCardList[indexPath.row].promotionDetail.amount)만원 증정"
        cell.cardNameLabel.text = "\(creditCardList[indexPath.row].name)"
        
        let imageURL = URL(string: creditCardList[indexPath.row].cardImageURL)
        cell.cardImageView.kf.setImage(with: imageURL)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 상세 화면 전달
        guard let cardDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "CardDetailViewController") as? CardDetailViewController else { return }
        cardDetailViewController.promotionDetail = self.creditCardList[indexPath.row].promotionDetail
        self.show(cardDetailViewController, sender: nil)
        
        // Option 1
        let cardID = self.creditCardList[indexPath.row].id
        self.ref.child("Item\(cardID)/isSelected").setValue(true)
        
        // Option 2
//        self.ref.queryOrdered(byChild: "id").queryEqual(toValue: cardID).observe(.value) { [weak self] snapshot in // cardID와 값이 같으면 가져옴
//            guard let self = self,
//                  let value = snapshot.value as? [String: [String: Any]],
//                  let key = value.keys.first
//            else { return }
//            self.ref.child("\(key)/isSelected").setValue(true)
//        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Option 1
            let cardId = self.creditCardList[indexPath.row].id
            self.ref.child("Item\(cardId)").removeValue()
            
            // Option 2
            self.ref.queryOrdered(byChild: "id").queryEqual(toValue: cardId).observe(.value) { [weak self] snapshot in
                guard let self = self,
                      let value = snapshot.value as? [String: [String: Any]],
                      let key = value.keys.first // snapshot의 value는 배열로 전달되는데 id는 고유한 하나의 값만 가지므로
                else { return }
                
                self.ref.child(key).removeValue()
            }
        }
    }

}
