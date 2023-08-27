import SwiftUI

//다양한 상황, 뷰모델에 맞춰서 사용할 수 있는 하나의 눈 뷰.
struct EyeView: View {
    
    var isSmiling: Bool
    var isBlinkingLeft: Bool
    var isBlinkingRight: Bool
    var lookAtPoint: SIMD3<Float>
    var faceOrientation: SIMD3<Float>
    var bodyColor: LinearGradient
    var eyeColor: LinearGradient
    var cheekColor: LinearGradient
    var isInactiveOrSleep: Bool
    var isJumping: Bool
    
    var body: some View {
        ZStack {
            GeometryReader { geo in
                
                let bodyWidth = geo.size.width
                let bodyHeight = bodyWidth * 0.88
                let eyeWidth = bodyWidth * 0.25
                let eyeHeight = bodyHeight * 0.50
                let eyeBallWidth = eyeWidth * 0.50
                let eyeBallHeight = eyeHeight * 0.32
                let eyeDistance = bodyWidth * 0.01
                
                let eyeLimitFrameWidth = bodyWidth * 0.85
                let eyeLimitFrameHeight = bodyHeight * 0.75
                let eyeBallLimitFrameWidth = eyeWidth * 0.90
                let eyeBallLimitFrameHeight = eyeHeight * 0.70
                let eyeHorizontalLimit = (eyeLimitFrameWidth - eyeWidth * 2 - eyeDistance) / 2
                let eyeVerticalLimit =  (eyeLimitFrameHeight - eyeHeight) / 2
                let eyeBallHorizontalLimit = (eyeBallLimitFrameWidth - eyeBallWidth) / 2
                let eyeBallVerticalLimit = (eyeBallLimitFrameHeight - eyeBallHeight) / 2
                let eyeOffsetX = min(max(CGFloat(faceOrientation.x) * bodyWidth * 0.6, -eyeHorizontalLimit), eyeHorizontalLimit)
                let eyeOffsetY = -min(max(CGFloat(faceOrientation.y) * bodyWidth * 0.6, -eyeVerticalLimit), eyeVerticalLimit)
                let eyeBallOffsetX = min(max(CGFloat(lookAtPoint.x) * bodyWidth * 0.3, -eyeBallHorizontalLimit), eyeBallHorizontalLimit)
                let eyeBallOffsetY = -min(max(CGFloat(lookAtPoint.y) * bodyWidth * 0.6, -eyeBallVerticalLimit), eyeBallVerticalLimit)
                
                let shadowWidth = bodyWidth * 0.80
                let shadowHeight = bodyHeight * 0.15
                
                ZStack {
                    //그림자
                    Ellipse()
                        .fill(LinearGradient(colors: [Color(hex: 0x999999), Color(hex: 0x000000)], startPoint: .top, endPoint: .bottom))
                        .frame(width: shadowWidth, height: shadowHeight)
                        .offset(y: bodyHeight / 2)
                        .opacity(0.4)
                        .opacity(isJumping ? 0.5 : 1)
                        .scaleEffect(isJumping ? 0.8 : 1)
                        .offset(y: isJumping ? 6 : 0)
                    
                    //몸통
                    Ellipse()
                        .fill(bodyColor)
                        .frame(width: bodyWidth, height: bodyHeight)
                        .overlay(
                            HStack(spacing: eyeDistance) {
                                //왼쪽 눈
                                Ellipse()
                                    .fill(Color.white)
                                    .frame(width: eyeWidth, height: eyeHeight)
                                    .overlay(
                                        //눈알
                                        Circle()
                                            .fill(Color.black)
                                            .frame(width: eyeBallWidth, height: eyeBallHeight)
                                            .offset(x: eyeBallOffsetX, y: eyeBallOffsetY)
                                    )
                                    .clipShape(Ellipse())
                                    .opacity(isBlinkingRight ? 0 : 1)
                                    .overlay(
                                        //감은눈
                                        Ellipse()
                                            .fill(eyeColor)
                                            .frame(width: eyeWidth, height: eyeHeight)
                                            .overlay(
                                                Circle()
                                                    .stroke(Color.black, lineWidth: 1)
                                                    .frame(width: eyeHeight, height: eyeHeight)
                                                    .offset(y: -eyeWidth / 2)
                                                
                                            )
                                            .clipShape(Ellipse())
                                            .opacity(isBlinkingRight ? 1 : 0)
                                    )
                                    .overlay(
                                        //눈 테두리
                                        Ellipse()
                                            .stroke(Color.black, lineWidth: 1)
                                    )
                                    .overlay(
                                        //볼터치
                                        Ellipse()
                                            .fill(cheekColor)
                                            .frame(width: eyeWidth * 0.8, height: eyeWidth * 0.3)
                                            .opacity(0.2)
                                            .offset(x: -(eyeWidth * 0.2), y: eyeHeight * 0.5)
                                            .opacity(isSmiling ? 1 : 0)
                                    )
                                    .offset(x: eyeOffsetX, y: eyeOffsetY)
                                
                                //오른쪽 눈
                                Ellipse()
                                    .fill(Color.white)
                                    .frame(width: eyeWidth, height: eyeHeight)
                                    .overlay(
                                        //눈알
                                        Circle()
                                            .fill(Color.black)
                                            .frame(width: eyeBallWidth, height: eyeBallHeight)
                                            .offset(x: eyeBallOffsetX, y: eyeBallOffsetY)
                                    )
                                    .clipShape(Ellipse())
                                    .opacity(isBlinkingLeft ? 0 : 1)
                                    .overlay(
                                        //감은눈
                                        Ellipse()
                                            .fill(eyeColor)
                                            .frame(width: eyeWidth, height: eyeHeight)
                                            .overlay(
                                                Circle()
                                                    .stroke(Color.black, lineWidth: 1)
                                                    .frame(width: eyeHeight, height: eyeHeight)
                                                    .offset(y: -eyeWidth / 2)
                                                
                                            )
                                            .clipShape(Ellipse())
                                            .opacity(isBlinkingLeft ? 1 : 0)
                                    )
                                    .overlay(
                                        //눈 테두리
                                        Ellipse()
                                            .stroke(Color.black, lineWidth: 1)
                                    )
                                    .overlay(
                                        //볼터치
                                        Ellipse()
                                            .fill(cheekColor)
                                            .frame(width: eyeWidth * 0.8, height: eyeWidth * 0.3)
                                            .frame(width: eyeWidth * 0.8, height: eyeWidth * 0.3)
                                            .opacity(0.2)
                                            .offset(x: (eyeWidth * 0.2), y: eyeHeight * 0.5)
                                            .opacity(isSmiling ? 1 : 0)
                                    )
                                    .offset(x: eyeOffsetX, y: eyeOffsetY)
                            }
                        )
                        .overlay(
                            //inactive 할 때 어두워지는 효과
                            Ellipse()
                                .fill(Color.black)
                                .opacity(0.2)
                                .frame(width: bodyWidth, height: bodyHeight)
                                .opacity(isInactiveOrSleep ? 1 : 0)
                        )
                        .clipShape(Ellipse())
                    //몸통 테두리
                        .overlay(
                            Ellipse()
                                .stroke(Color.black, lineWidth: 1)
                        )
                        .offset(y: isJumping ? -10 : 0)
                }
                .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
            }//GeometryReader
            .padding()
        }//ZStack
    }
}


