//
//  CustomViewModel.swift
//  NoonMoaApt
//
//  Created by 최민규 on 2023/07/31.
//

import Foundation
import SwiftUI

class CustomViewModel: ObservableObject {
    @Published var pickerValue: Double = 0.25
    
    @Published var currentCharacterColor: Color = Color.userPink
    @Published var currentBodyColor: LinearGradient = LinearGradient.userPink
    @Published var currentEyeColor: LinearGradient = LinearGradient.eyePink
    @Published var currentCheekColor: LinearGradient = LinearGradient.cheekRed
    
    //테마컬러 4개 넣으면 변수 자동 업데이트
    let color1: Color = Color.userBlue
    let color2: Color = Color.userPink
    let color3: Color = Color.userYellow
    let color4: Color = Color.userCyan
    
    //Bright
    //        let color1: Color = Color.userThemeGreen1
    //        let color2: Color = Color.userThemeBlue1
    //        let color3: Color = Color.userThemePink1
    //        let color4: Color = Color.userThemeYellow1
    
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
        self.currentCharacterColor = Color(red: yR, green: yG, blue: yB)
        //기준컬러에서 RGB 각각 50씩 올려서 그라디언트 생성
        self.currentBodyColor = LinearGradient(colors: [Color(red: min(max(((yR * 255 + 50) / 255), 0), 1), green: min(max(((yG * 255 + 50) / 255), 0), 1), blue: min(max(((yB * 255 + 50) / 255), 0), 1)), Color(red: yR, green: yG, blue: yB)], startPoint: .top, endPoint: .bottom)
        self.currentEyeColor = LinearGradient(colors: [Color(red: min(max(((yR * 255 + 50) / 255), 0), 1), green: min(max(((yG * 255 + 50) / 255), 0), 1), blue: min(max(((yB * 255 + 50) / 255), 0), 1)), Color(red: yR, green: yG, blue: yB)], startPoint: .top, endPoint: .bottom)
        
        return [Float(yR), Float(yG), Float(yB)]
    }
    //TODO: 저장된 값을 불러올 때 변환하는거는 안넣은듯?
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
//extension Color {
//    var rgba: (red: Double, green: Double, blue: Double, alpha: Double) {
//        let uiColor = UIColor(self)
//        var red: CGFloat = 0
//        var green: CGFloat = 0
//        var blue: CGFloat = 0
//        var alpha: CGFloat = 0
//        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
//
//        return (Double(red), Double(green), Double(blue), Double(alpha))
//    }
//}

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

