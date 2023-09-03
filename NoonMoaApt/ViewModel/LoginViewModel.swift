//
//  LoginViewModel.swift
//  MangMongApt
//
//  Created by kimpepe on 2023/07/20.
//

// LoginViewModel
import Foundation
import Firebase
import FirebaseFirestore
import CryptoKit
import AuthenticationServices
import FirebaseAuth
import SwiftUI

class LoginViewModel: ObservableObject {
    
    private var firestoreManager: FirestoreManager {
        FirestoreManager.shared
    }
    private var db: Firestore {
        firestoreManager.db
    }
    
    @AppStorage("isLogInDone") var isLogInDone: Bool = false
    @Published var nonce = ""
    @Published var fcmToken: String = ""
    var viewRouter = ViewRouter()

    init(viewRouter: ViewRouter) {
        self.viewRouter = viewRouter
    }

    func initializeCounterIfNotExist(counterRef: DocumentReference, initialValue: Any) {
        counterRef.getDocument { (document, error) in
            if let document = document, document.exists {
                // The counter document already exists.
            } else {
                // The counter document does not exist, create and initialize it.
                counterRef.setData(["count": initialValue]) { err in
                    if let err = err {
                        print("Error initializing global counter: \(err)")
                    } else {
                        print("Global counter initialized")
                    }
                }
            }
        }
    }
    
    func initializeCountersIfNotExist() {
        let roomCounterRef = db.collection("globals").document("roomCounter")
        let aptCounterRef = db.collection("globals").document("aptCounter")
        let emptyRoomsRef = db.collection("globals").document("emptyRooms")

        initializeCounterIfNotExist(counterRef: roomCounterRef, initialValue: 0)
        initializeCounterIfNotExist(counterRef: aptCounterRef, initialValue: 0)
        initializeCounterIfNotExist(counterRef: emptyRoomsRef, initialValue: [])
    }

