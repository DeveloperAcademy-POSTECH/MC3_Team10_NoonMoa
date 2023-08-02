//
//  CharacterModel.swift
//  NoonMoaApt
//
//  Created by 최민규 on 2023/07/31.
//

import Foundation
import SwiftUI

class CharacterModel: ObservableObject {
    
    var rawIsSmiling: Bool = false
    var rawIsBlinkingLeft: Bool = false
    var rawIsBlinkingRight: Bool = false
    var rawLookAtPoint: [Float] = [0.0, 0.0, 0.0]
    var rawFaceOrientation: [Float] = [0.0, 0.0, 0.0]
    var rawCharacterColor: [Float] = [0.0, 0.0, 0.0]
    
    var currentIsSmiling: Bool = false
    var currentIsBlinkingLeft: Bool = false
    var currentIsBlinkingRight: Bool = false
    var currentLookAtPoint: SIMD3<Float> = SIMD3<Float>(0.0, 0.0, 0.0)
    var currentFaceOrientation: SIMD3<Float> = SIMD3<Float>(0.0, 0.0, 0.0)
    var currentCharacterColor: Color = Color.userCyan
    
    var recordedRawIsSmiling: Bool = false
    var recordedRawIsBlinkingLeft: Bool = false
    var recordedRawIsBlinkingRight: Bool = false
    var recordedRawLookAtPoint: [Float] = [0.0, 0.0, 0.0]
    var recordedRawFaceOrientation: [Float] = [0.0, 0.0, 0.0]
    var recordedRawCharacterColor: [Float] = [0.0, 0.0, 0.0]
    
    var recordedIsSmiling: Bool = false
    var recordedIsBlinkingLeft: Bool = false
    var recordedIsBlinkingRight: Bool = false
    var recordedLookAtPoint: SIMD3<Float> = SIMD3<Float>(0.0, 0.0, 0.0)
    var recordedFaceOrientation: SIMD3<Float> = SIMD3<Float>(0.0, 0.0, 0.0)
    var recordedCharacterColor: [Float] = [0.0, 0.0, 0.0]
    
    // MARK: - 업로드 -
    
    // Character의 실시간 데이터를 받아올 때 사용
    func getCurrentCharacter() {
        getCurrentCharacterViewData()
        convertViewDataToRawCharacter(isSmiling: currentIsSmiling, isBlinkingLeft: currentIsBlinkingLeft, isBlinkingRight: currentIsBlinkingRight, lookAtPoint: currentLookAtPoint, faceOrientation: currentFaceOrientation, characterColor: currentCharacterColor)
        print(rawLookAtPoint)
    }
    
    // Character의 실시간 데이터를 받아옴.
    // View에서 바로 사용할 수 있는 형식이므로, ViewData라는 함수명을 사용
    func getCurrentCharacterViewData() {
    print("currentLookAtPoint: \(currentLookAtPoint)")
    }
    
    // AttendanceModel을 통해 서버에 저장할 때 사용
    //원본 데이터를 서버에 저장할 수 있는 데이터 형식으로 변환
    func convertViewDataToRawCharacter(isSmiling: Bool, isBlinkingLeft: Bool, isBlinkingRight: Bool, lookAtPoint: SIMD3<Float>, faceOrientation: SIMD3<Float>, characterColor: Color) {
        rawIsSmiling = isSmiling
        rawIsBlinkingLeft = isBlinkingLeft
        rawIsBlinkingRight = isBlinkingRight
        rawLookAtPoint = [Float(lookAtPoint.x), Float(lookAtPoint.y), Float(lookAtPoint.z)]
        rawFaceOrientation = [Float(faceOrientation.x), Float(faceOrientation.y), Float(faceOrientation.z)]
        rawCharacterColor = [Float(characterColor.toArray[0]), Float(characterColor.toArray[1]), Float(characterColor.toArray[2])]
    }
    
    // 서버에 저장하기 위해, Attendance 모델을 업데이트 할 때 사용
    // attendanceModel.newAttendanceRecord에 접근하여, Character와 관련된 recordedRaw...변수를 업데이트 해주는 방식
    // newAttendanceRecord는 EnvironmentModel으로도 업데이트 받은 뒤에, 서버에 업로드
//    func saveRawCharacterToAttendanceModel()  {
//        //attendanceModel.newAttendanceRecord(...)
//    }
    func saveRawCharacterToAttendanceModel(newAttendanceRecord: inout AttendanceRecord?) {
        // Update recorded character-related data properties in newAttendanceRecord with the  raw character data from CharacterModel
        
        if newAttendanceRecord == nil {
            print("CharacterModel | saveRawCharacterToAttendanceModel | newAttendanceRecord == nil")
            return
        }
        
//        newAttendanceRecord?.rawIsSmiling = rawIsSmiling
//        newAttendanceRecord?.rawIsBlinkingLeft = rawIsBlinkingLeft
//        newAttendanceRecord?.rawIsBlinkingRight = rawIsBlinkingRight
//        newAttendanceRecord?.rawLookAtPoint = rawLookAtPoint
//        newAttendanceRecord?.rawFaceOrientation = rawFaceOrientation
//        newAttendanceRecord?.rawCharacterColor = rawCharacterColor
        newAttendanceRecord?.rawCharacterColor = CharacterModel().rawCharacterColor
        // Update other recorded character-related properties as needed
    }

    
    
    // MARK: - 다운로드 -
    
    // 서버에 저장된 AttendanceModel을 통해 받아올 때 사용한다.
    func fetchRecordedCharacter(record: AttendanceRecord) {
        saveRecordedRawCharacterToCharacterModel(record: record)
        convertRawCharacterToViewData(isSmiling: recordedRawIsSmiling, isBlinkingLeft: recordedRawIsBlinkingLeft, isBlinkingRight: recordedRawIsBlinkingRight, lookAtPoint: recordedRawLookAtPoint, faceOrientation: recordedRawFaceOrientation, characterColor: recordedRawCharacterColor)
    }
    
    // 서버에 저장된 데이터 받아와서, CharacterModel 업데이트 시켜주기
    func saveRecordedRawCharacterToCharacterModel(record: AttendanceRecord) {
        recordedRawIsSmiling = record.rawIsSmiling
        recordedRawIsBlinkingLeft = record.rawIsBlinkingLeft
        recordedRawIsBlinkingRight = record.rawIsBlinkingRight
        recordedRawLookAtPoint = record.rawLookAtPoint
        recordedRawFaceOrientation = record.rawFaceOrientation
        recordedRawCharacterColor = record.rawCharacterColor
    }
    
    // 업데이트된 CharacterModel의 데이터를 받아와서, ViewData 업데이트 시켜주기
    func convertRawCharacterToViewData(isSmiling: Bool, isBlinkingLeft: Bool, isBlinkingRight: Bool, lookAtPoint: [Float], faceOrientation: [Float], characterColor: [Float] ) {
        recordedIsSmiling = isSmiling
        recordedIsBlinkingLeft = isBlinkingLeft
        recordedIsBlinkingRight = isBlinkingRight
        recordedLookAtPoint = SIMD3<Float>(lookAtPoint[0], lookAtPoint[1], lookAtPoint[2])
        recordedFaceOrientation = SIMD3<Float>(faceOrientation[0], faceOrientation[1], faceOrientation[2])
        recordedCharacterColor = characterColor
    }
    
    
}
