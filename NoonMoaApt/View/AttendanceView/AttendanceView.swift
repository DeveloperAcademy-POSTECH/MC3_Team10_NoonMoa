//
//  AttendanceView.swift
//  MangMongApt
//
//  Created by kimpepe on 2023/07/15.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth
import AVFoundation


struct AttendanceView: View {
    private let currentUser = Auth.auth().currentUser
    
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var attendanceModel: AttendanceModel
    @EnvironmentObject var environmentModel: EnvironmentModel
    @EnvironmentObject var characterModel: CharacterModel
    @EnvironmentObject var customViewModel: CustomViewModel
    @EnvironmentObject var weatherKitManager: WeatherKitManager
    @EnvironmentObject var locationManager: LocationManager
    @StateObject var eyeViewController: EyeViewController
    
    @State private var isStamped: Bool = false
    @State private var isScaleEffectPlayed: Bool = false
    @State private var isBlurEffectPlayed: Bool = false
    @State private var isShutterEffectPlayed: Bool = false
    @State private var isColorPickerAppeared: Bool = false
    @State private var isStartButtonActive: Bool = false
    
    @State private var isSettingOpen: Bool = false

    @State var player: AVAudioPlayer!

    private var firestoreManager: FirestoreManager {
        FirestoreManager.shared
    }
    private var db: Firestore {
        firestoreManager.db
    }
    
    //중복호출
    func playSound(soundName: String) {
        let url = Bundle.main.url(forResource: soundName, withExtension: "mp3")
        player = try! AVAudioPlayer(contentsOf: url!)
        //player.numberOfLoops = 1
        player.play()
    }

