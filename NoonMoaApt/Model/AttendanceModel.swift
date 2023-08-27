//
//  AttendanceModel.swift
//  NoonMoaApt
//
//  Created by 최민규 on 2023/07/31.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

struct AttendanceRecord: Codable, Identifiable {
    
    @DocumentID var id: String? // = UUID().uuidString <- 이 부분 제거
    var userId: String
    var date: Date
    
    var rawIsSmiling: Bool
    var rawIsBlinkingLeft: Bool
    var rawIsBlinkingRight: Bool
    var rawLookAtPoint: [Float]
    var rawFaceOrientation: [Float]
    var rawCharacterColor: [Float]
    
    var rawWeather: String
    var rawTime: Date
    var rawSunriseTime: Date
    var rawSunsetTime: Date
}


class AttendanceModel: ObservableObject {
    
    private var characterModel: CharacterModel = CharacterModel()
    private var environmentModel: EnvironmentModel = EnvironmentModel()
    
    //    @Published var newAttendanceRecord: AttendanceRecord? = nil //^^ @Published가 필요성 고민 중...
    var newAttendanceRecord: AttendanceRecord? = nil
    
    init(newAttendanceRecord: AttendanceRecord) {
        // Initialize characterModel and environmentModel here
        self.newAttendanceRecord = newAttendanceRecord
    }
    
    // ^^
    // 페페의 코드
    private var firestoreManager: FirestoreManager {
        FirestoreManager.shared
    }
    private var db: Firestore {
        firestoreManager.db
    }
    
    // Function to convert AttendanceRecord to a dictionary
    func attendanceRecordToDictionary(_ record: AttendanceRecord) -> [String: Any] {
        return [
            "userId": record.userId,
            "date": record.date,
            "rawIsSmiling": record.rawIsSmiling,
            "rawIsBlinkingLeft": record.rawIsBlinkingLeft,
            "rawIsBlinkingRight": record.rawIsBlinkingRight,
            "rawLookAtPoint": record.rawLookAtPoint,
            "rawFaceOrientation": record.rawFaceOrientation,
            "rawCharacterColor": record.rawCharacterColor,
            "rawWeather": record.rawWeather,
            "rawTime": record.rawTime,
            "rawSunriseTime": record.rawSunriseTime,
            "rawSunsetTime": record.rawSunsetTime
        ]
    }
    
    func changeDateToString(date: Date) -> String {
        let nowDate = date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: newAttendanceRecord?.date ?? nowDate)
        
