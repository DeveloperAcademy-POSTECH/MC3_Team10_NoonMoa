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
    var userId: String?
    var date: Date?
    
    var rawIsSmiling: Bool?
    var rawIsBlinkingLeft: Bool?
    var rawIsBlinkingRight: Bool?
    var rawLookAtPoint: [Float]?
    var rawFaceOrientation: [Float]?
    var rawCharacterColor: [Float]?
    
    var rawWeather: String?
    var rawTime: Date?
    var rawSunriseTime: Date?
    var rawSunsetTime: Date?
}


class AttendanceModel: ObservableObject {
    
    private var firestoreManager: FirestoreManager {
        FirestoreManager.shared
    }
    private var db: Firestore {
        firestoreManager.db
    }

    // 외부에서 사용할 수 있는 attendanceRecords와 todayRecord 변수 추가
    var attendanceRecords: [Date: AttendanceRecord] = [:]
    var todayRecord: AttendanceRecord? = nil
    
    private var characterViewModel: CharacterViewModel = CharacterViewModel()
    private var environmentViewModel: EnvironmentViewModel = EnvironmentViewModel()
    
    // @Published var newAttendanceRecord: AttendanceRecord? = nil //^^ @Published가 필요성 고민 중...
    var newAttendanceRecord: AttendanceRecord? = nil
    
    init(newAttendanceRecord: AttendanceRecord) {
        // Initialize characterModel and environmentModel here
        self.newAttendanceRecord = newAttendanceRecord
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
        
//        environmentModel.getCurrentEnvironment()
//        environmentModel.saveRawEnvironmentToAttendanceModel(newAttendanceRecord: &newAttendanceRecord)
//        characterModel.saveRawCharacterToAttendanceModel(newAttendanceRecord: &newAttendanceRecord)
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
        fetchAttendanceRecords(date: date) { fetchedRecords in

            
            // 외부 변수를 업데이트
            self.attendanceRecords = fetchedRecords.compactMapValues { (record) -> AttendanceRecord? in
                record
            }.compactMapKeys { dateString in
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                return dateFormatter.date(from: dateString)
            }

            print("AttendanceModel | downloadAttendanceRecords | attendanceRecords: \(self.attendanceRecords))")
            print("=============")
            
            
            // 오늘 날짜와 일치하는 데이터를 필터링
            let startOfDay = Calendar.current.startOfDay(for: date)
            let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!
            
            let todaysRecords = fetchedRecords.filter { (key, record) in
                let recordDate = record.date
                return recordDate >= startOfDay && recordDate < endOfDay
            }
            
            // 일치하는 데이터 중 첫 번째를 선택하고 외부 변수를 업데이트
            self.todayRecord = todaysRecords.first?.value
            print("AttendanceModel | downloadAttendanceRecords | todayRecord: \(String(describing: self.todayRecord))")
        }
    }
    
    func fetchAttendanceRecords(date: Date, completion: @escaping ([String: AttendanceRecord]) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            print("No current user")
            return
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
//                    print("Document Data: \(document.data())") // 이 로그를 추가
                    let documentID = document.documentID  // 문서 ID를 가져옵니다.
                    let data = document.data()
                    
                    if let userId = data["userId"] as? String,
                       let timestamp = data["date"] as? Timestamp,
                       let rawIsSmiling = data["rawIsSmiling"] as? Bool,
                       let rawIsBlinkingLeft = data["rawIsBlinkingLeft"] as? Bool,
                       let rawIsBlinkingRight = data["rawIsBlinkingRight"] as? Bool,
                       let rawLookAtPoint = (data["rawLookAtPoint"] as? NSArray)?.compactMap({ $0 as? Float }),
                       let rawFaceOrientation = (data["rawFaceOrientation"] as? NSArray)?.compactMap({ $0 as? Float }),
                       let rawCharacterColor = (data["rawCharacterColor"] as? NSArray)?.compactMap({ $0 as? Float }),
                       let rawWeather = data["rawWeather"] as? String,
                       let rawTime = (data["rawTime"] as? Timestamp)?.dateValue(),
                       let rawSunriseTime = (data["rawSunriseTime"] as? Timestamp)?.dateValue(),
                       let rawSunsetTime = (data["rawSunsetTime"] as? Timestamp)?.dateValue() {
                        
                        let date = timestamp.dateValue()
                        let newRecord = AttendanceRecord(id: document.documentID,
                                                         userId: userId,
                                                         date: date,
                                                         rawIsSmiling: rawIsSmiling,
                                                         rawIsBlinkingLeft: rawIsBlinkingLeft,
                                                         rawIsBlinkingRight: rawIsBlinkingRight,
                                                         rawLookAtPoint: rawLookAtPoint,
                                                         rawFaceOrientation: rawFaceOrientation,
                                                         rawCharacterColor: rawCharacterColor,
                                                         rawWeather: rawWeather,
                                                         rawTime: rawTime,
                                                         rawSunriseTime: rawSunriseTime,
                                                         rawSunsetTime: rawSunsetTime)
                        
                        let dateString = self.changeDateToString(date: newRecord.date)
                        // fetchedRecords[dateString] = newRecord
                        fetchedRecords[documentID] = newRecord  // 문서 ID를 키로 사용

                        
                        print("newRecord: \(newRecord)")
                        print("New record with Document ID \(documentID) is saved.")  // 디버깅용

                        
                        // 이제 새로 생성된 AttendanceRecord 객체를 사용하여 environmentModel과 characterModel을 업데이트합니다.
                        self.environmentModel.fetchRecordedEnvironment(record: newRecord)
                        self.characterModel.fetchRecordedCharacter(record: newRecord)
                    } else {
                        print("Document doesn't match the structure of AttendanceRecord")
                    }
                }
                completion(fetchedRecords)
            }
    }
}


extension Dictionary {
    func compactMapKeys<T>(_ transform: (Key) throws -> T?) rethrows -> [T: Value] {
        var newDict: [T: Value] = [:]
        for (key, value) in self {
            if let newKey = try transform(key) {
                newDict[newKey] = value
            }
        }
        return newDict
    }
}
