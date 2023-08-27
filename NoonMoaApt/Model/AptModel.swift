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
        var tbr: [Int]
        
        switch userIndex {
        case 1: tbr = [0, 11, 10, 3, 1, 2, 6, 4, 5, 9, 7, 8]
        case 2: tbr = [10, 11, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
        case 3: tbr = [11, 0, 10, 2, 3, 1, 5, 6, 4, 8, 9, 7]
        case 4: tbr = [3, 1, 2, 6, 4, 5, 9, 7, 8, 0, 10, 11]
        case 5: tbr = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 0]
        case 6: tbr = [2, 3, 1, 5, 6, 4, 8, 9, 7, 11, 0, 10]
        case 7: tbr = [6, 4, 5, 9, 7, 8, 0, 10, 11, 3, 1, 2]
        case 8: tbr = [4, 5, 6, 7, 8, 9, 10, 11, 0, 1, 2, 3]
        case 9: tbr = [5, 6, 4, 8, 9, 7, 11, 0, 10, 2, 3, 1]
        case 10: tbr = [9, 7, 8, 0, 10, 11, 3, 1, 2, 6, 4, 5]
        case 11: tbr = [7, 8, 9, 10, 11, 0, 1, 2, 3, 4, 5, 6]
        case 12: tbr = [8, 9, 7, 11, 12, 10, 2, 3, 1, 5, 6, 4]

        default: return []
        }
        
        return tbr
    }
//    // 올리버의 방 배치 알고리즘
//    func getIndexShaker(userIndex: Int) -> [Int] {
//        let numPerFloor = 3
//        let floorNum = 4
//        let aptCapacity = numPerFloor * floorNum // = 12
//
//        // to be returned
//        var tbr = [Int]()
//
//        for i in 0..<aptCapacity {
//            tbr.append(i)
//        }
//
//        guard userIndex >= 0, userIndex < aptCapacity else {
//            print("wrong userIndex")
//            return tbr
//        }
//        // quotient
//        // q >= 0
//        let q = userIndex / numPerFloor
//
//        // remainer
//        let r = userIndex % numPerFloor
//
//        var quotientArray = [Int]()
//        for i in 0..<floorNum {
//            quotientArray.append(q-1+i)
//        }
//
//        // maxQ must equal to quotientArray.count
//        for i in 0..<quotientArray.count {
//            if quotientArray[i] < 0 {
//                quotientArray[i] += floorNum
//            } else if quotientArray[i] >= floorNum {
//                quotientArray[i] -= floorNum
//            }
//        }
//
//        var remainderArray = [Int]()
//        for i in 0..<numPerFloor {
//            remainderArray.append(r-1+i)
//        }
//
//        // numPerFloor must equal to remainderArray.count
//        for i in 0..<remainderArray.count {
//            if remainderArray[i] < 0 {
//                remainderArray[i] += numPerFloor
//            } else if remainderArray[i] >= numPerFloor {
//                remainderArray[i] -= numPerFloor
//            }
//        }
//
//        for i in 0..<aptCapacity {
//            let iq = i / numPerFloor
//            let ir = i % numPerFloor
//            tbr[i] = quotientArray[iq] * numPerFloor + remainderArray[ir]
//        }
//
//        return tbr
//    }
    
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
                
                var userLayout = [[User?]](repeating: [User?](repeating: nil, count: 3), count: 4) // Initialize 4x3 array with nil
                
                let dispatchGroup = DispatchGroup() // Create a Dispatch Group
                
                for i in 0..<12 {
                    let row = i / 3
                    let col = i % 3
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
