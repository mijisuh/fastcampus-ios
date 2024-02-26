//
//  CardListViewController.swift
//  CreditCardList
//
//  Created by mijisuh on 2024/02/26.
//

import UIKit
import Kingfisher
import FirebaseDatabase
import FirebaseFirestore

class CardListViewController: UITableViewController {
//    var ref: DatabaseReference! // Firebase Realtime Database
    var db = Firestore.firestore()
    
    var creditCardList: [CreditCard] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UITableView Cell Register
        let nibNAme = UINib(nibName: "CardListCell", bundle: nil)
        self.tableView.register(nibNAme, forCellReuseIdentifier: "CardListCell")
        
        self.configureFirebase()
    }
    
    private func configureFirebase() {
        // Realtime Database 읽기
//        self.ref = Database.database().reference() // 데이터 흐름을 주고 받을 수 있음
//
//        self.ref.observe(.value) { snapshot in // 레퍼런스가 value 값을 바라보는데 snapshot 제공
//            guard let value = snapshot.value as? [String: [String: Any]] else { return } // 저장된 데이터 형태에 따라 다름
//
//            do {
//                let jsonData = try JSONSerialization.data(withJSONObject: value)
//                let cardData = try JSONDecoder().decode([String: CreditCard].self, from: jsonData)
//                let cardList = Array(cardData.values)
//                self.creditCardList = cardList.sorted { $0.rank < $1.rank }
//
//                DispatchQueue.main.async {
//                    self.tableView.reloadData()
//                }
//            } catch let error {
//                print("Error JSON Parsing \(error.localizedDescription)")
//            }
//        }
        
        // Firestore 읽기
        db.collection("creditCardList").addSnapshotListener { snapshot, error in // creditCardList라는 document를 바라보게 함
            guard let documents = snapshot?.documents else { // snapshot에 해당 document가 있을 경우에만 실행
                print("ERROR Firestore fetching document \(String(describing: error))")
                return
            }
            
            self.creditCardList = documents.compactMap { doc -> CreditCard? in
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: doc.data())
                    let creditCard = try JSONDecoder().decode(CreditCard.self, from: jsonData)
                    return creditCard
                } catch let error {
                    print("ERROR JSON Pasring \(error.localizedDescription)")
                    return nil
                }
            }.sorted { $0.rank < $1.rank }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
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
        
        // Realtime Database 쓰기
        // Option 1
//        let cardID = self.creditCardList[indexPath.row].id
//        self.ref.child("Item\(cardID)/isSelected").setValue(true)
        
        // Option 2
//        self.ref.queryOrdered(byChild: "id").queryEqual(toValue: cardID).observe(.value) { [weak self] snapshot in // cardID와 값이 같으면 가져옴
//            guard let self = self,
//                  let value = snapshot.value as? [String: [String: Any]],
//                  let key = value.keys.first
//            else { return }
//            self.ref.child("\(key)/isSelected").setValue(true)
//        }
        
        // Firestore 쓰기
        let cardID = self.creditCardList[indexPath.row].id
        
        // Option 1
//        db.collection("creditCardList").document("card\(cardID)").updateData(["isSelected": true])
        
        // Option 2
        db.collection("creditCardList").whereField("id", isEqualTo: cardID).getDocuments { snapshot, _ in
            guard let document = snapshot?.documents.first else { // 검색 결과를 배열로 전달
                print("ERROR Firestore fetching document")
                return
            }
            
            document.reference.updateData(["isSelected": true])
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Realtime Database 삭제
            // Option 1
//            let cardId = self.creditCardList[indexPath.row].id
//            self.ref.child("Item\(cardId)").removeValue()
            
            // Option 2
//            self.ref.queryOrdered(byChild: "id").queryEqual(toValue: cardId).observe(.value) { [weak self] snapshot in
//                guard let self = self,
//                      let value = snapshot.value as? [String: [String: Any]],
//                      let key = value.keys.first // snapshot의 value는 배열로 전달되는데 id는 고유한 하나의 값만 가지므로
//                else { return }
//
//                self.ref.child(key).removeValue()
//            }
            
            // Firestore 삭제
            let cardID = self.creditCardList[indexPath.row].id
            
            // Option 1
//            db.collection("creditCardList").document("card\(cardID)").delete()
            
            // Option 2
            db.collection("creditCardList").whereField("id", isEqualTo: cardID).getDocuments { snapshot, _ in
                guard let document = snapshot?.documents.first else {
                    print("ERROR Firestore fetching document")
                    return
                }
                
                document.reference.delete()
            }
        }
    }

}
