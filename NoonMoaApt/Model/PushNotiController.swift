


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
    
    private var notificationTimestamps: [String: Date] = [:]

    
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
        
        let lastNotificationTimeKey = "\(currentUser.uid)_\(targetUserId)"
        if let lastTime = notificationTimestamps[lastNotificationTimeKey] {
            if Date().timeIntervalSince(lastTime) < 600 {
                print("Cannot send push notification. Wait for 10 minutes.")
                return
            }
        }
        
        let targetUserRef = db.collection("User").document(targetUserId)
        targetUserRef.addSnapshotListener { (doc, err) in
            if let doc = doc, doc.exists, let data = doc.data() {
                if let targetUser = User(dictionary: data) {
                    if targetUser.clicked == false {
                        self.db.collection("User").document(targetUserId).updateData([
                            "requestedBy": FieldValue.arrayUnion([currentUser.uid]),
                            "clicked": true
                        ])
                        
                        self.sendPushNotification(userToken: targetUser.token, title: "Notification", content: "")
                        self.notificationTimestamps[lastNotificationTimeKey] = Date()
                    } else {
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
                    for userId in user.requestedBy {
                        let lastNotificationTimeKey = "\(currentUser.uid)_\(userId)"
                        if let lastTime = self.notificationTimestamps[lastNotificationTimeKey] {
                            if Date().timeIntervalSince(lastTime) < 600 {
                                continue
                            }
                        }
                        
                        let userRef = self.db.collection("User").document(userId)
                        userRef.getDocument { (doc, err) in
                            if let doc = doc, doc.exists, let data = doc.data(), let userToken = data["token"] as? String {
                                self.sendPushNotification(userToken: userToken, title: "Notification", content: "")
                                self.notificationTimestamps[lastNotificationTimeKey] = Date()
                            }
                        }
                    }
                } else {
                    print("Error decoding current user")
                }
            } else {
                print("Error getting current user:", err)
            }
            
            self.db.collection("User").document(currentUser.uid).updateData([
                "requestedBy": []
            ])
        }
    }
}
