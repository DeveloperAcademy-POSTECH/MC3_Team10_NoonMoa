//
//  EyeMyView.swift
//  NoonMoaApt
//
//  Created by 최민규 on 2023/07/25.
//

import SwiftUI

struct SceneMyEye: View {
    @Binding var roomUser: User
    @EnvironmentObject var environmentViewModel: EnvironmentViewModel
    @EnvironmentObject var characterViewModel: CharacterViewModel
    @EnvironmentObject var eyeNeighborViewModel: EyeNeighborViewModel
    var isJumping: Bool

    var body: some View {
        
        EyeView(isSmiling: eyeNeighborViewModel.isSmiling,
                isBlinkingLeft: eyeNeighborViewModel.isBlinkingLeft,
                isBlinkingRight: eyeNeighborViewModel.isBlinkingRight,
                lookAtPoint: eyeNeighborViewModel.lookAtPoint,
                faceOrientation: eyeNeighborViewModel.faceOrientation,
                bodyColor: characterViewModel.characterViewData.bodyColor,
                eyeColor: characterViewModel.characterViewData.eyeColor, cheekColor: characterViewModel.characterViewData.cheekColor, isInactiveOrSleep: false, isJumping: roomUser.isJumping)
        .onAppear {
            eyeNeighborViewModel.updateColors(roomUser: roomUser)
            //이웃 눈의 랜덤한 움직임 함수 실행
            withAnimation(.linear(duration: 3)) {
                eyeNeighborViewModel.randomEyeMove(roomUser: roomUser)
            }
            Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { timer in
                DispatchQueue.main.async {
                    withAnimation(.linear(duration: 3)) {
                        eyeNeighborViewModel.randomEyeMove(roomUser: roomUser)
                    }
                }
            }
        }
    }
}

//
//
//struct SceneMyEye_Previews: PreviewProvider {
//    static var previews: some View {
//        SceneMyEye()
//    }
//}
