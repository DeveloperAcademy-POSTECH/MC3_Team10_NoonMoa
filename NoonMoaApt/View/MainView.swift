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
    @StateObject var attendanceModel: AttendanceModel
    @StateObject var characterViewModel: CharacterViewModel
    @StateObject var environmentViewModel: EnvironmentViewModel
    @StateObject var loginViewModel: LoginViewModel
    @StateObject var locationManager: LocationManager
    
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
        case .attendance:
            
//            WeatherTestView()
//                .environmentObject(locationManager)
//                .environmentObject(environmentViewModel)

////            let record = attendanceModel.ensureCurrentRecord()
            AttendanceView(eyeViewController: EyeViewController())
                .environmentObject(viewRouter)
                .environmentObject(attendanceModel)
                .environmentObject(environmentViewModel)
                .environmentObject(characterViewModel)
                .environmentObject(locationManager)
                .task(priority: .userInitiated) {
                    await environmentViewModel.getWeather(latitude: locationManager.latitude, longitude: locationManager.longitude)
                }
                
        case .apt:
//            WeatherTestView()
            FixAptView()
                .environmentObject(viewRouter)
                .environmentObject(aptModel)
                .environmentObject(attendanceModel)
                .environmentObject(environmentViewModel)
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
}