    func authenticate(credential: ASAuthorizationAppleIDCredential) {
        // getting token
        guard let token = credential.identityToken else {
            print("error with firebase")
            return
        }
        
        guard let tokenString = String(data: token, encoding: .utf8) else {
            print("error with token")
            return
        }
        
        let firebaseCredential = OAuthProvider.credential(withProviderID: "apple.com", idToken: tokenString, rawNonce: nonce)
        
        
        Auth.auth().signIn(with: firebaseCredential) { result, err in
            if let err = err {
                print(err.localizedDescription)
            } else {
                print("로그인 완료")
                        
                // Here the user has logged in successfully
                // Now update the user in Firestore
                if let authResult = result {
                    
                    print("LoginViewModel | authenticate | authResult.user.uid \(authResult.user.uid)")
                    let userDocumentRef = self.db.collection("User").document(authResult.user.uid)
                            
                    userDocumentRef.getDocument { (document, error) in
                        if let error = error {
                            print("Error fetching user: \(error)")
                            return
                        }

                        Messaging.messaging().token { token, error in
                            if let error = error {
                                print("Error fetching FCM registration token: \(error)")
                            } else if let token = token {
                                print("FCM registration token: \(token)")
                                // Only update the FCM token if it's a new user
                                if !document!.exists {
                                    self.fcmToken = token
                                    print("LoginViewModel | authenticate | self.token: \(self.fcmToken)")
                                }
                            }
                        }
                        
                        // 존재하지 않은 계정일 때 사용하게 될 새로운 User 객체
                        let user = User(id: authResult.user.uid, roomId: nil, aptId: nil, userState: UserState.sleep.rawValue, lastActiveDate: nil, characterColor: Color.userBlue.toArray, token: self.fcmToken, requestedBy: [])

                        // Check if the user already exists in Firestore
                        let userRef = self.db.collection("User").document(user.id!)
                        userRef.getDocument { (document, error) in
                            if let document = document, document.exists {
                                // The user already exists.
                                print("User already exists. DO NOT assigning a new room.")
                                // 앱 삭제했다가 빌드했을 때 문제를 해결하기 위해
                                self.updateUserFCMToken(userDocumentRef: userDocumentRef)

                            } else {
                                // The user is new, so we update them in Firestore and assign a room
                                print("NEW User. Assigning a new room.")
                                
                                self.updateUserInFirestore(user: user)
                                self.assignRoomToUser(user: user)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func logout(){
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print("Error signing out: \(signOutError)")
        }
    }
    
    func deleteUserAccount() {
        // Get current user
        if let user = Auth.auth().currentUser {
            
            let userDocRef = db.collection("User").document(user.uid)
            
            // Fetch random data from User.UTData (assuming UTData is an array of User objects)
            let randomRow = Int.random(in: 0..<User.UTData.count)
            let randomCol = Int.random(in: 0..<User.UTData[randomRow].count)
            var randomUserData = User.UTData[randomRow][randomCol]
            randomUserData.userState = "vacant"
            
            // Update Firestore with random data
            do {
                try userDocRef.setData(from: randomUserData) { error in
                    if let error = error {
                        print("Error updating user with random data: \(error)")
                    } else {
                        print("User data replaced with random data")
                        
                        // Then sign out the user from Firebase Auth
                        do {
                            try Auth.auth().signOut()
                        } catch let signOutError as NSError {
                            print("Error signing out: \(signOutError)")
                        }
                    }
                }
            } catch let error {
                print("Error encoding user: \(error)")
            }
        }
    }


    
    // 앱 삭제했다가 빌드했을 때 문제를 해결하기 위해
    func updateUserFCMToken(userDocumentRef: DocumentReference) {
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            } else if let token = token {
                print("FCM registration token: \(token)")
                userDocumentRef.updateData(["token": token]) { error in
                    if let error = error {
                        print("Error updating FCM token in Firestore: \(error)")
                    } else {
                        print("FCM token updated in Firestore")
                    }
                }
            }
        }
    }
    
    func updateUserInFirestore(user: User) {
        firestoreManager.syncDB()
            let userData: [String: Any] = [
                "id": user.id ?? "",
                "roomId": user.roomId ?? "",
                "aptId": user.aptId ?? "",
                "userState": user.userState,
                "lastActiveDate": user.lastActiveDate ?? Date(),
                "characterColor": user.characterColor ?? Color.userCyan.toArray,
                "token": self.fcmToken,
                "requestedBy": user.requestedBy
            ]
            self.db.collection("User").document(user.id!).updateData(userData)
    }
    
    func addUserToAptUsers(aptId: String, user: User) {
        let aptUsersRef = db.collection("Apt").document(aptId).collection("aptUsers").document(user.id!)
        let userData: [String: Any] = [
            "id": user.id ?? "",
            "roomId": user.roomId ?? "",
            "aptId": user.aptId ?? "",
            "userState": user.userState,
            "lastActiveDate": user.lastActiveDate ?? Date(),
            "characterColor": user.characterColor ?? Color.userPink.toArray,
            "token": self.fcmToken,
            "requestedBy": user.requestedBy
        ]
        aptUsersRef.setData(userData) { err in
            if let err = err {
                print("Error adding user to aptUsers: \(err)")
            } else {
                print("User added to aptUsers successfully")
            }
        }
    }

    
    
    // Assign a room to a user and update the Apt and Room collections
    func assignRoomToUser(user: User) {
        firestoreManager.syncDB()
        // Get the emptyRooms document
        let emptyRoomsRef = db.collection("globals").document("emptyRooms")
        emptyRoomsRef.getDocument { (document, error) in
            if let document = document, document.exists {
                var emptyRooms = document.data()?["rooms"] as? [String] ?? []
                
                if !emptyRooms.isEmpty {
                    // Print log
                    print("There are empty rooms!!")
                    
                    // There are empty rooms, assign the first one to the user
                    emptyRooms.sort()  // Ensure rooms are in ascending order
                                    
                    let roomToAssign = emptyRooms.removeFirst()
                                    
                    let roomToAssignRef = self.db.collection("Room").document(roomToAssign)
                    roomToAssignRef.getDocument { document, error in
                        guard let document = document, document.exists, let aptId = document.get("aptId") as? String else {
                            if let error = error {
                                print("Error fetching document: \(error)")
                            }
                            return
                        }
                        
                        print(aptId)
                                        
                        let updatedUser = User(id: user.id!, roomId: roomToAssign, aptId: aptId, userState: UserState.sleep.rawValue, lastActiveDate: nil, characterColor: Color.userYellow.toArray, token: self.fcmToken, requestedBy: [])
        
                        // Update the emptyRooms document
                        emptyRoomsRef.setData(["rooms": emptyRooms], merge: true) { err in
                            guard err == nil else {
                                print("Error updating global empty rooms: \(err!)")
                                return
                            }
                            print("Global empty rooms updated")
                        }
        
                        // Update the user in the User collection
                        self.updateUserInFirestore(user: updatedUser)
                        
                        // Update the user in the Room collection
                        roomToAssignRef.updateData(["userId": user.id!]) { err in
                            if let err = err {
                                print("Error updating room: \(err)")
                            } else {
                                print("Room successfully updated")
                            }
                        }
        
                        // Update the user in the Apt collection
                        let aptRef = self.db.collection("Apt").document(aptId)
                        aptRef.updateData(["rooms": FieldValue.arrayUnion([roomToAssign])]) { err in
                            if let err = err {
                                print("Error updating apt: \(err)")
                            } else {
                                print("Apt successfully updated")
                                // Add the user to the aptUsers document in the Apt collection
                                self.addUserToAptUsers(aptId: aptId, user: updatedUser)
                            }
                        }
                    }
                } else {
                    // Get the current number of rooms from a global counter
                    let roomCounterRef = self.db.collection("globals").document("roomCounter")
                    roomCounterRef.getDocument { (document, error) in
                        if let document = document, document.exists {
                            // Get the current room count
                            var roomCount = document.data()?["count"] as? Int ?? 0
                            
                            // Increment the room count
                            roomCount += 1
                            
                            // Create a new room (aptId will be assigned later)
                            var room = Room(id: "\(roomCount)", aptId: nil, number: roomCount, userId: user.id!)
                            
                            // Update the user with the new room id
                            var updatedUser = user
                            updatedUser.roomId = room.id
                            
                            // Update the global room counter
                            roomCounterRef.setData(["count": roomCount], merge: true) { err in
                                if let err = err {
                                    print("Error updating global room counter: \(err)")
                                } else {
                                    print("Global room counter updated")
                                }
                            }
                            
                            // Update the Apt collection
                            let aptCounterRef = self.db.collection("globals").document("aptCounter")
                            aptCounterRef.getDocument { (document, error) in
                                if let document = document, document.exists {
                                    // Get the current apt count
                                    var aptCount = document.data()?["count"] as? Int ?? 0

                                    // Check if we need to create a new apt
                                    if roomCount % 12 == 1 {
                                        aptCount += 1
                                        let newApt = Apt(id: "\(aptCount)", rooms: [room.id!], roomCount: 1)

                                        // Update the room with the new apt id
                                        if let aptId = newApt.id {
                                            room.aptId = aptId
                                        }

                                        // Update the user with the new apt id
                                        updatedUser.aptId = newApt.id

                                        // Add the new apt to the Apt collection
                                        let newAptData: [String: Any] = [
                                            "id": newApt.id ?? "",
                                            "rooms": newApt.rooms,
                                            "roomCount": newApt.roomCount,
                                            "aptUsers": [user.id!] // Add the user to the new apt
                                        ]

                                        self.db.collection("Apt").document(newApt.id!).setData(newAptData)
                                        
                                        // Update the global apt counter
                                        aptCounterRef.setData(["count": aptCount], merge: true)
                                        
//                                        // Create dummy data for the new apt
//                                        self.dummyData.createDummyData(aptId: newApt.id!)
                                        
                                    } else {
                                        // Update the user with the current apt id
                                        updatedUser.aptId = "\(aptCount)"

                                        // Add the new room to the current apt
                                        let currentAptRef = self.db.collection("Apt").document("\(aptCount)")

                                        // Update the room with the current apt id
                                        room.aptId = "\(aptCount)"

                                        currentAptRef.setData([
                                            "rooms": FieldValue.arrayUnion([room.id!]),
                                            "roomCount": FieldValue.increment(Int64(1)),
                                            "aptUsers": FieldValue.arrayUnion([user.id!]) // Add the user to the existing apt
                                        ], merge: true) { err in
                                            if let err = err {
                                                print("Error updating apt: \(err)")
                                            } else {
                                                print("Apt updated with new room")
                                            }
                                        }
                                    }
                                    
                                    // Add the new room to the Room collection
                                    let newRoomData: [String: Any] = [
                                        "id": room.id ?? "",
                                        "aptId": room.aptId,
                                        "userId": room.userId
                                    ]
                                    self.db.collection("Room").document(room.id!).setData(newRoomData)
                                    
                                    // Update the user in the User collection
                                    let userData: [String: Any] = [
                                        "id": user.id ?? "",
                                        "roomId": updatedUser.roomId ?? "",
                                        "aptId": updatedUser.aptId ?? "",
                                        "userState": user.userState,
                                        "lastActiveDate": user.lastActiveDate ?? "",
                                        "characterColor": user.characterColor,
                                        "token": self.fcmToken,
                                        "requestedBy": user.requestedBy
                                    ]
                                    self.db.collection("User").document(user.id!).setData(userData)
                                } else {
                                    print("Document does not exist11")
                                }
                            }
                        } else {
                            print("Document does not exist22")
                        }
                    }
                }
            }
        }
    }
    
    
    // Helper for Apple Login with Firebase
    func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError(
                        "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
                    )
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
}
