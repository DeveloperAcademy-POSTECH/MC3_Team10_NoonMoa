//
//  StampButton.swift
//  MC3
//
//  Created by Seohyun Hwang on 2023/07/20.
//

import SwiftUI

struct StampButtonView: View {
    
    @StateObject var weather: WeatherViewModel = WeatherViewModel()
    @StateObject var time: TimeViewModel = TimeViewModel()

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
                EyeView(isSmiling: isSmiling, isBlinkingLeft: isBlinkingLeft, isBlinkingRight: isBlinkingRight, lookAtPoint: lookAtPoint, faceOrientation: faceOrientation, bodyColor: bodyColor, eyeColor: eyeColor, cheekColor: cheekColor)
                    .frame(width: geo.size.width * 0.7)
                Circle()
                    .strokeBorder(Color.black, lineWidth: 1)
                
            }//Zstack
            .frame(width: geo.size.width, height: geo.size.width, alignment: .center)
            .offset(y: geo.size.height / 2 - geo.size.width / 2)
        }//GeometryReader
    }
}

struct StampButtonView_Previews: PreviewProvider {
    static var previews: some View {
        StampButtonView(skyColor: Color.sky.clearDay, skyImage: Image.assets.circleStamp.clearDay, isSmiling: false, isBlinkingLeft: false, isBlinkingRight: false, lookAtPoint: SIMD3<Float>(0.0, 0.0, 0.0), faceOrientation: SIMD3<Float>(0.0, 0.0, 0.0), bodyColor: LinearGradient.userBlue, eyeColor: LinearGradient.eyeBlue, cheekColor: LinearGradient.cheekRed)
            .environmentObject(WeatherViewModel())
            .environmentObject(TimeViewModel())
    }
}
