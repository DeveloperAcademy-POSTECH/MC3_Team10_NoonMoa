//
//  EyeInactive.swift
//  MC3
//
//  Created by 최민규 on 2023/07/16.
//

//내 눈과 이웃 눈에서 각각 inactive상태에 따라 각 인스턴스 값을 분기처리할 수 있지만, 그러면 추후 코드 수정이 오히려 용이하지 않을 것 같아서 하나의 Scene으로 분리하였습니다.
import SwiftUI

struct SceneInactiveEye: View {
    
    @Binding var roomUser: User
    @State private var eyeNeighborViewModel = EyeNeighborViewModel()
    var body: some View {
       
        EyeView(isSmiling: false,
                isBlinkingLeft: true,
                isBlinkingRight: true,
                lookAtPoint: SIMD3<Float>(0.0, 0.0, 0.0),
                faceOrientation: SIMD3<Float>(0.0, 0.0, 0.0),
                bodyColor: eyeNeighborViewModel.bodyColor,
                eyeColor: eyeNeighborViewModel.eyeColor,
                cheekColor: eyeNeighborViewModel.cheekColor, isInactiveOrSleep: roomUser.userState == "inactive" || roomUser.userState == "sleep", isJumping: false)
        .onAppear {
            eyeNeighborViewModel.updateColors(roomUser: roomUser)
        }
    }
}

struct SceneInactiveEye_Previews: PreviewProvider {
    @State static var roomUser: User = User.UTData[0][0]
    
    static var previews: some View {
        SceneInactiveEye(roomUser: $roomUser)
    }
}
