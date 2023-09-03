//
//  EyeInactive.swift
//  MC3
//
//  Created by 최민규 on 2023/07/16.
//

import SwiftUI

struct SceneSleepEye: View {
    
    @Binding var roomUser: User
    @State private var eyeNeighborViewModel = EyeNeighborViewModel()
    var body: some View {
       
        EyeView(isSmiling: false,
                isBlinkingLeft: true,
                isBlinkingRight: true,
                lookAtPoint: SIMD3<Float>(0.0, 0.0, 0.0),
                faceOrientation: SIMD3<Float>(0.0, -1.0, 0.0),
                bodyColor: eyeNeighborViewModel.bodyColor,
                eyeColor: eyeNeighborViewModel.eyeColor,
                cheekColor: eyeNeighborViewModel.cheekColor, isInactiveOrSleep: roomUser.userState == "inactive" || roomUser.userState == "sleep", isJumping: false)
        .onAppear {
            eyeNeighborViewModel.updateColors(roomUser: roomUser)
        }
    }
}

struct SceneSleepEye_Previews: PreviewProvider {
    @State static var roomUser: User = User.UTData[0][0]
    
    static var previews: some View {
        SceneSleepEye(roomUser: $roomUser)
    }
}
