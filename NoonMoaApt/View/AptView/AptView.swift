//
//  ApartView.swift
//  MC3
//
//  Created by 최민규 on 2023/07/14.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth
import AVFoundation

struct AptView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var aptModel: AptModel
    @EnvironmentObject var attendanceModel: AttendanceModel
    @EnvironmentObject var characterModel: CharacterModel
    @EnvironmentObject var environmentModel: EnvironmentModel
    @EnvironmentObject var customViewModel: CustomViewModel
    @EnvironmentObject var weatherKitManager: WeatherKitManager
    @EnvironmentObject var locationManager: LocationManager
    
    @State private var users: [[User]] = User.UTData
    @State private var buttonText: String = ""
    @State private var isCalendarOpen: Bool = false
    @State private var isSettingOpen: Bool = false
    @State private var announcement: Bool = false
    
    @State var player: AVAudioPlayer!

    //아파트 등장 애니메이션
    @State private var isAptEffectPlayed: Bool = false
    
    //임시변수
    @State private var isCalendarMonthOpen: Bool = false
    @State private var isCalendarDayOpen: Bool = false
    
    private var firestoreManager: FirestoreManager {
        FirestoreManager.shared
    }
    private var db: Firestore {
        firestoreManager.db
    }

        func playSound(soundName: String) {
            let url = Bundle.main.url(forResource: soundName, withExtension: "mp3")
            player = try! AVAudioPlayer(contentsOf: url!)
            //player.numberOfLoops = 1
            player.play()
        }
    
    var body: some View {
        ZStack{
            //배경 레이어
            SceneBackground()
                .environmentObject(environmentModel)
                .scaleEffect(isAptEffectPlayed ? 1 : 1.3)
            
            //아파트 레이어
            GeometryReader { proxy in
                ZStack {
                    GeometryReader { geo in
                        SceneApt()
                        VStack(spacing: 16) {
                            ForEach(users.indices, id: \.self) { rowIndex in
                                HStack(spacing: 12) {
                                    ForEach(users[rowIndex].indices, id: \.self) { colIndex in
                                        if rowIndex < aptModel.user2DLayout.count && colIndex < aptModel.user2DLayout[rowIndex].count {
                                            SceneRoom(roomUser: $aptModel.user2DLayout[rowIndex][colIndex])
                                                .environmentObject(customViewModel)
                                                .frame(width: (geo.size.width - 48) / 3, height: ((geo.size.width - 48) / 3) / 1.2)
                                        }
                                    }
                                }
                            }
                        }
                        .offset(x: 12, y: 32)
                    }//GeometryReader
                }//ZStack
                .padding()
                .ignoresSafeArea()
                .offset(y: proxy.size.height - proxy.size.width * 1.5)
                //화면만큼 내린 다음에 아파트 크기 비율인 1:1.5에 따라 올려 보정?
            }
            .scaleEffect(isAptEffectPlayed ? 1 : 1.3)
            .onAppear {
                withAnimation(.easeInOut(duration: 1)) {
                    isAptEffectPlayed = true
                }
            }
            
            //날씨 레이어
            SceneWeather()
                .environmentObject(environmentModel)
                .opacity(isAptEffectPlayed ? 1 : 0.5)
            
            SceneBroadcast()
                .environmentObject(environmentModel)
            
            //버튼 레이어
            GeometryReader { proxy in
                ZStack {
                    GeometryReader { geo in
                        VStack(spacing: 16) {
                            ForEach(aptModel.user2DLayout.indices, id: \.self) { rowIndex in
                                HStack(spacing: 12) {
                                    ForEach(aptModel.user2DLayout[rowIndex].indices, id: \.self) { colIndex in
                                        SceneButtons(roomUser: $aptModel.user2DLayout[rowIndex][colIndex], buttonText: $buttonText)
                                            .environmentObject(customViewModel)
                                            .frame(width: (geo.size.width - 48) / 3, height: ((geo.size.width - 48) / 3) / 1.2)
                                        //방 이미지 자체의 비율 1:1.2 통한 높이 산정
                                    }
                                }
                            }
                        }
                        .offset(x: 12, y: 32)
                    }//GeometryReader
                }//ZStack
                .padding()
                .ignoresSafeArea()
                .offset(y: proxy.size.height - proxy.size.width * 1.5)
                //화면만큼 내린 다음에 아파트 크기 비율인 1:1.5에 따라 올려 보정?
            }
            
            //            기능테스트위한 임시 뷰
            FunctionTestView(buttonText: $buttonText)
                .environmentObject(viewRouter)
                .environmentObject(environmentModel)
                .environmentObject(weatherKitManager)
                .opacity(isSettingOpen ? 1 : 0)
            
            //임시코드
            Image("CalendarMonth_Temp")
                .resizable()
                .ignoresSafeArea()
                .onTapGesture {
                    isCalendarMonthOpen = false
                    isCalendarDayOpen = true
                }
                .overlay( // 외부 공간 눌렀을 때 캘린더 닫힘
                    Color.white
                        .frame(height: 400)
                        .offset(y: 270)
                        .opacity(0.01)
                        .onTapGesture {
                            isCalendarMonthOpen = false
                            isCalendarDayOpen = false
                            isCalendarOpen = false
                        }
                )
                .opacity(isCalendarMonthOpen ? 1 : 0)
            
            Image("CalendarDay_Temp")
                .resizable()
                .ignoresSafeArea()
                .onTapGesture {
                    isCalendarMonthOpen = true
                    isCalendarDayOpen = false
                }
                .overlay( // 외부 공간 눌렀을 때 캘린더 닫힘
                    Color.white
                        .frame(height: 400)
                        .offset(y: 270)
                        .opacity(0.01)
                        .onTapGesture {
                            isCalendarMonthOpen = false
                            isCalendarDayOpen = false
                            isCalendarOpen = false
                        }
                )
                .opacity(isCalendarDayOpen ? 1 : 0)
            
            // 상단 캘린더 & 설정 버튼
            GeometryReader { proxy in
                HStack (spacing: 16) {
                    Button {
                        
                    } label: {
                        if announcement {
                            Image("announcementOn")
                                .resizable()
                                .scaledToFit()
                                .frame(width: proxy.size.width * 0.08)
                        } else {
                          
                        }
                    }
                    
                    Spacer()
                    
                    Button { // 캘린더 버튼
                        if isCalendarOpen {
                            isCalendarOpen = false
                            isCalendarMonthOpen = false
                            isCalendarDayOpen = false
                        } else {
                            isCalendarOpen = true
                            isCalendarMonthOpen = true
                            isCalendarDayOpen = false
                        }
                    } label: {
                        if isCalendarOpen {
                            Image.assets.buttons.calendarSelected
                                .resizable()
                                .scaledToFit()
                                .frame(width: proxy.size.width * 0.08)
                        } else {
                            Image.assets.buttons.calendarUnSelected
                                .resizable()
                                .scaledToFit()
                                .frame(width: proxy.size.width * 0.08)
                        }
                    }
                    
                    Button { // 설정 버튼
                        isSettingOpen.toggle()
                    } label: {
                        if isSettingOpen {
                            Image.assets.buttons.settingSelected
                                .resizable()
                                .scaledToFit()
                                .frame(width: proxy.size.width * 0.08)
                        } else {
                            Image.assets.buttons.settingUnSelected
                                .resizable()
                                .scaledToFit()
                                .frame(width: proxy.size.width * 0.08)
                        }
                            
                    }
                }
                .padding(.horizontal, proxy.size.width * 0.06)
            }
        }//ZStack
        .onAppear {
            // 현재 날씨 데이터 받아오기
            weatherKitManager.getWeather(latitude: locationManager.latitude, longitude: locationManager.longitude)
            environmentModel.rawWeather = weatherKitManager.condition
            environmentModel.getCurrentEnvironment()
            print("at aptView, weather:\(environmentModel.currentWeather)")
            print("at aptView, time:\(environmentModel.currentTime)")
            
            // 현재 아파트 정보 받아오기
            aptModel.fetchCurrentUserApt()
            playSound(soundName: Text.sounds.clear)
            Timer.scheduledTimer(withTimeInterval: 4.0, repeats: true) { timer in
                DispatchQueue.global().async {
                    aptModel.fetchCurrentUserApt()
                }
            }
            
            attendanceModel.downloadAttendanceRecords(for: Date())
            
            // When the app is active, update the user's state to .active
            if let user = Auth.auth().currentUser {
                firestoreManager.syncDB()
                let userRef = db.collection("User").document(user.uid)
                
                userRef.getDocument { (document, error) in
                    if let document = document, document.exists {
                        if let userData = document.data(), let userState = userData["userState"] as? String {
                            self.db.collection("User").document(user.uid).updateData([
                                "userState": UserState.active.rawValue
                            ])
                        }
                    } else {
                        print("No user is signed in.")
                    }
                }
            }
        }
    }
}

struct AptView_Previews: PreviewProvider {
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
        
        AptView()
            .environmentObject(ViewRouter())
            .environmentObject(AptModel())
            .environmentObject(AttendanceModel(newAttendanceRecord: newAttendanceRecord))
            .environmentObject(CharacterModel())
            .environmentObject(EnvironmentModel())
        
    }
}
