//
//  SceneButtons.swift
//  MC3
//
//  Created by 최민규 on 2023/07/16.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct SceneButtons: View {
    
    @Binding var roomUser: User
    
    @State private var lastActiveToggle: Bool = false
    @State private var lastWakenTimeToggle: Bool = false
    @State private var lastWakenTime: Int = 0
    let wakeTimeLimit = 20
    
    @EnvironmentObject var characterViewModel: CharacterViewModel
    
    let pushNotiController = PushNotiController()
    
    var body: some View {
        
        ZStack {
            Color.clear
            
            switch roomUser.userState {
            case "sleep":
                Button(action: {
                    lastActiveToggle = true
                }) {
                    Color.clear
                        .cornerRadius(8)
                }
                //깨우기버튼
                ZStack {
                    
                    CustomBlurView(effect: .systemUltraThinMaterialLight) { view in }
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .opacity(0.5)

                    Color.black
                        .cornerRadius(8)
                        .opacity(0.3)
                    
                        Button(action: {
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                            }
                            lastActiveToggle = false
                            lastWakenTimeToggle = true
                            UserDefaults.standard.set(Date(), forKey: "\(String(describing: roomUser.roomId))")
                            if roomUser.token.count > 1 {
                                // push 알림 보내기
                                DispatchQueue.global(qos: .userInteractive).async {
                                    print("SceneButtons | roomUser \(roomUser)")
                                    pushNotiController.requestPushNotification(to: roomUser.id!)
                                }
                            }
                        }) {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white)
                                .opacity(0.8)
                                .frame(width: 80, height: 36)
                                .overlay(
                                    Text("깨우기")
                                        .foregroundColor(.black)
                                        .font(.body)
                                        .bold()
                                )
                        }
                    Button(action: {
                        lastActiveToggle = false
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        }) {
                            ZStack {
                                Image(systemName: "circle.fill")
                                    .foregroundColor(.white)
                                    .font(.title2.bold())
                                    .shadow(color: .gray, radius: 4, y: 4)
                                
                                Image(systemName: "xmark")
                                    .foregroundColor(.black)
                                    .font(.caption.bold())
                            }
                    }.offset(x: 48, y: -36)
                }//ZStack
                .opacity(lastActiveToggle ? 1 : 0)
                
                
                //깨우는 중...
                ZStack {
                    Color.black
                        .cornerRadius(8)
                        .opacity(0.3)
                    
                    VStack {
                        Text("깨우는 중...")
                            .foregroundColor(.white)
                            .font(.caption)
                            .bold()
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 8)
                                .foregroundColor(.black)
                                .opacity(0.5)
                                .frame(width: 64, height: 8)
                            
                            RoundedRectangle(cornerRadius: 8)
                                .foregroundColor(.white)
                                .frame(width: CGFloat(lastWakenTime * 64 / wakeTimeLimit), height: 8)
                        }
                    }//VStack
                    
                    Button(action: {
                        
                    }) {
                        Color.clear
                            .cornerRadius(8)
                    }
                }//ZStack
                .opacity(lastWakenTimeToggle ? 1 : 0)
                .onAppear {
                    Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                        if let storedDate = UserDefaults.standard.value(forKey: "\(String(describing: roomUser.roomId))") as? Date {
                            lastWakenTimeToggle = true
                            DispatchQueue.main.async {
                                withAnimation(.linear(duration: 1)) {
                                    lastWakenTime = Calendar.current.dateComponents([.second], from: storedDate, to: Date()).second ?? 0
                                }
                                if lastWakenTime >= wakeTimeLimit {
                                    lastWakenTimeToggle = false
                                    lastWakenTime = 0
                                    UserDefaults.standard.removeObject(forKey: "\(String(describing: roomUser.roomId))")
                                } else {
                                    print(lastWakenTime)
                                }
                            }
                        }
                    }
                    
                }
                
            case "active":
                Button(action: {
                    
                    //TODO: 더미데이터일 경우 실행하지않기_임시로 분기처리
                    if roomUser.token.count > 1 {
                        
                        // push 알림 보내기
                        DispatchQueue.global(qos: .userInteractive).async {
                            print("SceneButtons | roomUser \(roomUser)")
                            pushNotiController.requestPushNotification(to: roomUser.id!)
                        }
                    }
                    //인터랙션 실행문
                    DispatchQueue.main.async {
                        withAnimation(.easeOut(duration: 0.2)) {
                            roomUser.isJumping = true
                        }
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        withAnimation(.easeIn(duration: 0.2)) {
                            roomUser.isJumping = false
                        }
                    }
                    //인터랙션 실행문
                    roomUser.clicked = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        roomUser.clicked = false
                    }
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    
                }) {
                    if roomUser.id == Auth.auth().currentUser?.uid {
                        Color.clear
                            .cornerRadius(8)
                            .particleEffect(systemImage: "suit.heart.fill",
                                            font: .title3,
                                            status:  roomUser.clicked,
                                            tint: characterViewModel.characterViewData.characterColor)
                    } else {
                        Color.clear
                            .cornerRadius(8)
                            .particleEffect(systemImage: "suit.heart.fill",
                                            font: .title3,
                                            status: roomUser.clicked,
                                            tint:   roomUser.characterColor?.toColor ?? Color.pink)
                    }
                }
                
            case "inactive":
                Button(action: {
                    if roomUser.token.count > 1 {
                        
                        // push 알림 보내기
                        DispatchQueue.global(qos: .userInteractive).async {
                            print("SceneButtons | roomUser \(roomUser)")
                            pushNotiController.requestPushNotification(to: roomUser.id!)
                        }
                    }
                    
                }) {
                    Color.clear
                        .cornerRadius(8)
                }
            default :
                Button(action: {
                    
                }) {
                    Color.clear
                        .cornerRadius(8)
                }
            }
        }//ZStack
    }
}

struct SceneButtons_Previews: PreviewProvider {
    @State static var nickname: String = "행복한 고양이"
    static var previews: some View {
        let newAttendanceRecord = AttendanceRecord(
            userId: "",
            date: Date(),
            rawIsSmiling: false,
            rawIsBlinkingLeft: true,
            rawIsBlinkingRight: false,
            rawLookAtPoint: [0, 0, 0],
            rawFaceOrientation: [0, 0, 0],
            rawCharacterColor: [0, 0, 0],
            rawWeather: "clear",
            rawTime: Date(),
            rawSunriseTime: Date(),
            rawSunsetTime: Date()
        )
        
        FixAptView(nickname: $nickname, isTutorialOn: .constant(false))
            .environmentObject(ViewRouter())
            .environmentObject(AptModel())
            .environmentObject(AttendanceViewModel())
            .environmentObject(CharacterViewModel())
            .environmentObject(EnvironmentViewModel())
            .environmentObject(LocationManager())
    }
}

