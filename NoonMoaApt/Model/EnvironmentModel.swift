//
//  EnvironmentModel.swift
//  NoonMoaApt
//
//  Created by 최민규 on 2023/08/27.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import SwiftUI

struct EnvironmentRecord: Identifiable {
    @DocumentID var id: String?
    var rawWeather: String
    var rawTime: Date
    var rawSunriseTime: Date
    var rawSunsetTime: Date
}

struct EnvironmentRecordViewData: Identifiable {
    @DocumentID var id: String?
    var weather: String
    var isWind: Bool
    var isThunder: Bool
    var time: String
    
    var lottieImageName: String
    var colorOfSky: LinearGradient
    var colorOfGround: LinearGradient
    
    var broadcastAttendanceIncompleteTitle: String
    var broadcastAttendanceIncompleteBody: String
    var broadcastAttendanceCompletedTitle: String
    var broadcastAttendanceCompletedBody: String
    
    var broadcastAnnounce: String
    var stampLargeSkyImage: Image
    var stampSmallSkyImage: Image
    var stampBorderColor: Color
}
