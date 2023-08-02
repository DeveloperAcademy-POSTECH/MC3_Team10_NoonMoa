//
//  RoomData.swift
//  MangMongApt
//
//  Created by kimpepe on 2023/07/15.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import SwiftUI

struct User: Codable, Identifiable, Equatable {
    @DocumentID var id: String?
    var roomId: String?
    var aptId: String?
    var userState: String
    var lastActiveDate: Date?
    var characterColor: [Float]?
    var token: String
    var requestedBy: [String]
    var clicked: Bool = false
    var isJumping: Bool = false
    
    var stateEnum: UserState {
        get { return UserState(rawValue: userState) ?? .inactive }
        set { userState = newValue.rawValue }
    }
    
//    var characterColorEnum: CharacterColor {
//        get { return CharacterColor(rawValue: characterColor) ?? Color.userBlue.toArray }
//        set { characterColor = newValue.rawValue }
//    }
}

extension User {
    init?(dictionary: [String: Any]) {
        guard let userState = dictionary["userState"] as? String,
              let token = dictionary["token"] as? String,
              let requestedBy = dictionary["requestedBy"] as? [String]
        else { return nil }

        self.id = dictionary["id"] as? String
        self.roomId = dictionary["roomId"] as? String
        self.aptId = dictionary["aptId"] as? String
        self.userState = userState
        self.lastActiveDate = dictionary["lastActiveDate"] as? Date
        self.characterColor = dictionary["characterColor"] as? [Float] ?? Color.userBlue.toArray
        self.token = token
        self.requestedBy = requestedBy
        self.clicked = false
        self.isJumping = false

    }
}


//struct AttendanceRecord: Codable, Identifiable {
//    @DocumentID var id: String? // = UUID().uuidString <- 이 부분 제거
//    var userId: String
//    var date: Date
//    var weatherCondition: String
//    var eyeDirection: [Float]
//    var aptId: String? // add this line
//}


struct AttendanceSheet: Codable, Identifiable {
    @DocumentID var id: String?
    var attendanceRecords: [String] // References to AttendanceRecord document IDs
    var userId: String // Reference to User document ID
}

struct Room: Codable, Identifiable {
    @DocumentID var id: String?
    var aptId: String
    var userId: String // References to User document IDs
    var number: Int
    
    init(id: String?, aptId: String?, number: Int?, userId: String?) {
        self.id = id
        self.aptId = aptId ?? ""
        self.userId = userId ?? ""
        self.number = number ?? 0
    }
}

extension Room {
    static func dummyRoom() -> Room {
        return Room(id: nil, aptId: nil, number: nil, userId: nil)
    }
}

struct Apt: Codable, Identifiable {
    @DocumentID var id: String?
    var rooms: [String] // References to Room document IDs
    var roomCount: Int // Total number of rooms
    
    init(id: String?, rooms: [String]?, roomCount: Int?) {
        self.id = id
        self.rooms = rooms ?? []
        self.roomCount = roomCount ?? 0
    }
}

struct Notification: Codable, Identifiable {
    @DocumentID var id: String? // Firestore에서 자동으로 생성하는 Document ID
    var receiverId: String // 알림을 받는 사용자의 ID
    var senderId: String // 알림을 보내는 사용자의 ID
    var type: String // 알림의 유형을 나타내는 문자열. 예를 들어 'request' 또는 'response'
    var sentAt: Date // 알림이 발송된 시간
    var read: Bool // 알림을 읽은 사용자의 ID

    // 이 enum은 Notification의 유형을 표현하고, Firebase와 호환성을 보장하기 위해 rawValue를 사용합니다.
    enum NotificationType: String {
        case request = "request"
        case response = "response"
    }

    var notificationTypeEnum: NotificationType {
        get { return NotificationType(rawValue: type) ?? .request }
        set { type = newValue.rawValue }
    }
}

enum UserState: String, Codable {
    case vacant = "vacant"
    case sleep = "sleep"
    case active = "active"
    case inactive = "inactive"
}

//enum CharacterColor: [Float], Codable {
//    case pink = "pink"
//    case cyan = "cyan"
//    case yellow = "yellow"
//    case blue = "blue"
//    
//    init(from decoder: Decoder) throws {
//        let label = try decoder.singleValueContainer().decode(String.self)
//        switch label {
//        case "pink":
//            self = .pink
//        case "cyan":
//            self = .cyan
//        case "yellow":
//            self = .yellow
//        case "blue":
//            self = .blue
//        // Add more cases as needed
//        default:
//            throw DecodingError.dataCorruptedError(in: try! decoder.singleValueContainer(), debugDescription: "Unable to decode eye color")
//        }
//    }
//}

enum WeatherCondition: String, Codable {
    case clear = "clear"
    case cloudy = "cloudy"
    case rainy = "rainy"
    case snow = "snow"
    case thunderstorms = "thunderstorms"
}

/*
 @DocumentID var id: String?
 var roomId: String?
 var aptId: String?
 var userState: String
 var lastActiveDate: Date?
 var characterColor: String
 var token: String
 */


extension User {

    static let UTData: [[User]] =
    [
        [User(roomId: "1", aptId: "1", userState: "active", lastActiveDate: Date(), characterColor: [212/255, 218/255, 151/255], token: "a",requestedBy: []),
         User(roomId: "2", aptId: "1", userState: "active", lastActiveDate: Date(), characterColor: [138/255, 141/255, 197/255], token: "b",requestedBy: []),
         User(roomId: "3", aptId: "1", userState: "active", lastActiveDate: Date(), characterColor: [177/255, 203/255, 182/255], token: "c",requestedBy: [])],
        [User(roomId: "4", aptId: "1", userState: "active", lastActiveDate: Date(), characterColor: [220/255, 126/225, 126/255], token: "d",requestedBy: []),
         User(roomId: "5", aptId: "1", userState: "active", lastActiveDate: Date(), characterColor: [220/255, 126/225, 126/255], token: "e",requestedBy: []),
         User(roomId: "6", aptId: "1", userState: "sleep", lastActiveDate: Date(), characterColor: [177/255, 203/255, 182/255], token: "f",requestedBy: [])],
        [User(roomId: "7", aptId: "1", userState: "inactive", lastActiveDate: Date(), characterColor: [230/255, 170/255, 150/255], token: "g",requestedBy: []),
         User(roomId: "8", aptId: "1", userState: "sleep", lastActiveDate: Date(), characterColor: [138/255,141/255,197/255], token: "h",requestedBy: []),
         User(roomId: "9", aptId: "1", userState: "active", lastActiveDate: Date(), characterColor: [177/255, 203/255, 182/255], token: "i",requestedBy: [])],
        [User(roomId: "10", aptId: "1", userState: "active", lastActiveDate: Date(), characterColor: [212/255, 218/255, 151/255], token: "j",requestedBy: []),
         User(roomId: "11", aptId: "1", userState: "active", lastActiveDate: Date(), characterColor: [220/255, 126/225, 126/255], token: "k",requestedBy: []),
         User(roomId: "12", aptId: "1", userState: "inactive", lastActiveDate: Date(), characterColor: [], token: "l",requestedBy: [])]
    ]
}
