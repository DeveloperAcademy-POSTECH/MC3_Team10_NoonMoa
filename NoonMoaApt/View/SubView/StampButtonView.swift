//
//  StampButton.swift
//  MC3
//
//  Created by Seohyun Hwang on 2023/07/20.
//

import SwiftUI

struct StampButtonView: View {
    
    @StateObject var environmentViewModel = EnvironmentViewModel()
    
    var skyColor: LinearGradient
    var skyImage: Image
    var isSmiling: Bool
    var isBlinkingLeft: Bool
    var isBlinkingRight: Bool
    var lookAtPoint: SIMD3<Float>
    var faceOrientation: SIMD3<Float>
    var bodyColor: LinearGradient
    var eyeColor: LinearGradient
    var cheekColor: LinearGradient
    var borderColor: Color
    
    var body: some View {
        
        GeometryReader { geo in
            ZStack {
                Circle()
                    .fill(skyColor)
                    .shadow(color: Color.gray.opacity(0.5), radius: 4, x: 0, y: 2)
                
                skyImage
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 50))
                
                EyeStampView(isSmiling: isSmiling, isBlinkingLeft: isBlinkingLeft, isBlinkingRight: isBlinkingRight, lookAtPoint: lookAtPoint, faceOrientation: faceOrientation, bodyColor: bodyColor, eyeColor: eyeColor, cheekColor: cheekColor)
                    .frame(width: geo.size.width * 0.7)
                
                Circle()
                    .strokeBorder(borderColor, lineWidth: 1)
                
            }//Zstack
            .frame(width: geo.size.width, height: geo.size.width, alignment: .center)
            .offset(y: geo.size.height / 2 - geo.size.width / 2)
        }//GeometryReader
    }
}

struct StampButtonView_Previews: PreviewProvider {
    static var previews: some View {
        StampButtonView(skyColor: LinearGradient.sky.clearMorning, skyImage: Image.assets.stampSmall.clearMorning, isSmiling: false, isBlinkingLeft: false, isBlinkingRight: false, lookAtPoint: SIMD3<Float>(0.0, 0.0, 0.0), faceOrientation: SIMD3<Float>(0.0, 0.0, 0.0), bodyColor: LinearGradient.userBlue, eyeColor: LinearGradient.eyeBlue, cheekColor: LinearGradient.cheekRed, borderColor: Color.stampBorder.clearMorning)
            .environmentObject(EnvironmentViewModel())
    }
}