struct TestView: View {
    @EnvironmentObject var eyeViewController: EyeViewController
    @EnvironmentObject var characterViewModel: CharacterViewModel

    var body: some View {
        
        EyeView(isSmiling: eyeViewController.eyeMyViewModel.isSmiling,
                isBlinkingLeft: eyeViewController.eyeMyViewModel.isBlinkingLeft,
                isBlinkingRight: eyeViewController.eyeMyViewModel.isBlinkingRight,
                lookAtPoint: eyeViewController.eyeMyViewModel.lookAtPoint,
                faceOrientation: eyeViewController.eyeMyViewModel.faceOrientation, bodyColor: characterViewModel.characterRecordViewData.bodyColor, eyeColor: characterViewModel.characterRecordViewData.eyeColor, cheekColor: characterViewModel.characterRecordViewData.cheekColor, isInactiveOrSleep: false, isJumping: false)
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
            .environmentObject(EyeViewController())
            .environmentObject(CharacterViewModel())
    }
}
//
////ARKit 기능 테스트를 위한 뷰 입니다. 사용하지 않지만 지우지 말아주세요.
//struct EyeTestView: View {
//
//    var isSmiling: Bool
//    var isBlinkingLeft: Bool
//    var isBlinkingRight: Bool
//    var lookAtPoint: SIMD3<Float>
//    var faceOrientation: SIMD3<Float>
//
//    var body: some View {
//        ZStack {
//            VStack {
//                Text(isSmiling ? "Smiling 😄" : "Not Smiling 😐")
//                    .padding()
//                    .foregroundColor(isSmiling ? .green : .red)
//                    .background(RoundedRectangle(cornerRadius: 25).fill(.regularMaterial))
//                Button(action: {EyeViewController().resetFaceAnchor()}) {
//                    Text("reset")
//                        .padding()
//                        .foregroundColor(.black)
//                        .background(RoundedRectangle(cornerRadius: 25).fill(.regularMaterial))
//
//                }
//                Text("lookAtPoint x: \(Int(round(lookAtPoint.x * 1000))), y: \(Int(round(lookAtPoint.y * 1000))), z: \(Int(round(lookAtPoint.z * 1000)))")
//                Text("faceOrientation x: \(Int(round(faceOrientation.x * 1000))), y: \(Int(round(faceOrientation.y * 1000))), z: \(Int(round(faceOrientation.z * 1000)))")
//                Text("x: \(CGFloat(Int(round(faceOrientation.x * 100)))), y: \(-CGFloat(Int(round(faceOrientation.y * 100))))")
//                Spacer()
//            }
//
//            GeometryReader { geo in
//
//                let bodyWidth = geo.size.width
//                let bodyHeight = bodyWidth * 0.88
//                let eyeWidth = bodyWidth * 0.25
//                let eyeHeight = bodyHeight * 0.50
//                let eyeBallWidth = eyeWidth * 0.50
//                let eyeBallHeight = eyeHeight * 0.32
//                let eyeDistance = bodyWidth * 0.01
//
//                let eyeLimitFrameWidth = bodyWidth * 0.85
//                let eyeLimitFrameHeight = bodyHeight * 0.75
//                let eyeBallLimitFrameWidth = eyeWidth * 0.90
//                let eyeBallLimitFrameHeight = eyeHeight * 0.70
//                let eyeHorizontalLimit = (eyeLimitFrameWidth - eyeWidth * 2 - eyeDistance) / 2
//                let eyeVerticalLimit =  (eyeLimitFrameHeight - eyeHeight) / 2
//                let eyeBallHorizontalLimit = (eyeBallLimitFrameWidth - eyeBallWidth) / 2
//                let eyeBallVerticalLimit = (eyeBallLimitFrameHeight - eyeBallHeight) / 2
//                let eyeOffsetX = min(max(CGFloat(faceOrientation.x) * bodyWidth * 0.6, -eyeHorizontalLimit), eyeHorizontalLimit)
//                let eyeOffsetY = -min(max(CGFloat(faceOrientation.y) * bodyWidth * 0.6, -eyeVerticalLimit), eyeVerticalLimit)
//                let eyeBallOffsetX = min(max(CGFloat(lookAtPoint.x) * bodyWidth * 0.3, -eyeBallHorizontalLimit), eyeBallHorizontalLimit)
//                let eyeBallOffsetY = -min(max(CGFloat(lookAtPoint.y) * bodyWidth * 0.6, -eyeBallVerticalLimit), eyeBallVerticalLimit)
//
//                let shadowWidth = bodyWidth * 0.80
//                let shadowHeight = bodyHeight * 0.15
//
//                ZStack {
//                    //그림자
//                    Ellipse()
//                        .fill(LinearGradient(colors: [Color(hex: 0x999999), Color(hex: 0x000000)], startPoint: .top, endPoint: .bottom))
//                        .frame(width: shadowWidth, height: shadowHeight)
//                        .offset(y: bodyHeight / 2)
//                        .opacity(0.4)
//
//                    //몸통
//                    Ellipse()
//                        .fill(LinearGradient(colors: [Color(hex: 0xD9D9D9), Color(hex: 0xF2F2F2)], startPoint: .top, endPoint: .bottom))
//                        .overlay(
//                            Ellipse()
//                                .stroke(Color.black, lineWidth: 1)
//                        )
//                        .frame(width: bodyWidth, height: bodyHeight)
//                        .overlay(
//                            HStack(spacing: eyeDistance) {
//                                //왼쪽 눈
//                                Ellipse()
//                                    .fill(Color.white)
//                                    .overlay(
//                                        Ellipse()
//                                            .stroke(Color.black, lineWidth: 1)
//                                    )
//                                    .frame(width: eyeWidth, height: eyeHeight)
//                                    .overlay(
//                                        Circle()
//                                            .fill(Color.black)
//                                            .frame(width: eyeBallWidth, height: eyeBallHeight)
//                                            .offset(x: eyeBallOffsetX, y: eyeBallOffsetY)
//                                    )
//                                    .clipShape(Ellipse())
//                                    .offset(x: eyeOffsetX, y: eyeOffsetY)
//                                    .opacity(isBlinkingRight ? 0 : 1)
//
//                                //오른쪽 눈
//                                Ellipse()
//                                    .fill(Color.white)
//                                    .overlay(
//                                        Ellipse()
//                                            .stroke(Color.black, lineWidth: 1)
//                                    )
//                                    .frame(width: eyeWidth, height: eyeHeight)
//                                    .overlay(
//                                        Circle()
//                                            .fill(Color.black)
//                                            .frame(width: eyeBallWidth, height: eyeBallHeight)
//                                            .offset(x: eyeBallOffsetX, y: eyeBallOffsetY)
//                                    )
//                                    .clipShape(Ellipse())
//                                    .offset(x: eyeOffsetX, y: eyeOffsetY)
//                                    .opacity(isBlinkingLeft ? 0 : 1)
//                            }
//                        )
//                        .clipShape(Ellipse())
//                }
//                .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
//            }//GeometryReader
//            .padding()
//        }//ZStack
//    }
//}
