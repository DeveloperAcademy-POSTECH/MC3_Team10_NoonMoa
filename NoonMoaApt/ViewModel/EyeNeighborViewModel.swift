//
//  EyeNeighborViewModel.swift
//  NoonMoaApt
//
//  Created by 최민규 on 2023/07/26.
//
import SwiftUI

//TODO: 아직 서버에서는 상대방의 움직임을 받아오는게 없으므로, 초기화 값을 지정해 주었다. 나중에는 이 뷰모델에, 서버에서 받은 값을 각 값에 뿌려주는 func를 작성한다.
struct EyeNeighborViewModel {
    var isSmiling: Bool = false
    var isBlinkingLeft: Bool = false
    var isBlinkingRight: Bool = false
    var lookAtPoint: SIMD3 = SIMD3<Float>(0.0, 0.0, 0.0)
    var faceOrientation: SIMD3 = SIMD3<Float>(0.0, 0.0, 0.0)
    var characterColor: Color = .userBlue
    var bodyColor: LinearGradient = .userBlue
    var eyeColor: LinearGradient = .eyeBlue
    var cheekColor: LinearGradient = .cheekRed
    
    mutating func updateColors(roomUser: User) {
        //TODO: 여기 조건문이 약간 어색함
        if let colorArray = roomUser.characterColor, colorArray.count >= 3 {
            let r = Double(roomUser.characterColor?[0] ?? 0)
            let g = Double(roomUser.characterColor?[1] ?? 0)
            let b = Double(roomUser.characterColor?[2] ?? 0)
            
            characterColor = Color(red: r, green: g, blue: b)
            bodyColor = LinearGradient(colors: [Color(red: min(max(((r * 255 + 50) / 255), 0), 1), green: min(max(((g * 255 + 50) / 255), 0), 1), blue: min(max(((b * 255 + 50) / 255), 0), 1)), Color(red: r, green: g, blue: b)], startPoint: .top, endPoint: .bottom)
            eyeColor = LinearGradient(colors: [Color(red: min(max(((r * 255 + 50) / 255), 0), 1), green: min(max(((g * 255 + 50) / 255), 0), 1), blue: min(max(((b * 255 + 50) / 255), 0), 1)), Color(red: r, green: g, blue: b)], startPoint: .top, endPoint: .bottom)
        } else {
            characterColor = .userBlue
            bodyColor = .userBlue
            eyeColor = .eyeBlue
        }
    }
    
    //이웃 눈의 랜덤한 움직임 함수
    mutating func randomEyeMove(roomUser: User) {
        
        switch roomUser.roomId {
        case "1", "3", "5", "8", "11":
            faceOrientation = SIMD3<Float>(Float(Double.random(in: -1.0...1.0)), Float(Double.random(in: -1.0...1.0)), 0.0)
            lookAtPoint = SIMD3<Float>(Float(Double.random(in: -1.0...1.0)), Float(Double.random(in: -1.0...1.0)), 0.0)
        case "2", "4", "9":
            faceOrientation = SIMD3<Float>(Float(Double.random(in: -1.0...1.0)), Float(Double.random(in: -1.0...1.0)), 0.0)
            lookAtPoint = SIMD3<Float>(Float(Double.random(in: -1.0...1.0)), Float(Double.random(in: -1.0...1.0)), 0.0)
        case "6", "7", "10", "12":
            faceOrientation = SIMD3<Float>(Float(Double.random(in: -1.0...1.0)), Float(Double.random(in: -1.0...1.0)), 0.0)
            lookAtPoint = SIMD3<Float>(Float(Double.random(in: -1.0...1.0)), Float(Double.random(in: -1.0...1.0)), 0.0)
        default:
            break
        }
        
    }
}
