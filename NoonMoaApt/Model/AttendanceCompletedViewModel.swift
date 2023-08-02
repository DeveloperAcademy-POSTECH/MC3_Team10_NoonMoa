//
//  AttendanceCompletedViewModel.swift
//  MangMongApt
//
//  Created by kimpepe on 2023/07/20.
//

import Foundation
import Firebase
import FirebaseFirestore

class AttendanceCompletedViewModel: ObservableObject {
    @Published var userId: String
    @Published var weatherCondition: String
    @Published var eyeDirection: [Float]
    @Published var attendanceRecord: AttendanceRecord? = nil
    @Published var user: User? = nil
    private let currentUser = Auth.auth().currentUser
    
    private var firestoreManager: FirestoreManager {
        FirestoreManager.shared
    }
    private var db: Firestore {
        firestoreManager.db
    }
    
    init(record: AttendanceRecord) {
        self.userId = currentUser?.uid ?? ""
        self.weatherCondition = record.weatherCondition
        self.eyeDirection = record.eyeDirection
        self.attendanceRecord = record
    }
    
    func saveAttendanceRecord(record: AttendanceRecord) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("Error: Current user ID not available.")
            return
        }
        
        do {
            let newRecordRef = try db.collection("AttendanceRecord").addDocument(from: record)
            self.attendanceRecord = record
            print("AttendanceRecord")
            
            // Create a new AttendanceSheet if it doesn't exist
            let attendanceSheetRef = db.collection("AttendanceSheet").document(currentUserID)
            attendanceSheetRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    // If the AttendanceSheet exists, update it
                    attendanceSheetRef.updateData([
                        "attendanceRecords": FieldValue.arrayUnion([newRecordRef.documentID])
                    ])
                } else {
                    // If the AttendanceSheet doesn't exist, create a new one
                    let newAttendanceSheet = AttendanceSheet(id: currentUserID, attendanceRecords: [newRecordRef.documentID], userId: currentUserID)
                    do {
                        try attendanceSheetRef.setData(from: newAttendanceSheet)
                    } catch let error {
                        print("Error writing new attendance sheet to Firestore: \(error)")
                    }
                }
            }
        } catch let error {
            print("Error writing new attendance record to Firestore: \(error)")
        }
    }

    
    func updateUserLastActiveDate() {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("Error: Current user ID not available.")
            return
        }
        
        // Fetch the User document first
        db.collection("User").document(currentUserID).getDocument { (document, error) in
            if let document = document, document.exists {
                let user = try? document.data(as: User.self)
                
                // Now update the User document with lastActiveDate and state only
                self.db.collection("User").document(currentUserID).updateData([
                    "lastActiveDate": Date()
                    //                    "userState": UserState.active.rawValue
                ])
            } else {
                print("User does not exist or an error occurred while fetching user data.") // Handle this case appropriately
            }
        }
    }

    
    func updateRecord(newRecord: AttendanceRecord) {
        self.userId = newRecord.userId
        self.weatherCondition = newRecord.weatherCondition
        self.eyeDirection = newRecord.eyeDirection
        self.attendanceRecord = newRecord
    }
}
