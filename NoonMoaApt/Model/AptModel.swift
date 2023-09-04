//
//  AptViewModel.swift
//  MangMongApt
//
//  Created by kimpepe on 2023/07/20.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseAuth

class AptModel: ObservableObject {
    @Published var apt: Apt?
    @Published var rooms: [Room] = []
    @Published var users: [User] = []
    @Published var user2DLayout : [[User]] = [[]]
    
    private var firestoreManager: FirestoreManager {
        FirestoreManager.shared
    }
    private var db: Firestore {
        firestoreManager.db
    }
    
    func getIndexShaker(userIndex: Int) -> [Int] {
        
        switch userIndex {
        case 0: return [11, 10, 9, 2, 0, 1, 5, 3, 4, 8, 6, 7]
        case 1: return [9, 10, 11, 0, 1, 2, 3, 4, 5, 6, 7, 8]
        case 2: return [10, 11, 9, 1, 2, 0, 4, 5, 3, 7, 8, 6]
        case 3: return [2, 0, 1, 5, 3, 4, 8, 6, 7, 11, 9, 10]
        case 4: return [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
        case 5: return [1, 2, 0, 4, 5, 3, 7, 8, 6, 10, 11, 9]
        case 6: return [5, 3, 4, 8, 6, 7, 11, 9, 10, 2, 0, 1]
        case 7: return [3, 4, 5, 6, 7, 8, 9, 10, 11, 0, 1, 2]
        case 8: return [4, 5, 3, 7, 8, 6, 10, 11, 9, 1, 2, 0]
        case 9: return [8, 6, 7, 11, 9, 10, 2, 0, 1, 5, 3, 4]
        case 10: return [6, 7, 8, 9, 10, 11, 0, 1, 2, 3, 4, 5]
        case 11: return [7, 8, 6, 10, 11, 9, 1, 2, 0, 4, 5, 3]

        default: return []
        }
    }

    // Fetch current user's apartment
    func fetchCurrentUserApt() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let docRef = db.collection("User").document(userId)
        docRef.getDocument { (document, error) in
            guard let document = document, document.exists,
                  let data = document.data(),
                  let aptId = data["aptId"] as? String else { return } // Assuming aptId is of type String
            
            print("AptModel | fetchCurrentUserApt | pass 두 번째 guard let")
            self.generateUserLayout(aptId: aptId)
        }
    }
    
    func fetchUser(userId: String, completion: @escaping (User?) -> Void) {
        let userDocRef = db.collection("User").document(userId)
        
        userDocRef.getDocument { (userDocument, error) in
            if let error = error {
                print("Error fetching user data: \(error)")
                completion(nil)
            } else if let userDocument = userDocument, userDocument.exists, let data = userDocument.data() {
                let user = User(dictionary: data) // Changed this line to use the custom initializer
                completion(user)
            } else {
                completion(nil)
            }
        }
    }
}


extension AptModel {
    func generateUserLayout(aptId: String) {
        let aptId = aptId
        print("AptModel | generateUserLayout | aptId: \(aptId)")
        
        // Step 1: Fetch aptUsers from Apt collection
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User ID not available.")
            return
        }
        
        let userDocRef = db.collection("User").document(userId)
        
        userDocRef.getDocument { (userDocument, userError) in
            guard let userDocument = userDocument, userDocument.exists else {
                print("User document not available.")
                return
            }
            
            // Check if "roomId" key exists in userDocument data
            guard let userRoomId = userDocument.data()?["roomId"] as? String else {
                print("User document missing roomId.")
                return
            }
//            print("AptModel | generateUserLayout | userRoomId: \(userRoomId)")
            
            // User의 현재 아파트에서 상대적인 순서 계산하기 -> 0 ~ 11
            let currentUserIndex = (Int(userRoomId) ?? 0) % 12 - 1
//            print("AptModel | generateUserLayout | currentUserIndex \(currentUserIndex)")
            
            
            let aptDocRef = self.db.collection("Apt").document(aptId)
            aptDocRef.getDocument { (aptDocument, aptError) in
                guard let aptDocument = aptDocument, aptDocument.exists,
                      let aptUsers = aptDocument.data()?["aptUsers"] as? [String] else {
                    print("Apt document not available or missing aptUsers.")
                    return
                }
//                print("AptModel | generateUserLayout | userRoomId \(userRoomId)")
                
                
                
                // Step 2: Create an array with length 12, filling with dummyUserId if needed
                var userIds = aptUsers
                let dummyUserId = "dummyUserId"
                while userIds.count < 12 {
                    userIds.append(dummyUserId)
                }
//                print("AptModel | generateUserLayout | userIds \(userIds)")
                
                // Step 3: Use getIndexShaker() to create a 4x3 array
                let shakedIndices = self.getIndexShaker(userIndex: currentUserIndex)

                print("AptModel | generateUserLayout | shakedIndices: \(shakedIndices)")
                print("AptModel | generateUserLayout | currentUserIndex: \(currentUserIndex)")
                
                var userLayout = [[User?]](repeating: [User?](repeating: nil, count: 3), count: 4) // Initialize 4x3 array with nil
                
                let dispatchGroup = DispatchGroup() // Create a Dispatch Group
                
                for i in 0..<12 {
                    let row = i / 3
                    let col = i % 3
                    print("AptModel | generateUserLayout | shakedIndices[i]: \(shakedIndices[i])")
                    print("AptModel | generateUserLayout | userIds[shakedIndices[i]]: \(userIds[shakedIndices[i]])")
                        
                    let userId = userIds[shakedIndices[i]]
                    
                    if userId == "dummyUserId" {
                        print("ADD dummyUser from User.UTData[0][0]")
                        userLayout[row][col] = User.UTData[row][col] // Assign dummy user
                    } else {
                        dispatchGroup.enter() // Enter the group before starting the async call
                        
                        self.fetchUser(userId: userId) { user in
//                            print("self.fetchUser | user: \(String(describing: user))")
                            if let user = user {
                                userLayout[row][col] = user // Update with fetched user
                            }
                            dispatchGroup.leave() // Leave the group when the async call is finished
                        }
                    }
                }
                
                dispatchGroup.notify(queue: .main) { // This block will be called when all async calls are finished
                    self.user2DLayout = userLayout.compactMap { $0.compactMap { $0 } } // Handle nil values if necessary
//                    print("AptModel | generateUserLayout | self.user2DLayout \(self.user2DLayout)")
                }
            }
        }
    }
}
