//
//  CharacterViewModel.swift
//  NoonMoaApt
//
//  Created by 최민규 on 2023/08/27.
//

import Foundation
import SwiftUI

class CharacterViewModel: ObservableObject {
    
    @Published var character: CharacterRecord?
    @Published var characterViewData: CharacterRecordViewData = CharacterRecordViewData(isSmiling: true, isBlinkingLeft: false, isBlinkingRight: true, lookAtPoint: SIMD3(1,0,0), faceOrientation: SIMD3(1,0,0), characterColor: .userBlue, bodyColor: .userYellow, eyeColor: .eyeYellow, cheekColor: .cheekRed)
    
    var recordedCharacter: CharacterRecord = CharacterRecord(rawIsSmiling: false, rawIsBlinkingLeft: false, rawIsBlinkingRight: false, rawLookAtPoint: [0,0,0], rawFaceOrientation: [0,0,0], rawCharacterColor: [0,0,0])
    var recordedCharacterViewData: CharacterRecordViewData = CharacterRecordViewData(isSmiling: false, isBlinkingLeft: false, isBlinkingRight: false, lookAtPoint: SIMD3(0,0,0), faceOrientation: SIMD3(0,0,0), characterColor: .userBlue, bodyColor: .userBlue, eyeColor: .eyeBlue, cheekColor: .cheekRed)
   
    @Published var pickerValue: Double = 0.25
    //캐릭터 테마컬러 그라데이션
    let color1: Color = Color.userBlue
    let color2: Color = Color.userPink
    let color3: Color = Color.userYellow
    let color4: Color = Color.userCyan

    // MARK: - 업로드용 변환 -
    
    //현재 뷰에서 참조하고 있던 뷰 데이터를 저장에 사용되는 rawData 포맷으로 변형하기 위한 함수이다.
    //해당 함수는 AttendanceViewModel에서 실행시키며, CharacterViewModel().characterRecord를 서버에 저장하게 된다.
    func convertCharacterToRawData() {
        let rawLookAtPoint: [Float] = [characterViewData.lookAtPoint[0],characterViewData.lookAtPoint[1],characterViewData.lookAtPoint[2]]
        let rawFaceOrientation: [Float] = [characterViewData.faceOrientation[0], characterViewData.faceOrientation[1], characterViewData.faceOrientation[2]]
        let rawCharacterColor: [Float] = [characterViewData.characterColor.toArray[0], characterViewData.characterColor.toArray[1], characterViewData.characterColor.toArray[2]]
        character = CharacterRecord(rawIsSmiling: characterViewData.isSmiling, rawIsBlinkingLeft: characterViewData.isBlinkingLeft, rawIsBlinkingRight: characterViewData.isBlinkingRight, rawLookAtPoint: rawLookAtPoint, rawFaceOrientation: rawFaceOrientation, rawCharacterColor: rawCharacterColor)
        print("character | \(character)")
    }
    
    // MARK: - 다운로드 후 변환 -
    
    func convertRecordedDataToCharacterViewData() {
        convertRawColorToCharacterColor(record: recordedCharacter)
        recordedCharacterViewData = CharacterRecordViewData(isSmiling: recordedCharacter.rawIsSmiling, isBlinkingLeft: recordedCharacter.rawIsBlinkingLeft, isBlinkingRight: recordedCharacter.rawIsBlinkingRight, lookAtPoint: SIMD3(recordedCharacter.rawLookAtPoint[0], recordedCharacter.rawLookAtPoint[1], recordedCharacter.rawLookAtPoint[2]), faceOrientation: SIMD3(recordedCharacter.rawFaceOrientation[0], recordedCharacter.rawFaceOrientation[1], recordedCharacter.rawFaceOrientation[2]), characterColor: self.recordedCharacterViewData.characterColor, bodyColor: self.recordedCharacterViewData.bodyColor, eyeColor: self.recordedCharacterViewData.eyeColor, cheekColor: .cheekRed)
    }
}

extension CharacterViewModel {
    
