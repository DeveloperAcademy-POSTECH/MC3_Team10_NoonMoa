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
    @EnvironmentObject var attendanceViewModel: AttendanceViewModel
    @EnvironmentObject var environmentViewModel: EnvironmentViewModel
    @EnvironmentObject var characterViewModel: CharacterViewModel
    @EnvironmentObject var locationManager: LocationManager
    @StateObject var eyeViewController: EyeViewController
    
    @State private var isStamped: Bool = false
    @State private var isScaleEffectPlayed: Bool = false
    @State private var isBlurEffectPlayed: Bool = false
    @State private var isShutterEffectPlayed: Bool = false
    @State private var isColorPickerAppeared: Bool = false
    @State private var isStartButtonActive: Bool = false
    
    @State private var isSettingOpen: Bool = false
    @Binding var isTutorialOn: Bool
    @State private var tutorialFirstToggle: Bool = false
    @State private var tutorialSecondToggle: Bool = false


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
                                Text(environmentViewModel.environmentViewData.broadcastAttendanceIncompleteTitle)
                                    .font(.title)
                                    .fontWeight(.black)
                                    .padding(.bottom, 4)
                                Text(environmentViewModel.environmentViewData.broadcastAttendanceIncompleteBody)
                                    .font(.title3)
                                    .fontWeight(.semibold)
                            } else {
                                Text(environmentViewModel.environmentViewData.broadcastAttendanceCompletedTitle)
                                    .font(.title)
                                    .fontWeight(.black)
                                    .padding(.bottom, 4)
                                Text(environmentViewModel.environmentViewData.broadcastAttendanceCompletedBody)
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
                        StampLargeView(skyColor: environmentViewModel.environmentViewData.colorOfSky, skyImage: environmentViewModel.environmentViewData.stampLargeSkyImage, isSmiling: characterViewModel.characterViewData.isSmiling, isBlinkingLeft: characterViewModel.characterViewData.isBlinkingLeft, isBlinkingRight: characterViewModel.characterViewData.isBlinkingRight, lookAtPoint: characterViewModel.characterViewData.lookAtPoint, faceOrientation: characterViewModel.characterViewData.faceOrientation, bodyColor: characterViewModel.characterViewData.bodyColor, eyeColor: characterViewModel.characterViewData.eyeColor, cheekColor: characterViewModel.characterViewData.cheekColor)
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
                            self.playSound(soundName: String.sounds.shutter)
                            
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
                                characterViewModel.characterViewData.isSmiling = eyeViewController.eyeMyViewModel.isSmiling
                                characterViewModel.characterViewData.isBlinkingLeft = eyeViewController.eyeMyViewModel.isBlinkingLeft
                                characterViewModel.characterViewData.isBlinkingRight = eyeViewController.eyeMyViewModel.isBlinkingRight
                                characterViewModel.characterViewData.lookAtPoint = eyeViewController.eyeMyViewModel.lookAtPoint
                                characterViewModel.characterViewData.faceOrientation = eyeViewController.eyeMyViewModel.faceOrientation
                                characterViewModel.pickerValueToCharacterColor(value: characterViewModel.pickerValue)
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
                                characterViewModel.convertCharacterToRawData()
                                print(">>>" + String(describing: characterViewModel.character))
                                print(">>>" + String(describing: characterViewModel.characterViewData))
                                print(">>>" + String(describing: environmentViewModel.environment))
                                print(">>>" + String(describing: environmentViewModel.environmentViewData))
                                attendanceViewModel.newAttendanceRecord = AttendanceRecord(userId: "", date: Date(), rawIsSmiling: characterViewModel.character?.rawIsSmiling, rawIsBlinkingLeft: characterViewModel.character?.rawIsBlinkingLeft, rawIsBlinkingRight: characterViewModel.character?.rawIsBlinkingRight, rawLookAtPoint: characterViewModel.character?.rawLookAtPoint, rawFaceOrientation: characterViewModel.character?.rawFaceOrientation, rawCharacterColor: characterViewModel.character?.rawCharacterColor, rawWeather: environmentViewModel.environment.rawWeather, rawTime: environmentViewModel.environment.rawTime, rawSunriseTime: environmentViewModel.environment.rawSunriseTime, rawSunsetTime: environmentViewModel.environment.rawSunsetTime)
                                
                                attendanceViewModel.uploadAttendanceRecord()
                                print(">>>" + String(describing: attendanceViewModel.newAttendanceRecord))
                                
                                
                                viewRouter.currentView = .apt
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
            
            AttendanceTutorialViewFirst(isTutorialOn: $isTutorialOn, tutorialToggle: $tutorialFirstToggle)
                .opacity(isTutorialOn ? 1 : 0)
                .opacity(tutorialFirstToggle ? 1 : 0)
                .onAppear {
                    if isTutorialOn {
                        DispatchQueue.main.async {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                tutorialFirstToggle = true
                            }
                        }
                    }
                }
            
            AttendanceTutorialViewSecond(isTutorialOn: $isTutorialOn, tutorialToggle: $tutorialSecondToggle)
                .opacity(isTutorialOn ? 1 : 0)
                .opacity(tutorialSecondToggle ? 1 : 0)
                .onChange(of: isStamped) { _ in
                    if isStamped {
                        DispatchQueue.main.async {
                            withAnimation(.easeInOut(duration: 0.5).delay(1.3)) {
                                tutorialSecondToggle = true
                            }
                        }
                    }
                }
                .environmentObject(environmentViewModel)
                .environmentObject(characterViewModel)
            
        }//ZStack
             
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
            AttendanceView(eyeViewController: EyeViewController(), isTutorialOn: .constant(true))
                    .environmentObject(ViewRouter())
                    .environmentObject(AttendanceViewModel())
                    .environmentObject(CharacterViewModel())
                    .environmentObject(EnvironmentViewModel())
                    .environmentObject(EyeViewController())
        }
    }
}

