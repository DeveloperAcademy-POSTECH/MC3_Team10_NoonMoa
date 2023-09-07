//
//  MainView.swift
//  MangMongApt
//
//  Created by kimpepe on 2023/07/15.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @StateObject var aptModel: AptModel
    @StateObject var attendanceViewModel: AttendanceViewModel
    @StateObject var characterViewModel: CharacterViewModel
    @StateObject var environmentViewModel: EnvironmentViewModel
    @StateObject var loginViewModel: LoginViewModel
    @StateObject var locationManager: LocationManager
    @State private var nickname: String = ""
    @State private var isTutorialOn: Bool = true
    
    var body: some View {
        ZStack {
        switch viewRouter.currentView {
        case .launchScreen:
            launchScreenView()
                .task(priority: .userInitiated) {
                    await environmentViewModel.getWeather(latitude: locationManager.latitude, longitude: locationManager.longitude)
                }
        case .onBoarding:
            OnboardingView()
                .environmentObject(viewRouter)
        case .login:
            LoginView()
                .environmentObject(LoginViewModel(viewRouter: ViewRouter()))
        case .nickname:
            NicknameView(isFromSettingView: .constant(false), nickname: $nickname)
                .environmentObject(viewRouter)
        case .attendance:
            
            //            WeatherTestView()
            //                .environmentObject(locationManager)
            //                .environmentObject(environmentViewModel)
            
            ////            let record = attendanceViewModel.ensureCurrentRecord()
            AttendanceView(eyeViewController: EyeViewController(), isTutorialOn: $isTutorialOn)
                .environmentObject(viewRouter)
                .environmentObject(attendanceViewModel)
                .environmentObject(environmentViewModel)
                .environmentObject(characterViewModel)
                .environmentObject(locationManager)
                .task(priority: .userInitiated) {
                    await environmentViewModel.getWeather(latitude: locationManager.latitude, longitude: locationManager.longitude)
                }
            
        case .apt:
            //            WeatherTestView()
            //            NicknameView(nickname: $nickname)
            //                .environmentObject(viewRouter)
            //                SettingView(nickname: $nickname)
            //
            FixAptView(nickname: $nickname, isTutorialOn: $isTutorialOn)
                .environmentObject(viewRouter)
                .environmentObject(aptModel)
                .environmentObject(attendanceViewModel)
                .environmentObject(environmentViewModel)
                .environmentObject(loginViewModel)
                .environmentObject(characterViewModel)
                .environmentObject(locationManager)
                .task(priority: .userInitiated) {
                    await environmentViewModel.getWeather(latitude: locationManager.latitude, longitude: locationManager.longitude)
                }
            
        default:
            LoginView()
                .environmentObject(LoginViewModel(viewRouter: ViewRouter()))
        }
    }
            .onAppear {
                isTutorialOn = UserDefaults.standard.value(forKey: "tutorial") as? Bool ?? true
            }
    }
}
