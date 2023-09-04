//
//  AttendanceModel.swift
//  NoonMoaApt
//
//  Created by 최민규 on 2023/07/31.
//

import SwiftUI
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

