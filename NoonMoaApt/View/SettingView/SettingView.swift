//
//  SettingView.swift
//  NoonMoaApt
//
//  Created by 최민규 on 2023/09/07.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct SettingView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var isFromSettingView: Bool = false
    @Binding var nickname: String
    var body: some View {
        ZStack {
            Color.backgroundGray
                .ignoresSafeArea()
            VStack(alignment: .center) {
                
                Spacer().frame(height: 64)
                VStack(alignment: .leading) {
                    HStack {
                        //TODO: nickname대신에 서버에서 받아온 나의 닉네임으로 대체한다
                        Text(nickname)
                            .foregroundColor(.black)
                            .font(.title2)
                            .bold()
                        NavigationLink(destination: NicknameView(isFromSettingView: $isFromSettingView, nickname: $nickname)) {
                            Image.symbol.edit
                                .resizable()
                                .scaledToFit()
                                .frame(width: 18)
                        }.simultaneousGesture(TapGesture().onEnded{
                            self.isFromSettingView = true
                        })
                        Spacer()
                    }
                    Text(Auth.auth().currentUser?.email ?? "not available")
                        .foregroundColor(.black.opacity(0.4))
                        .font(.caption)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.white)
                )
                
                Button(action: {
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                }) {
                    HStack {
                        Image.symbol.notification
                            .resizable()
                            .scaledToFit()
                            .frame(width: 18)
                        Text("알림 설정")
                            .foregroundColor(.black)
                            .font(.body)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.black)
                            .font(.body)
                    }
                    .padding()
                }
                
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.black.opacity(0.3))
                
                
                Button(action: {
                    //TODO: 로그아웃 기능
                }) {
                    HStack {
                        Image.symbol.logout
                            .resizable()
                            .scaledToFit()
                            .frame(width: 18)
                        Text("로그아웃")
                            .foregroundColor(.black)
                            .font(.body)
                        Spacer()
                    }
                    .padding()
                }
                
                Button(action: {
                    //TODO: 로그아웃 기능
                }) {
                    Text("탈퇴하기")
                        .foregroundColor(.black.opacity(0.4))
                        .font(.callout)
                        .padding()
                        .underline()
                }
                
                Spacer()
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.backward")
                        .foregroundColor(.warmBlack)
                }
            }
        }
        
    }
}

struct SettingView_Previews: PreviewProvider {
    @State static var nickname: String = "행복한 고양이"
    static var previews: some View {
        SettingView(nickname: $nickname)
    }
}