    var body: some View {
        ZStack {
            GeometryReader { geo in
                VStack(alignment: .leading) {
                    Spacer().frame(height: geo.size.height * 0.06)
                    HStack {
                        VStack(alignment: .leading) {
                            if !isStamped {
                                Text(environmentModel.currentBroadcastAttendanceIncompleteTitle)
                                    .font(.title)
                                    .fontWeight(.black)
                                    .padding(.bottom, 4)
                                Text(environmentModel.currentBroadcastAttendanceIncompleteBody)
                                    .font(.title3)
                                    .fontWeight(.semibold)
                            } else {
                                Text(environmentModel.currentBroadcastAttendanceCompletedTitle)
                                    .font(.title)
                                    .fontWeight(.black)
                                    .padding(.bottom, 4)
                                Text(environmentModel.currentBroadcastAttendanceCompletedBody)
                                    .font(.title3)
                                    .fontWeight(.semibold)
                            }
                            Spacer()
                        }
                    }
                    .frame(height: geo.size.height * 0.16)
                    .offset(x: 8)
                    
                    
                    if !isStamped {
                        //출석체크 전 눈 움직이는 뷰
                        StampLargeView(skyColor: LinearGradient.gradationGray, skyImage: Image(""), isSmiling: eyeViewController.eyeMyViewModel.isSmiling,
                                       isBlinkingLeft: eyeViewController.eyeMyViewModel.isBlinkingLeft,
                                       isBlinkingRight: eyeViewController.eyeMyViewModel.isBlinkingRight,
                                       lookAtPoint: eyeViewController.eyeMyViewModel.lookAtPoint,
                                       faceOrientation: eyeViewController.eyeMyViewModel.faceOrientation,
                                       bodyColor: LinearGradient.unStampedWhite,
                                       eyeColor: LinearGradient.unStampedWhite, cheekColor: LinearGradient.cheekGray)
                        .frame(width: geo.size.width, height: geo.size.width)
                        .blur(radius: isBlurEffectPlayed ? 5 : 0)
                        .onTapGesture {
                            eyeViewController.resetFaceAnchor()
                        }
                        
                        //                        Spacer().frame(height: 50)
                        
                    } else {
                        //출석체크 후 저장된 날씨와, 캐릭터의 움직임 좌표값으로 표현된 뷰
                        StampLargeView(skyColor: environmentModel.currentColorOfSky, skyImage: environmentModel.currentStampLargeSkyImage, isSmiling: characterModel.currentIsSmiling, isBlinkingLeft: characterModel.currentIsBlinkingLeft, isBlinkingRight: characterModel.currentIsBlinkingRight, lookAtPoint: characterModel.currentLookAtPoint, faceOrientation: characterModel.currentFaceOrientation, bodyColor: customViewModel.currentBodyColor, eyeColor: customViewModel.currentEyeColor, cheekColor: customViewModel.currentCheekColor)
                            .frame(width: geo.size.width, height: geo.size.width)
                            .scaleEffect(isScaleEffectPlayed ? 0.9 : 1)
                            .opacity(isShutterEffectPlayed ? 1 : 0)
                        
                    }
                }//VStack
                
                VStack(alignment: .leading) {
                    
                    Spacer()
                    
                    //컬러피커
                    CharacterColorPickerView()
                        .frame(height: 50)
                        .scaleEffect(0.9)
                        .opacity(isColorPickerAppeared ? 1 : 0)
                        .padding(.bottom, 64)
                    
                    if !isStamped {
                        // 눈도장 찍기 버튼
                        Button (action: {
                            //사용자 색상 최초 지정(default값)
                            self.playSound(soundName: Text.sounds.shutter)
                            customViewModel.pickerValueToCharacterColor(value: customViewModel.pickerValue)
                            //날씨 받아오기
                            weatherKitManager.getWeather(latitude: locationManager.latitude, longitude: locationManager.longitude)
                            environmentModel.rawWeather = weatherKitManager.condition
                            environmentModel.getCurrentEnvironment()
                            print("at attendanceView after stamped, weather:\(environmentModel.currentWeather)")
                            print("at attendanceView after stamped, time:\(environmentModel.currentTime)")
                            DispatchQueue.main.async {
                                UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                                withAnimation(.easeInOut(duration: 0.2).repeatCount(1, autoreverses: true)) {
                                    isBlurEffectPlayed = true
                                }
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                                withAnimation(.easeInOut(duration: 0.4).repeatCount(1, autoreverses: true)) {
                                    isBlurEffectPlayed = false
                                }
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                                withAnimation(.easeIn(duration: 0.1)) {
                                    isStamped = true
                                }
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                withAnimation(.linear.speed(1.5).repeatCount(1, autoreverses: true)) {
                                    isShutterEffectPlayed = true
                                }
                                characterModel.currentIsSmiling = eyeViewController.eyeMyViewModel.isSmiling
                                characterModel.currentIsBlinkingLeft = eyeViewController.eyeMyViewModel.isBlinkingLeft
                                characterModel.currentIsBlinkingRight = eyeViewController.eyeMyViewModel.isBlinkingRight
                                characterModel.currentLookAtPoint = eyeViewController.eyeMyViewModel.lookAtPoint
                                characterModel.currentFaceOrientation = eyeViewController.eyeMyViewModel.faceOrientation
                                
                                characterModel.getCurrentCharacter()
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation(.spring(response: 0.5, dampingFraction: 0.3).speed(1)) {
                                    isScaleEffectPlayed = true
                                }
                                withAnimation(.easeInOut(duration: 1)) {
                                    isColorPickerAppeared = true
                                }
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    isStartButtonActive = true
                                }
                            }
                
                        }) {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.warmBlack)
                                .frame(height: 56)
                                .overlay(
                                    Text("눈도장 찍기")
                                        .foregroundColor(.white)
                                        .fontWeight(.semibold)
                                        .padding()
                                )
                        }
                    } else {
                        HStack {
                            // 다시찍기 버튼
                            Button (action: {
                                isStamped = false
                                isScaleEffectPlayed = false
                                isBlurEffectPlayed = false
                                isShutterEffectPlayed = false
                                isColorPickerAppeared = false
                                isStartButtonActive = false
                                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                            }) {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.warmBlack)
                                    .frame(height: 56)
                                    .overlay(
                                        Text("다시 찍기")
                                            .foregroundColor(.white)
                                            .fontWeight(.semibold)
                                            .padding()
                                    )
                            }
                            // 시작하기 버튼
                            Button (action: {
                                characterModel.rawCharacterColor = customViewModel.currentCharacterColor.toArray
                                viewRouter.currentView = .apt
                                attendanceModel.uploadAttendanceRecord()
                                UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                            }) {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.warmBlack)
                                    .frame(height: 56)
                                    .opacity(isStartButtonActive ? 1 : 0.3)
                                    .overlay(
                                        Text("시작하기")
                                            .foregroundColor(.white)
                                            .fontWeight(.semibold)
                                            .padding()
                                    )
                            }
                            .disabled(!isStartButtonActive)
                        }//HStack
                    }
                }//VStack
            }//GeometryReader
            .padding(24)
            
            if isSettingOpen {
                AttendanceTestView()
            }
            
            VStack {
                Button { // 설정 버튼
                    isSettingOpen.toggle()
                } label: {
                    if isSettingOpen {
                        Image.assets.buttons.settingSelected
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50)
                    } else {
                        Image.assets.buttons.settingUnSelected
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50)
                    }
                }
                Spacer()
            }
        }//ZStack
                .onAppear {
                    //테스트용 날씨 보기위해 임시로 아래 함수만 실행
                    weatherKitManager.getWeather(latitude: locationManager.latitude, longitude: locationManager.longitude)
                    environmentModel.rawWeather = weatherKitManager.condition
                    environmentModel.getCurrentEnvironment()
                    print("at attendanceView, weather:\(environmentModel.currentWeather)")
                    print("at attendanceView, time:\(environmentModel.currentTime)")

                }
    }
    
    struct AttendanceView_Previews: PreviewProvider {
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
            AttendanceView(eyeViewController: EyeViewController())
                .environmentObject(ViewRouter())
                .environmentObject(AttendanceModel(newAttendanceRecord: newAttendanceRecord))
                .environmentObject(CustomViewModel())
                .environmentObject(EyeViewController())
        }
    }
}
