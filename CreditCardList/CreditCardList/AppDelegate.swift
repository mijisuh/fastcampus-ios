//
//  AppDelegate.swift
//  CreditCardList
//
//  Created by mijisuh on 2024/02/26.
//

import UIKit
import Firebase
import FirebaseFirestore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        let db = Firestore.firestore() // 파이어스토어 db 선언
        
        db.collection("creditCardList").getDocuments { snapshot, _ in // "creditCardList" 컬렉션 생성
            guard snapshot?.isEmpty == true else { return } // 스냅샷이 비어있을 경우(db에 아무것도 없는 경우)에만 실행
            
            let batch = db.batch()
            let card0Ref = db.collection("creditCardList").document("card0")
            let card1Ref = db.collection("creditCardList").document("card1")
            let card2Ref = db.collection("creditCardList").document("card2")
            let card3Ref = db.collection("creditCardList").document("card3")
            let card4Ref = db.collection("creditCardList").document("card4")
            let card5Ref = db.collection("creditCardList").document("card5")
            let card6Ref = db.collection("creditCardList").document("card6")
            let card7Ref = db.collection("creditCardList").document("card7")
            let card8Ref = db.collection("creditCardList").document("card8")
            let card9Ref = db.collection("creditCardList").document("card9")
            
            do {
                try batch.setData(from: CreditCardDummy.card0, forDocument: card0Ref) // 경로를 지정해 데이터 쓰기
                try batch.setData(from: CreditCardDummy.card1, forDocument: card1Ref)
                try batch.setData(from: CreditCardDummy.card2, forDocument: card2Ref)
                try batch.setData(from: CreditCardDummy.card3, forDocument: card3Ref)
                try batch.setData(from: CreditCardDummy.card4, forDocument: card4Ref)
                try batch.setData(from: CreditCardDummy.card5, forDocument: card5Ref)
                try batch.setData(from: CreditCardDummy.card6, forDocument: card6Ref)
                try batch.setData(from: CreditCardDummy.card7, forDocument: card7Ref)
                try batch.setData(from: CreditCardDummy.card8, forDocument: card8Ref)
                try batch.setData(from: CreditCardDummy.card9, forDocument: card9Ref)
            } catch let error {
                print("ERROR writing card to Firestore \(error.localizedDescription)")
            }
            
            batch.commit() // 반드시 커밋을 해줘야 업데이트에 반영이 됨
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

