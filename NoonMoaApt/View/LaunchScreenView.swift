//
//  launchScreenView.swift
//  NoonMoaApt
//
//  Created by kimpepe on 2023/07/26.
//

import SwiftUI
import Combine
import Firebase
import FirebaseFirestore
import FirebaseAuth

struct launchScreenView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var environmentModel: EnvironmentModel
    @State private var isViewActive: Bool = false
    @AppStorage("isOnboardingDone") var isOnboardingDone: Bool = false
    @AppStorage("isLogInDone") var isLogInDone: Bool = false
    
    private var firestoreManager: FirestoreManager {
        FirestoreManager.shared
    }
    private var db: Firestore {
        firestoreManager.db
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                LinearGradient.sky.clearMorning
                VStack {
                    Spacer()
                    Image("Splash")
                        .resizable()
                        .scaledToFit()
                        .ignoresSafeArea()
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                // 로그인 했을 때, 기존 계정이 있는지 확인하는 로직
                                // 기존에 계정이 있으면, 자동 로그인 하고 AptView로 이동
                                // 기존에 계정이 없으면, LoginView로 이동
                                
                                if isLogInDone {
                                    print("isLogInDone")
                                    if let user = Auth.auth().currentUser {
                                        let userRef = db.collection("User").document(user.uid)
                                        userRef.getDocument { (document, error) in
                                            if let document = document, document.exists {
                                                if let userData = document.data(), let userState = userData["userState"] as? String {
                                                    DispatchQueue.main.async {
                                                        print("AppDelegate | application | userState: \(userState)")
                                                        if userState == UserState.sleep.rawValue {
                                                            self.viewRouter.nextView = .attendance
                                                        } else {
                                                            self.viewRouter.nextView = .apt
                                                        }
                                                    }
                                                }
                                            } else {
                                                print("Document does not exist")
                                            }
                                        }
                                    }
                                }
                                else {
                                    // No user is signed in, go to OnBoardingView
                                    print("No user is signed in.")
                                    DispatchQueue.main.async {
                                        if isOnboardingDone {
                                            self.viewRouter.nextView = .login
                                        } else {
                                            self.viewRouter.nextView = .onBoarding
                                        }
                                    }
                                }
                            }
                    }
                }
                
                LottieView(name: "Splash", animationSpeed: 0.5
                )
                    }
            .ignoresSafeArea()
                }
        }
    }
//}

struct launchScreenView_Previews: PreviewProvider {
    static var previews: some View {
        launchScreenView().environmentObject(ViewRouter())
    }
}
