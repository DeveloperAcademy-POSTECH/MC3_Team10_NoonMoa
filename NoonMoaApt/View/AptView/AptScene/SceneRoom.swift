//
//  SceneRoom.swift
//  MC3
//
//  Created by 최민규 on 2023/07/16.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct SceneRoom: View {
    @EnvironmentObject var characterViewModel: CharacterViewModel
    
    @Binding var roomUser: User
    @State private var isBlindUp: Bool = false
    @State private var sleepIconIndex: Int = 0
    
    
    var body: some View {
        GeometryReader { geo in
            
            ZStack {
                ZStack {
                    Image.assets.room.vacant
                        .resizable()
                        .scaledToFit()
                    
                    if roomUser.userState == "active" || roomUser.userState == "inactive" {
                        //본인의 방일 경우 .white
                        if roomUser.id == Auth.auth().currentUser?.uid {
                            Image.assets.room.white
                                .resizable()
                                .scaledToFit()
                        } else {
                            Image.assets.room.light
                                .resizable()
                                .scaledToFit()
                        }
                    } else if roomUser.userState == "sleep" {
                        Image.assets.room.dark
                            .resizable()
                            .scaledToFit()
                    }
                    
                    if roomUser.userState == "active" {
                        if roomUser.id == Auth.auth().currentUser?.uid {
                            SceneMyEye(roomUser: $roomUser, isJumping: roomUser.isJumping)
                                .environmentObject(characterViewModel)
                        } else {
                            SceneNeighborEye(roomUser: $roomUser)
                        }
                    } else if roomUser.userState == "inactive" {
                        SceneInactiveEye(roomUser: $roomUser)
                    } else if roomUser.userState == "sleep" {
                        SceneSleepEye(roomUser: $roomUser)
                    } else if roomUser.userState == "vacant" {
                        EmptyView()
                    }
                    
                    Image.assets.room.blindUp
                        .resizable()
                        .scaledToFit()
                    
                    Image.assets.room.blind
                        .resizable()
                        .scaledToFit()
                        .offset(y: isBlindUp ? -150 : 0)
                        .clipShape(Rectangle())
                        .onAppear {
                            DispatchQueue.main.async {
                                withAnimation(.easeInOut(duration: 2)) {
                                    isBlindUp = true
                                }
                            }
                        }
                    Image.assets.room.windowBorder
                        .resizable()
                        .scaledToFit()
                        .frame(width: geo.size.width)
                    
                }//ZStack
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.black, lineWidth: roomUser.id == Auth.auth().currentUser?.uid ? 3 : 2)
                        .frame(width: geo.size.width, height: geo.size.width / 1.2)
                )
                .clipShape(
                    RoundedRectangle(cornerRadius: 8)
                )
                .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                
                ZStack {
                    if roomUser.userState == "sleep" {
                        switch sleepIconIndex {
                        case 0:
                            Image.assets.room.sleepIcon1
                                .resizable()
                                .scaledToFit()
                                .frame(width: geo.size.width / 2)
                                .offset(x: geo.size.width / 3, y: -geo.size.height / 3)
                        case 1:
                            Image.assets.room.sleepIcon2
                                .resizable()
                                .scaledToFit()
                                .frame(width: geo.size.width / 2)
                                .offset(x: geo.size.width / 3, y: -geo.size.height / 3)
                        case 2,3,4:
                            Image.assets.room.sleepIcon3
                                .resizable()
                                .scaledToFit()
                                .frame(width: geo.size.width / 2)
                                .offset(x: geo.size.width / 3, y: -geo.size.height / 3)
                        default: EmptyView()
                        }
                    }
                }
            }
            .onAppear {
                Timer.scheduledTimer(withTimeInterval: 0.6, repeats: true) { timer in
                    DispatchQueue.main.async {
                        self.sleepIconIndex = (sleepIconIndex + 1) % 5
                    }
                }
            }
        }//GeometryReader
    }
}

struct SceneRoom_Previews: PreviewProvider {
    @State static var user: User = User.UTData[0][0]
    
    static var previews: some View {
        SceneRoom(roomUser: $user)
    }
}