struct AttendanceTutorialViewFirst: View {
    @Binding var isTutorialOn: Bool
    @Binding var tutorialToggle: Bool


    var body: some View {
        ZStack {
            Color.black
                .opacity(0.7)
                .ignoresSafeArea()
            VStack(alignment: .center){
                
                Text("얼굴과 눈을 움직여서\n오늘의 눈도장을 찍어주세요")
                    .foregroundColor(.white)
                    .font(.custom(.font.yeondeokSea, size: 24))
                    .padding(.vertical, 96)
                
                VStack(alignment: .leading) {
                    
                    HStack {
                        Image.tutorial.eye
                            .resizable()
                            .scaledToFit()
                            .frame(width: 56)
                        Text("눈동자: 사용자 눈동자 인식")
                            .foregroundColor(.white)
                            .font(.custom(.font.yeondeokSea, size: 18))
                    }
                    HStack {
                        Image.tutorial.closedEye
                            .resizable()
                            .scaledToFit()
                            .frame(width: 56)
                        Text("감은 눈: 눈 감음 or 윙크 시")
                            .foregroundColor(.white)
                            .font(.custom(.font.yeondeokSea, size: 18))
                    }
                    HStack {
                        Image.tutorial.cheek
                            .resizable()
                            .scaledToFit()
                            .frame(width: 56)
                        Text("볼터치: 웃을 때")
                            .foregroundColor(.white)
                            .font(.custom(.font.yeondeokSea, size: 18))
                    }
                }
                Spacer()
                Button(action: {
                    DispatchQueue.main.async {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            tutorialToggle = false
                        }
                    }
                }) {
                    HStack {
                        Spacer()
                        Text("NEXT")
                            .foregroundColor(.white)
                            .font(.custom(.font.yeondeokSea, size: 24))
                    }
                    .padding()
                }
            }
        }
    }
}


struct AttendanceTutorialViewSecond: View {
    @Binding var isTutorialOn: Bool
    @Binding var tutorialToggle: Bool
    
    @EnvironmentObject var environmentViewModel: EnvironmentViewModel
    @EnvironmentObject var characterViewModel: CharacterViewModel
    
    var body: some View {
        ZStack {
            Color.black
                .opacity(0.7)
                .ignoresSafeArea()
            
            GeometryReader { geo in
                VStack(alignment: .leading) {
                    Spacer().frame(height: geo.size.height * 0.06)
                    HStack {
                        VStack(alignment: .leading) {
                          
                                Text("")
                                .foregroundColor(.clear)
                                    .font(.title)
                                    .fontWeight(.black)
                                    .padding(.bottom, 4)
                                Text(" \n ")
                                .foregroundColor(.clear)
                                    .font(.title3)
                                    .fontWeight(.semibold)

                            Spacer()
                        }
                    }
                    .frame(height: geo.size.height * 0.16)
                    .offset(x: 8)
                    
                        //출석체크 후 저장된 날씨와, 캐릭터의 움직임 좌표값으로 표현된 뷰
                        StampLargeView(skyColor: environmentViewModel.environmentViewData.colorOfSky, skyImage: environmentViewModel.environmentViewData.stampLargeSkyImage, isSmiling: characterViewModel.characterViewData.isSmiling, isBlinkingLeft: characterViewModel.characterViewData.isBlinkingLeft, isBlinkingRight: characterViewModel.characterViewData.isBlinkingRight, lookAtPoint: characterViewModel.characterViewData.lookAtPoint, faceOrientation: characterViewModel.characterViewData.faceOrientation, bodyColor: characterViewModel.characterViewData.bodyColor, eyeColor: characterViewModel.characterViewData.eyeColor, cheekColor: characterViewModel.characterViewData.cheekColor)
                            .frame(width: geo.size.width, height: geo.size.width)
                            .scaleEffect(0.9)
                
                }//VStack
                
                VStack(alignment: .leading) {
                    
                    Spacer()
                    
                    //컬러피커
                    CharacterColorPickerView()
                        .frame(height: 50)
                        .scaleEffect(0.9)
                        .opacity(1)
                        .padding(.bottom, 64)
                    
                   
                        HStack {
                          
                            Button (action: {
                            }) {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(.clear)
                                    .frame(height: 56)
                            }
                         
                            Button (action: {
                        
                            }) {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(.clear)
                                    .frame(height: 56)
                            }
                            .disabled(true)
                        }//HStack
                }//VStack
            }//GeometryReader
            .padding(24)
            
            VStack(alignment: .center){
                
                Text("오늘의 날씨에 따라 배경이 바뀌어요!")
                    .foregroundColor(.white)
                    .font(.custom(.font.yeondeokSea, size: 24))
                    .padding(.vertical, 96)
                    .offset(y: 24)
                
                Spacer()
                
                Text("오늘의 나는 무슨 색인가요?")
                    .foregroundColor(.white)
                    .font(.custom(.font.yeondeokSea, size: 24))
                    .offset(y: -24)
                
                Button(action: {
                    DispatchQueue.main.async {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            tutorialToggle = false
                        }
                    }
                }) {
                    HStack {
                        Spacer()
                        Text("NEXT")
                            .foregroundColor(.white)
                        .font(.custom(.font.yeondeokSea, size: 24))
                    }
                    .padding()
                }
            }
        }
    }
}
