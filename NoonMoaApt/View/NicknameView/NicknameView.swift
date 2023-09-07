//
//  NickNameView.swift
//  NoonMoaApt
//
//  Created by 최민규 on 2023/09/07.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct NicknameView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var viewRouter: ViewRouter
    @State private var showAlert: Bool = false
    @Binding var isFromSettingView: Bool
    @Binding var nickname: String
    @State private var newNickname: String = ""
    @State private var tmpNickname: String = ""
    
    @StateObject private var nicknameViewModel = NicknameViewModel()

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
            VStack(alignment: .leading) {
                Text("닉네임을 설정하세요")
                    .font(.title)
                    .bold()
                    .padding(.vertical, 64)
  
                HStack {
                    HStack {
                        Text(newNickname)
                            .font(.title3)
                            .padding()
                        Spacer()
                        Button(action: {
                            //TODO: 누를 때 마다 서버에서 닉네임 중복 확인 필요
                            // 랜덤 닉네임 할당
                            tmpNickname = nicknameViewModel.randomNick()
                            print("tmpNickname: \(tmpNickname)")
                            // 재귀적으로 중복체크
                            func checkNicknameAvailability() {
                                nicknameViewModel.isNicknameAvailable(tmpNickname) { isAvailable in
                                    if isAvailable {
                                        newNickname = tmpNickname
                                        print("newNickname: \(newNickname)")
                                    } else {
                                        tmpNickname = nicknameViewModel.randomNick()
                                        checkNicknameAvailability()
                                    }
                                }
                            }
                            checkNicknameAvailability()
                        }) {
                            Text("새로 뽑기")
                                .foregroundColor(.white)
                                .font(.body)
                                .padding(.horizontal)
                                .padding(.vertical, 12)
                                .background{
                                    RoundedRectangle(cornerRadius: 12)
                                        .foregroundColor(.warmBlack)
                                }
                                .padding(8)
                        }
                    }
                    .background{
                        RoundedRectangle(cornerRadius: 16)
                        .foregroundColor(.white)
                    }
                }                
                Spacer()
                Button(action: {
                    showAlert = true
                    //TODO: 서버에 닉네임 업로드
                }) {
                    RoundedRectangle(cornerRadius: 16)
                        .frame(height: 56)
                        .foregroundColor(.warmBlack)
                        .overlay(
                            Text("완료")
                                .foregroundColor(.white)
                                .font(.title3)
                                .bold()
                        )
                }
            }
            .padding()
            .onAppear {
                //TODO: 닉네임 중복확인하기
                // 랜덤 닉네임 할당
                tmpNickname = nicknameViewModel.randomNick()
                
                // 재귀적으로 중복체크
                func checkNicknameAvailability() {
                    nicknameViewModel.isNicknameAvailable(tmpNickname) { isAvailable in
                        if isAvailable {
                            newNickname = tmpNickname
                        } else {
                            tmpNickname = nicknameViewModel.randomNick()
                            checkNicknameAvailability()
                        }
                    }
                }
                checkNicknameAvailability()
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text(newNickname),
                       message: Text("이 닉네임으로 설정할까요?"),
                       primaryButton: .default(Text("네")) {
                           //TODO: 닉네임 서버에 업로드
                           nicknameViewModel.uploadNickname(newNickname: newNickname)
                           if isFromSettingView {
                               isFromSettingView = false
                               dismiss()
                           } else {
                               viewRouter.nextView = .attendance
                           }
                       },
                       secondaryButton: .cancel(Text("아니요"))
                   )
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            if isFromSettingView {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        isFromSettingView = false
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.backward")
                            .foregroundColor(.warmBlack)
                    }
                }
            }
        }
    }
}

struct NickNameView_Previews: PreviewProvider {
    @State static var isFromSettingView: Bool = false
    @State static var nickname: String = ""
    static var previews: some View {
        NicknameView(isFromSettingView: $isFromSettingView, nickname: $nickname)
    }
}
