//
//  LoginView.swift
//  MangMongApt
//
//  Created by kimpepe on 2023/07/15.
//

// LoginView
import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @StateObject var loginData = LoginViewModel(viewRouter: ViewRouter())
    //    @Binding var roomUser: User
    @State private var isBlinkingPlayed: Bool = false
    
    var body: some View {
        VStack {
            Spacer()
            EyeView(isSmiling: false,
                    isBlinkingLeft: isBlinkingPlayed,
                    isBlinkingRight: isBlinkingPlayed,
                    lookAtPoint: SIMD3<Float>(-0.9, 0.15, 0.0),
                    faceOrientation: SIMD3<Float>(1.0, 0.0, 0.0),
                    bodyColor: LinearGradient.userBlue,
                    eyeColor: LinearGradient.eyeBlue,
                    cheekColor: LinearGradient.cheekRed, isInactiveOrSleep: false, isJumping: false)
            .frame(width: 270, height: 270)
            .padding(.bottom, 24)
            .onAppear {
                Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
                    isBlinkingPlayed.toggle()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        isBlinkingPlayed.toggle()
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        isBlinkingPlayed.toggle()
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        isBlinkingPlayed.toggle()
                    }
                }
            }
            Text("눈모아 아파트에\n오신 걸 환영해요!")
                .font(.title2)
                .fontWeight(.bold)
            
            Spacer()
            
            SignInWithAppleButton { (request) in
                // 로그인 전에 Counter 문서가 없는 경우 초기화
                loginData.initializeCountersIfNotExist()
                
                loginData.nonce = loginData.randomNonceString()
                request.requestedScopes = [.email, .fullName]
                request.nonce = loginData.sha256(loginData.nonce)
                UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
            } onCompletion: { (result) in
                switch result {
                case .success(let user):
                    print("LoginView | SignInWithAppleButton | Login SUCCESS")
                    guard let credential = user.credential as? ASAuthorizationAppleIDCredential else {
                        print("error with firebase")
                        return
                    }
                    
                    loginData.authenticate(credential: credential)
                    // 임시방편, 미봉책
                    loginData.isLogInDone = true
                    viewRouter.nextView = .nickname
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            .frame(width: 280, height: 45)
            .cornerRadius(10)
            .padding(.bottom)
            
            Text("By signing up, you agree to our Terms of Service and acknowledge that our Privacy Policy applies to you.")
                .font(.caption)
                .padding(.bottom, UIScreen.main.bounds.width * 0.17)
                .padding(.horizontal, 32)
        }
        .ignoresSafeArea()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
