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
    @Binding var buttonText: String
    
    @State private var lastActiveToggle: Bool = false
    @State private var lastWakenTimeToggle: Bool = false
    @EnvironmentObject var customViewModel: CustomViewModel
    
    let pushNotiController = PushNotiController()
    
    var body: some View {
        
        ZStack {
            Color.clear
            
            switch roomUser.userState {
            case "sleep":
                Button(action: {
                    //TODO: 더미데이터일 경우 실행하지않기_임시로 분기처리
                    if roomUser.token.count > 1 {
                        
                        // push 알림 보내기
                        DispatchQueue.global(qos: .userInteractive).async {
                            print("SceneButtons | roomUser \(roomUser)")
                            pushNotiController.requestPushNotification(to: roomUser.id!)
                        }
                    }
                    
                    buttonText = "\(roomUser.roomId ?? "")\nsleep"
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
                        HStack {
                            Image.symbol.moon
                                .foregroundColor(.white)
                                .font(.body)
                            Text("3일")
                                .foregroundColor(.white)
                                .font(.body)
                                .bold()
                        }//HStack
                        .offset(y: 4)
                        //오프셋 보정
                        Button(action: {
                            lastActiveToggle = false
                            lastWakenTimeToggle = true
                            buttonText = "\(roomUser.roomId ?? "")\n깨우는 중"
                            
                            if roomUser.token.count > 1 {
                                
                                // push 알림 보내기
                                DispatchQueue.global(qos: .userInteractive).async {
                                    print("SceneButtons | roomUser \(roomUser)")
                                    pushNotiController.requestPushNotification(to: roomUser.id!)
                                }
                            }
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
                        .offset(y: -4)
                        //오프셋 보정
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
//                        lastWakenTimeToggle = false
                        buttonText = "\(roomUser.roomId ?? "")\n시간 종료"
                    }) {
                        Color.clear
                            .cornerRadius(8)
                    }
                }//ZStack
                .opacity(lastWakenTimeToggle ? 1 : 0)
                
            case "active":
                Button(action: {
                    buttonText = "\(roomUser.roomId ?? "")\nactive"
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
                                            tint: customViewModel.currentCharacterColor)
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
                        buttonText = "\(roomUser.roomId ?? "")\ninactive"
                    }) {
                        Color.clear
                            .cornerRadius(8)
                    }
                default :
                    Button(action: {
                        buttonText = "\(roomUser.roomId ?? "")\nvacant"
                    }) {
                        Color.clear
                            .cornerRadius(8)
                    }
                }
            }//ZStack
        }
    }
    
