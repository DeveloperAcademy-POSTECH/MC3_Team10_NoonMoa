////
////  ApartView.swift
////  MC3
////
////  Created by 최민규 on 2023/07/14.
////
//
//import SwiftUI
//import Firebase
//import FirebaseFirestore
//import FirebaseAuth
//import AVFoundation
//
//struct AptView: View {
//    @EnvironmentObject var viewRouter: ViewRouter
//    @EnvironmentObject var aptModel: AptModel
//    @EnvironmentObject var attendanceViewModel: AttendanceViewModel
//    @EnvironmentObject var characterViewModel: CharacterViewModel
//    @EnvironmentObject var environmentViewModel: EnvironmentViewModel
//    @EnvironmentObject var locationManager: LocationManager
//    
//    @State private var users: [[User]] = User.UTData
//    @State private var isCalendarOpen: Bool = false
//    @State private var isSettingOpen: Bool = false
//    @State private var announcement: Bool = false
//    
//    @State var player: AVAudioPlayer!
//
//    //아파트 등장 애니메이션
//    @State private var isAptEffectPlayed: Bool = false
//    
//    //임시변수
//    @State private var isCalendarMonthOpen: Bool = false
//    @State private var isCalendarDayOpen: Bool = false
//    
//    private var firestoreManager: FirestoreManager {
//        FirestoreManager.shared
//    }
//    private var db: Firestore {
//        firestoreManager.db
//    }
//
//        func playSound(soundName: String) {
//            let url = Bundle.main.url(forResource: soundName, withExtension: "mp3")
//            player = try! AVAudioPlayer(contentsOf: url!)
//            //player.numberOfLoops = 1
//            player.play()
//        }
//    
//    var body: some View {
//        ZStack{
//            //배경 레이어
//            SceneBackground()
//                .environmentObject(environmentViewModel)
//                .scaleEffect(isAptEffectPlayed ? 1 : 1.3)
//            
//            //아파트 레이어
//            GeometryReader { proxy in
//                ZStack {
//                    GeometryReader { geo in
//                        SceneApt()
//                        VStack(spacing: 16) {
//                            ForEach(users.indices, id: \.self) { rowIndex in
//                                HStack(spacing: 12) {
//                                    ForEach(users[rowIndex].indices, id: \.self) { colIndex in
//                                        if rowIndex < aptModel.user2DLayout.count && colIndex < aptModel.user2DLayout[rowIndex].count {
//                                            SceneRoom(roomUser: $aptModel.user2DLayout[rowIndex][colIndex])
//                                                .frame(width: (geo.size.width - 48) / 3, height: ((geo.size.width - 48) / 3) / 1.2)
//                                            
//                                        }
//                                    }
//                                }
//                            }
//                        }
//                        .offset(x: 12, y: 32)
//                    }//GeometryReader
//                }//ZStack
//                .padding()
//                .ignoresSafeArea()
//                .offset(y: proxy.size.height - proxy.size.width * 1.5)
//                //화면만큼 내린 다음에 아파트 크기 비율인 1:1.5에 따라 올려 보정?
//            }
//            .scaleEffect(isAptEffectPlayed ? 1 : 1.3)
//            .onAppear {
//                withAnimation(.easeInOut(duration: 1)) {
//                    isAptEffectPlayed = true
//                }
//            }
//            
//            //날씨 레이어
//            SceneWeather()
//                .environmentObject(environmentViewModel)
//                .opacity(isAptEffectPlayed ? 1 : 0.5)
//            
//            SceneBroadcast()
//                .environmentObject(environmentViewModel)
//            
//            //버튼 레이어
//            GeometryReader { proxy in
//                ZStack {
//                    GeometryReader { geo in
//                        VStack(spacing: 16) {
//                            ForEach(aptModel.user2DLayout.indices, id: \.self) { rowIndex in
//                                HStack(spacing: 12) {
//                                    ForEach(aptModel.user2DLayout[rowIndex].indices, id: \.self) { colIndex in
//                                        SceneButtons(roomUser: $aptModel.user2DLayout[rowIndex][colIndex])
//                                            .frame(width: (geo.size.width - 48) / 3, height: ((geo.size.width - 48) / 3) / 1.2)
//                                        //방 이미지 자체의 비율 1:1.2 통한 높이 산정
//                                    }
//                                }
//                            }
//                        }
//                        .offset(x: 12, y: 32)
//                    }//GeometryReader
//                }//ZStack
//                .padding()
//                .ignoresSafeArea()
//                .offset(y: proxy.size.height - proxy.size.width * 1.5)
//                //화면만큼 내린 다음에 아파트 크기 비율인 1:1.5에 따라 올려 보정?
//            }
//            
//            //            기능테스트위한 임시 뷰
//            FunctionTestView()
//                .environmentObject(viewRouter)
//                .environmentObject(environmentViewModel)
//                .opacity(isSettingOpen ? 1 : 0)
//            
//            //캘린더뷰
//            if isCalendarOpen {
//                ZStack {
//                    Button {
//                            isCalendarOpen = false
//                    } label: {
//                        Color.clear
//                    }
//                    
//                    VStack {
//                        CalendarMonthView()
//                            .frame(height: UIScreen.main.bounds.width * 1)
//                            .padding()
//                            .environmentObject(characterViewModel)
//                        Spacer()
//                    }
//                    .offset(y: 40)
//                }
//            }
//            // 상단 캘린더 & 설정 버튼
//            GeometryReader { proxy in
//                HStack (spacing: 16) {
//                    Spacer()
//                    
//                    Button { // 캘린더 버튼
//                        isCalendarOpen.toggle()
//                    } label: {
//                        if isCalendarOpen {
//                            Image.assets.buttons.calendarSelected
//                                .resizable()
//                                .scaledToFit()
//                                .frame(width: proxy.size.width * 0.08)
//                        } else {
//                            Image.assets.buttons.calendarUnSelected
//                                .resizable()
//                                .scaledToFit()
//                                .frame(width: proxy.size.width * 0.08)
//                        }
//                    }
//                    
//                    Button { // 설정 버튼
//                        isSettingOpen.toggle()
//                    } label: {
//                        if isSettingOpen {
//                            Image.assets.buttons.settingSelected
//                                .resizable()
//                                .scaledToFit()
//                                .frame(width: proxy.size.width * 0.08)
//                        } else {
//                            Image.assets.buttons.settingUnSelected
//                                .resizable()
//                                .scaledToFit()
//                                .frame(width: proxy.size.width * 0.08)
//                        }
//                    }
//                }
//                .padding(.horizontal, proxy.size.width * 0.06)
//            }
//        }//ZStack
//        .onAppear {
//            
//            // 현재 아파트 정보 받아오기
//            aptModel.fetchCurrentUserApt()
//            
//            playSound(soundName: String.sounds.clear)
//            
//            // When the app is active, update the user's state to .active
//            if let user = Auth.auth().currentUser {
//                firestoreManager.syncDB()
//                let userRef = db.collection("User").document(user.uid)
//                
//                userRef.getDocument { (document, error) in
//                    if let document = document, document.exists {
//                        if let userData = document.data(), let userState = userData["userState"] as? String {
//                            self.db.collection("User").document(user.uid).updateData([
//                                "userState": UserState.active.rawValue
//                            ])
//                        }
//                    } else {
//                        print("AptView | No user is signed in.")
//                    }
//                }
//            }
//        }
//    }
//}
//
//struct AptView_Previews: PreviewProvider {
//    static var previews: some View {
//        let newAttendanceRecord = AttendanceRecord(
//            userId: "",
//            date: Date(),
//            rawIsSmiling: false,
//            rawIsBlinkingLeft: true,
//            rawIsBlinkingRight: false,
//            rawLookAtPoint: [0, 0, 0],
//            rawFaceOrientation: [0, 0, 0],
//            rawCharacterColor: [0, 0, 0],
//            rawWeather: "clear",
//            rawTime: Date(),
//            rawSunriseTime: Date(),
//            rawSunsetTime: Date()
//        )
//        
//        AptView()
//            .environmentObject(ViewRouter())
//            .environmentObject(AptModel())
//            .environmentObject(AttendanceViewModel())
//            .environmentObject(CharacterViewModel())
//            .environmentObject(EnvironmentViewModel())
//            .environmentObject(LocationManager())
//    }
//}
