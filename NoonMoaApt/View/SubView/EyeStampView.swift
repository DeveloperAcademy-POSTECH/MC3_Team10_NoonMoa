import SwiftUI

//다양한 상황, 뷰모델에 맞춰서 사용할 수 있는 하나의 눈 뷰.
struct EyeStampView: View {
    
    var isSmiling: Bool
    var isBlinkingLeft: Bool
    var isBlinkingRight: Bool
    var lookAtPoint: SIMD3<Float>
    var faceOrientation: SIMD3<Float>
    var bodyColor: LinearGradient
    var eyeColor: LinearGradient
    var cheekColor: LinearGradient
    
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
                                                    .strokeBorder(Color.black, lineWidth: 0.3)
                                                    .frame(width: eyeHeight, height: eyeHeight)
                                                    .offset(y: -eyeWidth / 2)
                                                
                                            )
                                            .clipShape(Ellipse())
                                            .opacity(isBlinkingRight ? 1 : 0)
                                    )
                                    .overlay(
                                        //눈 테두리
                                        Ellipse()
                                            .strokeBorder(Color.black, lineWidth: 0.3)                                    )
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
                                                    .strokeBorder(Color.black, lineWidth: 0.3)
                                                    .frame(width: eyeHeight, height: eyeHeight)
                                                    .offset(y: -eyeWidth / 2)
                                                
                                            )
                                            .clipShape(Ellipse())
                                            .opacity(isBlinkingLeft ? 1 : 0)
                                    )
                                    .overlay(
                                        //눈 테두리
                                        Ellipse()
                                            .strokeBorder(Color.black, lineWidth: 0.3)                                    )
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
                    
                    //몸통 테두리
                        .overlay(
                            Ellipse()
                                .strokeBorder(Color.black, lineWidth: 0.3)
                        )
                }
                .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
            }//GeometryReader
        }//ZStack
    }
}

struct EyeStampView_Previews: PreviewProvider {
    static var previews: some View {
        EyeStampView(isSmiling: false, isBlinkingLeft: false, isBlinkingRight: false, lookAtPoint: SIMD3<Float>(1.0, 1.0, 0.0), faceOrientation: SIMD3<Float>(0.5, 0.3, 0.0), bodyColor: LinearGradient.userBlue, eyeColor: LinearGradient.eyeBlue, cheekColor: LinearGradient.cheekRed)
    }
}