        return dateString
    }
    
    
    // 출석도장 찍거나 설정창에서 바꿀 때
    func uploadAttendanceRecord() {
        
        // Get the Firebase Firestore reference for the current user
        guard let currentUser = Auth.auth().currentUser else {
            print("No current user")
            return
            
        }
        
        // MARK: - 서버에 업로드 될 때는 Timestamp 타입으로 자동 변환이 되어서 주석 처리 해놓음.
        // Convert Swift Date to Firebase Timestamp
        // let timestamp = Timestamp(date: newAttendanceRecord?.date ?? nowDate)
        
        let nowDate = Date()
        let dateString = changeDateToString(date: nowDate)
        
        newAttendanceRecord?.userId = currentUser.uid
        newAttendanceRecord?.date = nowDate
        
        environmentModel.getCurrentEnvironment()
        environmentModel.saveRawEnvironmentToAttendanceModel(newAttendanceRecord: &newAttendanceRecord)
        characterModel.saveRawCharacterToAttendanceModel(newAttendanceRecord: &newAttendanceRecord)
        print("newAttendanceRecord: \(String(describing: newAttendanceRecord))")
        
        // 마지막으로 Firebase에 Date를 key 값으로 사용하여, userId를 포함한 newAttendanceRecord를 기록한다!!!
        // Example of saving the newAttendanceRecord to Firebase:
        
        // Convert AttendanceRecord to a dictionary"
        guard let newRecord = newAttendanceRecord else {
            print("No new attendance record to save.")
            return
        }
        let recordData = attendanceRecordToDictionary(newRecord)
        
        
        // Save the attendance record to Firebase
        db.collection("User").document(currentUser.uid).collection("attendanceRecords").document(dateString).setData(recordData) { error in
            if let error = error {
                print("Error saving attendance record: \(error.localizedDescription)")
            } else {
                print("Attendance record saved for date: \(dateString)")
            }
        }
    }
    
    // 앱이 켜질 때 다운로드
    func downloadAttendanceRecords(for date: Date) {
        let attendanceRecords = fetchAttendanceRecords(date: date)//추후 반복문 실행 시 밖으로 꺼낼 것
        print("AttedanceModel | downloadAttendanceRecords | attendanceRecords : \(attendanceRecords)")
        
        // fetchAttendanceRecords 메서드 안의 completion 안으로 옮겼다. 실행 순서를 보장하려고.
//        let dateString = changeDateToString(date: date)
//        print("AttedanceModel | downloadAttendanceRecords | dateString : \(dateString)")
        
//        if let record = attendanceRecords[dateString] {
//            environmentModel.fetchRecordedEnvironment(record: record)
//            characterModel.fetchRecordedCharacter(record: record)
//        }
    }
    
    //    // 앱이 켜질 때 다운로드
    //    func downloadAttendanceRecords(for date: Date) {
    //        guard let currentUser = Auth.auth().currentUser else {
    //            print("No current user")
    //            return
    //        }
    //
    //        let dateFormatter = DateFormatter()
    //        dateFormatter.dateFormat = "yyyy-MM-dd"
    //        let dateString = dateFormatter.string(from: date)
    //
    //        db.collection("User").document(currentUser.uid).collection("attendanceRecords").document(dateString).getDocument { (document, error) in
    //            if let error = error {
    //                print("Error fetching attendance record for date \(dateString): \(error.localizedDescription)")
    //                return
    //            }
    //
    //            if let document = document, document.exists {
    //                do {
    //                    if let record = try document.data(as: AttendanceRecord?.self) {
    //                        self.environmentModel.fetchRecordedEnvironment(record: record)
    //                        self.characterModel.fetchRecordedCharacter(record: record)
    //                    }
    //                } catch let error {
    //                    print("Error decoding attendance record for date \(dateString): \(error.localizedDescription)")
    //                }
    //            } else {
    //                print("No attendance record found for date \(dateString).")
    //            }
    //        }
    //    }
    
    
    //        func fetchAttendanceRecords() -> [Date: AttendanceRecord] {
    ////             Fetch attendance records from Firebase and return them as [Date: AttendanceRecord]
    ////             Example of fetching from Firebase and converting to the desired dictionary format:
    ////             var records = [Date: AttendanceRecord]()
    ////             ... Fetch records from Firebase ...
    //             for record in fetchedRecords {
    //                 records[record.rawTime] = record
    //             }
    //             return records
    //                    return [:] // Placeholder: Replace this with the actual fetched records
    //        }
    
    func fetchAttendanceRecords(date: Date) -> [String: AttendanceRecord]  {
        guard let currentUser = Auth.auth().currentUser else {
            print("No current user")
            return [:]
        }
        var fetchedRecords: [String: AttendanceRecord] = [:]
        
        db.collection("User").document(currentUser.uid).collection("attendanceRecords")
            .order(by: "date", descending: true)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error fetching attendance records: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = querySnapshot?.documents else {
                    print("No attendance records found.")
                    return
                }
                
                print("AttendanceModel | fetchAttedanceRecords | documents: \(documents.count)")
                
                for document in documents {
                    print("AttendanceModel | fetchAttedanceRecords | document: \(document.data()["rawWeather"] as? String ?? "")")
                    do {
                        // 여기서 record의 if let 풀어버렸다
                        let record = try document.data(as: AttendanceRecord.self)
                        let dateString = self.changeDateToString(date: record.date)
                        fetchedRecords[dateString] = record
                    } catch let error {
                        print("Error decoding attendance record: \(error.localizedDescription)")
                    }
                }
                
                let dateString = self.changeDateToString(date: date)
                print("AttedanceModel | downloadAttendanceRecords | dateString : \(dateString)")
                
                if let record = fetchedRecords[dateString] {
                    print("AttedanceModel | downloadAttendanceRecords | record: \(record)")
                    self.environmentModel.fetchRecordedEnvironment(record: record)
                    self.characterModel.fetchRecordedCharacter(record: record)
                }
            }
        
        return fetchedRecords
    }
    
    
    //        // Example of saving the attendance record to Firebase
    //        func saveAttendanceRecordToFirebase(record: AttendanceRecord) {
    ////             ... Save the record to Firebase ...
    //             Firestore.firestore().collection("attendanceRecords").addDocument(from: record) { error in
    //                if let error = error {
    //                    print("Error adding document: \(error)")
    //                } else {
    //                    print("Document added with ID: \(record.id ?? "")")
    //                }
    //             }
    //        }
    
    //    // Save an attendance record to Firebase for the current user
    //    func saveAttendanceRecordToFirebase(record: AttendanceRecord) {
    //
    //        guard let currentUser = Auth.auth().currentUser else {
    //            print("No current user")
    //            return
    //        }
    //
    //        let dateFormatter = DateFormatter()
    //        dateFormatter.dateFormat = "yyyy-MM-dd"
    //        let dateString = dateFormatter.string(from: record.date)
    //
    //        do {
    //            try db.collection("User").document(currentUser.uid).collection("attendanceRecords").document(dateString).setData(from: record)
    //            print("Attendance record saved for date: \(dateString)")
    //        } catch let error {
    //            print("Error saving attendance record: \(error.localizedDescription)")
    //        }
    //    }
    
}
