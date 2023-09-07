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
    
    // Firebase에서 가져온 사용자 정보를 저장할 변수들
    @State private var userEmail: String = "email_test"
    @State private var userNickname: String = "nickname_test"
    
    @StateObject private var nicknameViewModel = NicknameViewModel()
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var loginViewModel: LoginViewModel
    
    // firebase 싱글톤
    private var firestoreManager: FirestoreManager {
        FirestoreManager.shared
    }
    private var db: Firestore {
        firestoreManager.db
    }
    
    var body: some View {
        ZStack {
            Color.backgroundGray
                .ignoresSafeArea()
            VStack(alignment: .center) {
                
                Spacer().frame(height: 64)
                VStack(alignment: .leading) {
                    HStack {
                        //TODO: nickname대신에 서버에서 받아온 나의 닉네임으로 대체한다
                        Text(userNickname)
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
                    Text(userEmail)
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
                    print("로그아웃")
                    loginViewModel.isLogInDone = false
                    loginViewModel.logout()
                    viewRouter.currentView = .login
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
                    //TODO: 회원탈퇴 기능
                    print("회원 탈퇴")
                    loginViewModel.deleteUserAccount()
                    loginViewModel.isLogInDone = false
                    viewRouter.currentView = .login
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
        .onAppear {
            // Firebase에서 사용자 정보 가져오기
            if let user = Auth.auth().currentUser {
                // 이메일 가져오기
                userEmail = user.email ?? "not available"

                // UID를 사용하여 Firestore에서 닉네임 가져오기
                db.collection("User").document(user.uid).getDocument { document, error in
                    if let document = document, document.exists {
                        if let userData = document.data(), let nickname = userData["nickname"] as? String {
                            userNickname = nickname
                        }
                    }
                }
            }
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

