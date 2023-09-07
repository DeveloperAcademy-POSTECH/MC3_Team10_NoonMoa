//
//  SettingView.swift
//  NoonMoaApt
//
//  Created by kimpepe on 2023/09/07.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth

struct SettingView: View {
    @EnvironmentObject var characterViewModel: CharacterViewModel
    @EnvironmentObject var environmentViewModel: EnvironmentViewModel
    
    private var username = "ZENA"
    @Environment(\.dismiss) private var dismiss
    @State private var isSignOutInProgress = false
    
    @Binding private var isSettingViewOpen: Bool
    
    // Firebase에서 가져온 사용자 정보를 저장할 변수들
    @State private var userEmail: String = "email_test"
    @State private var userNickname: String = "nickname_test"
    
    public init(isSettingViewOpen: Binding<Bool>) {
        _isSettingViewOpen = isSettingViewOpen
    }
    
    private var firestoreManager: FirestoreManager {
        FirestoreManager.shared
    }
    private var db: Firestore {
        firestoreManager.db
    }
    
    var body: some View {
        VStack {
            List {
                Section {
                    HStack {
                        VStack {
                            Text(userEmail)
                            Text(userNickname)
                        }
                        Button {
                            EmptyView()
                        } label: {
                            Text("변경하기")
                        }

                    }
                }
                
                Section {
                    NavigationLink {
                        EmptyView()
                    } label: {
                        HStack {
                            Image(systemName: "bell.fill")
                            Text("알림 설정")
                        }
                    }
                    
                    // 로그아웃
                    Button {
                        // isSignOutInProgress = true
                        // AuthViewModel.shared.signOut {
                        // isSignOutInProgress = false
                        EmptyView()
                    } label: {
                        HStack {
                            Text("로그아웃")
                        }
                    }
                    
                    // 회원 탈퇴
                    Button {
                        EmptyView()
                    } label: {
                        HStack {
                            Text("회원탈퇴")
                                .foregroundColor(.red)
                        }
                    }
                }
                .onAppear {
                    // Firebase에서 사용자 정보 가져오기
                    if let user = Auth.auth().currentUser {
                        // 이메일 가져오기
                        userEmail = user.email ?? ""
                        
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
                
                .navigationTitle("설정 및 개인정보")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden(true)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            
                        } label: {
                            Image(systemName: "chevron.backward")
                                .foregroundColor(.white)
                        }
                    }
                }
                if isSignOutInProgress {
                    Color.black
                        .opacity(0.8)
                        .ignoresSafeArea()
                    ProgressView()
                }
            }
            .listStyle(.grouped)
        }
    }
}

private struct CustomBlurView: UIViewRepresentable {
    var effect: UIBlurEffect.Style
    var onChange: (UIVisualEffectView) -> ()
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: effect))
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        DispatchQueue.main.async {
            onChange(uiView)
        }
    }
}

struct Setting_Previews: PreviewProvider {
    static var previews: some View {
        SettingView(isSettingViewOpen: .constant(true))
    }
}

