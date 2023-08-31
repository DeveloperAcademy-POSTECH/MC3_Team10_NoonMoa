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
                    Color.black
                        .cornerRadius(8)
                        .opacity(0.3)
                    
                    VStack {
                        Button(action: {
                            lastActiveToggle = false
                            lastWakenTimeToggle = true
                            
                            if roomUser.token.count > 1 {
                                
                                // push 알림 보내기
                                DispatchQueue.global(qos: .userInteractive).async {
                                    print("SceneButtons | roomUser \(roomUser)")
                                    pushNotiController.requestPushNotification(to: roomUser.id!)
                                }
                            }
                            UserDefaults.standard.set(Date(), forKey: "\(String(describing: roomUser.roomId))")

                        }) {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.black)
                                .opacity(0.3)
                                .frame(width: 80, height: 36)
                                .overlay(
                                    Text("깨우기")
                                        .foregroundColor(.white)
                                        .font(.body)
                                        .bold()
                                )
                        }
                        
                    }
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
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .foregroundColor(.black)
                                .opacity(0.5)
                                .frame(width: 64, height: 8)
                            
                            RoundedRectangle(cornerRadius: 8)
                                .foregroundColor(.white)
                                .frame(width: 32, height: 8)
                                .offset(x: -16)
                        }
                    }//VStack
                    
                    Button(action: {
                        
                        lastWakenTime = Calendar.current.dateComponents([.second], from: UserDefaults.standard.value(forKey: "\(String(describing: roomUser.roomId))") as! Date , to: Date()).second ?? 0
                        
                        if lastWakenTime >= 10 {
                            lastWakenTimeToggle = false
                        } else {
                            print(lastWakenTime)
                        }
                       
                    }) {
                        Color.clear
                            .cornerRadius(8)
                    }
                }//ZStack
                .opacity(lastWakenTimeToggle ? 1 : 0)
                
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
            
            FixAptView()
                .environmentObject(ViewRouter())
                .environmentObject(AptModel())
                .environmentObject(AttendanceModel(newAttendanceRecord: newAttendanceRecord))
                .environmentObject(CharacterViewModel())
                .environmentObject(EnvironmentViewModel())
                .environmentObject(LocationManager())
        }
    }

