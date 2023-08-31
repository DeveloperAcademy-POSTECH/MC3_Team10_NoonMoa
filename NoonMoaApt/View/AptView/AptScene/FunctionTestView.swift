//
//  FunctionTestView.swift
//  MC3
//
//  Created by 최민규 on 2023/07/17.
//

import SwiftUI

struct FunctionTestView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var environmentModel: EnvironmentViewModel
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var aptModel: AptModel
    @EnvironmentObject var loginViewModel: LoginViewModel
    
    @State private var indexTime: Int = 0
    @State private var indexWeather: Int = 0
    
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            HStack(spacing: 8) {
                Button {
                    loginViewModel.isLogInDone = false
                    loginViewModel.logout()
                    viewRouter.currentView = .login
                } label: {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.white)
                        .frame(width: 80, height: 48)
                        .overlay(
                            Text("Sign Out")
                                .foregroundColor(.black)
                                .font(.caption)
                        )
                        .opacity(0.3)
                }

                
                Button(action: {
                    
                    
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                }) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.white)
                        .frame(width: 80, height: 48)
                        .overlay(
                            Text("Get\nWeather")
                                .foregroundColor(.black)
                                .font(.caption)
                        )
                        .opacity(0.3)
                }
                
                Button(action: {
                    indexTime = (indexTime + 7) % 6
                    environmentModel.environmentViewData.colorOfSky = generateArrayOfSkyForTimeShuffle(weather: environmentModel.environmentViewData.weather)[indexTime]
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                }) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.white)
                        .frame(width: 80, height: 48)
                        .overlay(
                            Text("Day/Night")
                                .foregroundColor(.black)
                                .font(.caption)
                        )
                        .opacity(0.3)
                }
                Button(action: {
                    indexWeather = (indexWeather + 5) % 4
                    
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                }) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.white)
                        .frame(width: 80, height: 48)
                        .overlay(
                            Text("Weather\nShuffle")
                                .foregroundColor(.black)
                                .font(.caption)
                        )
                        .opacity(0.3)
                }
                
            }
            .padding(.horizontal)
            
            HStack(spacing: 8) {
                
                Button(action: {
                    loginViewModel.deleteUserAccount()
                    loginViewModel.isLogInDone = false
                    viewRouter.currentView = .login
                }) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.white)
                        .frame(width: 80, height: 48)
                        .overlay(
                            Text("Account Deleted")
                                .foregroundColor(.black)
                                .font(.caption)
                        )
                        .opacity(0.3)
                }
                Button(action: {
                    viewRouter.currentView = .onBoarding
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                }) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.white)
                        .frame(width: 80, height: 48)
                        .overlay(
                            Text("OnBoarding\nView")
                                .foregroundColor(.black)
                                .font(.caption)
                        )
                        .opacity(0.3)
                }
                
                Button(action: {
                    viewRouter.currentView = .attendance
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                }) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.white)
                        .frame(width: 80, height: 48)
                        .overlay(
                            Text("Attendance\nView")
                                .foregroundColor(.black)
                                .font(.caption)
                        )
                        .opacity(0.3)
                }
                Button(action: {
                    
                    // 아파트 정보 갱신
                    DispatchQueue.global(qos: .utility).async {
                        aptModel.fetchCurrentUserApt()
                    }
                }) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.white)
                        .frame(width: 80, height: 48)
                        .overlay(
                            Text("Update\nAptView")
                                .foregroundColor(.black)
                                .font(.caption)
                        )
                        .opacity(0.3)
                }
            }
            .padding(.horizontal)
        }
    }
    func generateArrayOfSkyForTimeShuffle(weather: String) -> [LinearGradient] {
        switch weather {
        case "clear" : return [LinearGradient.sky.clearSunrise, LinearGradient.sky.clearMorning, LinearGradient.sky.clearAfternoon, LinearGradient.sky.clearSunset, LinearGradient.sky.clearEvening, LinearGradient.sky.clearNight];
        case "cloudy" : return [LinearGradient.sky.clearSunrise, LinearGradient.sky.cloudyMorning, LinearGradient.sky.cloudyAfternoon, LinearGradient.sky.cloudySunset, LinearGradient.sky.cloudyEvening, LinearGradient.sky.cloudyNight];
        case "rainy" : return [LinearGradient.sky.clearSunrise, LinearGradient.sky.rainyMorning, LinearGradient.sky.rainyAfternoon, LinearGradient.sky.rainySunset, LinearGradient.sky.rainyEvening, LinearGradient.sky.rainyNight];
        case "snowy" : return [LinearGradient.sky.clearSunrise, LinearGradient.sky.snowyMorning, LinearGradient.sky.snowyAfternoon, LinearGradient.sky.snowySunset, LinearGradient.sky.snowyEvening, LinearGradient.sky.snowyNight];
        default : return []
        }
    }
}

struct FunctionTestView_Previews: PreviewProvider {
    
    static var previews: some View {
        FunctionTestView()
            .environmentObject(ViewRouter())
            .environmentObject(EnvironmentViewModel())
    }
}
