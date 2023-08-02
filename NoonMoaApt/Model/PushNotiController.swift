


//
//  PushNotiController.swift
//  NoonMoaApt
//
//  Created by kimpepe on 2023/07/23.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseAuth

class PushNotiController: ObservableObject {
    
    private var firestoreManager: FirestoreManager {
        FirestoreManager.shared
    }
    private var db: Firestore {
        firestoreManager.db
    }
    
    // 푸시 알림 보내는 함수
    func sendPushNotification(userToken: String, title: String, content: String) {
        let urlString = "https://fcm.googleapis.com/fcm/send"
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=AAAA_nxyT6c:APA91bFQrkDDCbaIzES896BwaUVRvM3F2u-Dy9cuCscPlT1EQjcJUU2hYx5fyzdqlP4SqmVKjOwz0O7220y5bL8gsWzWrik23_IrDf9Nh4Kw4wKD4vQ5ak3zMvPeCHc995MCGJaevAY0", forHTTPHeaderField: "Authorization") // Firebase 콘솔에서 본인의 서버 키로 변경
        
        let notification: [String: Any] = [
            "to": userToken,
            "notification": [
                "title": title,
                "content": content
            ]
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: notification)
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error sending push notification:", error)
            } else if let data = data, let response = response as? HTTPURLResponse {
                if response.statusCode == 200 {
                    print("Successfully sent push notification.")
                } else {
                    print("Error sending push notification. Status code:", response.statusCode)
                }
            }
        }
        task.resume()
    }
    

    func requestPushNotification(to targetUserId: String) {
        guard let currentUser = Auth.auth().currentUser else {
            print("No current user")
            return
        }

        let targetUserRef = db.collection("User").document(targetUserId)
        targetUserRef.addSnapshotListener { (doc, err) in
            if let doc = doc, doc.exists, let data = doc.data() {
                if let targetUser = User(dictionary: data) {
                    print("targetUser.token: \(targetUser.token)")
                    print("targetUserId: \(targetUserId)")
                    print("targetUser.userState: \(targetUser.userState)")
                    
                    // Check if the target user is not in 'Clicked' state
                    if targetUser.clicked == false {
                        
                        print("targetUser.clicked: \(targetUser.clicked)")
                        
                        // Update currentUser's 'requestedBy' list in Firebase
                        self.db.collection("User").document(targetUserId).updateData([
                            "requestedBy": FieldValue.arrayUnion([currentUser.uid])
                        ])
                        
                        // After updating 'requestedBy', change clicked  to 'true'
                        self.db.collection("User").document(targetUserId).updateData([
                            "clicked": true])
                        
                        // Send push notification to targetUser
                        self.sendPushNotification(userToken: targetUser.token, title: "이웃 : 똑똑똑, 살아계시죠?!", content: "")
                        
                    } else {
                        // If targetUser is in 'Clicked' state, just update currentUser's 'requestedBy' list
                        // But don't send the push notification
                        print("else")
                        self.db.collection("User").document(targetUserId).updateData([
                            "requestedBy": FieldValue.arrayUnion([currentUser.uid])
                        ])
                    }
                    
                } else {
                    print("Error decoding target user")
                }
            } else {
                print("Error getting target user:", err)
            }
        }
    }



    func responsePushNotification() {
        guard let currentUser = Auth.auth().currentUser else {
            print("No current user")
            return
        }

        let currentUserRef = db.collection("User").document(currentUser.uid)
        currentUserRef.getDocument { (doc, err) in
            if let doc = doc, doc.exists, let data = doc.data() {
                if let user = User(dictionary: data) {
                    // Send push notifications to all users who requested the user
                    for userId in user.requestedBy {
                        let userRef = self.db.collection("User").document(userId)
                        userRef.getDocument { (doc, err) in
                            if let doc = doc, doc.exists, let data = doc.data(), let userToken = data["token"] as? String {
                                self.sendPushNotification(userToken: userToken, title: "내가 깨운 이웃이 일어났어요.", content: "지금 바로 반갑게 맞이해주세요!")
                            }
                        }
                    }
                } else {
                    print("Error decoding current user")
                }
            } else {
                print("Error getting current user:", err)
            }
            
            // init
            self.db.collection("User").document(currentUser.uid).updateData([
                "requestedBy": []
            ])
        }
    }

}
