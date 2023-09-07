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
    
    var body: some View {
        
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
            NicknameView(nickname: $nickname)
                .environmentObject(viewRouter)
        case .attendance:
            
//            WeatherTestView()
//                .environmentObject(locationManager)
//                .environmentObject(environmentViewModel)

////            let record = attendanceViewModel.ensureCurrentRecord()
            AttendanceView(eyeViewController: EyeViewController())
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
            NicknameView(nickname: $nickname)
                .environmentObject(viewRouter)

//            FixAptView()
//                .environmentObject(viewRouter)
//                .environmentObject(aptModel)
//                .environmentObject(attendanceViewModel)
//                .environmentObject(environmentViewModel)
//                .environmentObject(characterViewModel)
//                .environmentObject(locationManager)
//                .task(priority: .userInitiated) {
//                    await environmentViewModel.getWeather(latitude: locationManager.latitude, longitude: locationManager.longitude)
//                }
                
        default:
            LoginView()
                .environmentObject(LoginViewModel(viewRouter: ViewRouter()))
        }
    }
}
