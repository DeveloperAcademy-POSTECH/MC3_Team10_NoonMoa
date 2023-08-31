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
    @EnvironmentObject var eyeViewController: EyeViewController

    @Binding var roomUser: User
    @State private var isBlindUp: Bool = false
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Image.assets.room.vacant
                    .resizable()
                    .scaledToFit()
                
                if roomUser.userState == "active" {
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
                } else if roomUser.userState == "inactive" || roomUser.userState == "sleep" {
                    Image.assets.room.dark
                        .resizable()
                        .scaledToFit()
                }
    
                if roomUser.userState == "active" {
                    if roomUser.id == Auth.auth().currentUser?.uid {
                        SceneMyEye(roomUser: $roomUser, isJumping: roomUser.isJumping)
                            .environmentObject(EyeNeighborViewModel())
                    } else {
                        SceneNeighborEye(roomUser: $roomUser, isJumping: roomUser.isJumping)
                    }
                } else if roomUser.userState == "inactive" || roomUser.userState == "sleep" {
                    SceneInactiveEye(roomUser: $roomUser)

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
                        if roomUser.userState == "active" || roomUser.userState == "inactive" {
                            DispatchQueue.main.async {
                                withAnimation(.easeInOut(duration: 2)) {
                                    isBlindUp = true
                                }
                            }
                        } else if roomUser.userState == "sleep" {
                            isBlindUp = false
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
        }//GeometryReader
    }
}

struct SceneRoom_Previews: PreviewProvider {
    @State static var user: User = User.UTData[0][0]
    
    static var previews: some View {
        SceneRoom(roomUser: $user)
    }
}
