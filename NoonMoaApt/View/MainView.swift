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
    @StateObject var characterModel: CharacterModel
    @StateObject var environmentModel: EnvironmentModel
    @StateObject var customViewModel: CustomViewModel
    @StateObject var loginViewModel: LoginViewModel
    @StateObject var weatherKitManager: WeatherKitManager
    @StateObject var locationManager: LocationManager

    
    var body: some View {
        
        switch viewRouter.currentView {
        case .launchScreen:
            launchScreenView()
        case .onBoarding:
            OnboardingView()
                .environmentObject(viewRouter)
        case .login:
            LoginView()
                .environmentObject(LoginViewModel(viewRouter: ViewRouter()))
        case .attendance:
            
//            WeatherTestView()
//                .environmentObject(weatherKitManager)
//                .environmentObject(locationManager)
//                .environmentObject(environmentModel)

////            let record = attendanceModel.ensureCurrentRecord()
            AttendanceView(eyeViewController: EyeViewController())
                .environmentObject(viewRouter)
                .environmentObject(attendanceModel)
                .environmentObject(environmentModel)
                .environmentObject(characterModel)
                .environmentObject(customViewModel)
                .environmentObject(weatherKitManager)
                .environmentObject(locationManager)
        case .apt:
//            WeatherTestView()
            AptView()
                .environmentObject(viewRouter)
                .environmentObject(aptModel)
                .environmentObject(attendanceModel)
                .environmentObject(environmentModel)
                .environmentObject(characterModel)
                .environmentObject(customViewModel)
                .environmentObject(weatherKitManager)
                .environmentObject(locationManager)
                
        default:
            LoginView()
                .environmentObject(LoginViewModel(viewRouter: ViewRouter()))
        }
    }
}