    func pickerValueToCharacterColor(value: Double) -> [Float] {
        let (r1, g1, b1) = (Double(color1.toArray[0]), Double(color1.toArray[1]), Double(color1.toArray[2]))
        let (r2, g2, b2) = (Double(color2.toArray[0]), Double(color2.toArray[1]), Double(color2.toArray[2]))
        let (r3, g3, b3) = (Double(color3.toArray[0]), Double(color3.toArray[1]), Double(color3.toArray[2]))
        let (r4, g4, b4) = (Double(color4.toArray[0]), Double(color4.toArray[1]), Double(color4.toArray[2]))
        
        let x = value
        var yR = 0.0
        var yG = 0.0
        var yB = 0.0
        
        if x >= 0 && x < 0.33 {
            yR = r1 + ((r2 - r1) / 0.33) * x
            yG = g1 + ((g2 - g1) / 0.33) * x
            yB = b1 + ((b2 - b1) / 0.33) * x
        } else if x >= 0.33 && x < 0.66 {
            yR = r2 + ((r3 - r2) / 0.33) * (x - 0.33)
            yG = g2 + ((g3 - g2) / 0.33) * (x - 0.33)
            yB = b2 + ((b3 - b2) / 0.33) * (x - 0.33)
        } else if x >= 0.66 && x <= 1 {
            yR = r3 + ((r4 - r3) / 0.34) * (x - 0.66)
            yG = g3 + ((g4 - g3) / 0.34) * (x - 0.66)
            yB = b3 + ((b4 - b3) / 0.34) * (x - 0.66)
        }
        
        //기준컬러 지정
        self.characterViewData.characterColor = Color(red: yR, green: yG, blue: yB)
        //기준컬러에서 RGB 각각 50씩 올려서 그라디언트 생성
        self.characterViewData.bodyColor = LinearGradient(colors: [Color(red: min(max(((yR * 255 + 50) / 255), 0), 1), green: min(max(((yG * 255 + 50) / 255), 0), 1), blue: min(max(((yB * 255 + 50) / 255), 0), 1)), Color(red: yR, green: yG, blue: yB)], startPoint: .top, endPoint: .bottom)
        self.characterViewData.eyeColor = LinearGradient(colors: [Color(red: min(max(((yR * 255 + 50) / 255), 0), 1), green: min(max(((yG * 255 + 50) / 255), 0), 1), blue: min(max(((yB * 255 + 50) / 255), 0), 1)), Color(red: yR, green: yG, blue: yB)], startPoint: .top, endPoint: .bottom)
        
        return [Float(yR), Float(yG), Float(yB)]
    }
    
    func convertRawColorToCharacterColor(record: CharacterRecord) {
        let yR = Double(record.rawCharacterColor[0])
        let yG = Double(record.rawCharacterColor[1])
        let yB = Double(record.rawCharacterColor[2])

        self.recordedCharacterViewData.characterColor =  Color(red: yR, green: yG, blue: yB)
       self.recordedCharacterViewData.bodyColor = LinearGradient(colors: [Color(red: min(max(((yR * 255 + 50) / 255), 0), 1), green: min(max(((yG * 255 + 50) / 255), 0), 1), blue: min(max(((yB * 255 + 50) / 255), 0), 1)), Color(red: yR, green: yG, blue: yB)], startPoint: .top, endPoint: .bottom)
        self.recordedCharacterViewData.eyeColor = LinearGradient(colors: [Color(red: min(max(((yR * 255 + 50) / 255), 0), 1), green: min(max(((yG * 255 + 50) / 255), 0), 1), blue: min(max(((yB * 255 + 50) / 255), 0), 1)), Color(red: yR, green: yG, blue: yB)], startPoint: .top, endPoint: .bottom)
    }
}

extension Color {
    var toArray: [Float] {
        let uiColor = UIColor(self)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return [Float(red), Float(green), Float(blue)]
    }
}

extension Array where Element == Float {
    var toColor: Color {
        guard count == 3 else {
            return .clear
        }
        
        let red = Double(self[0])
        let green = Double(self[1])
        let blue = Double(self[2])
        
        return Color(red: red, green: green, blue: blue)
    }
}
