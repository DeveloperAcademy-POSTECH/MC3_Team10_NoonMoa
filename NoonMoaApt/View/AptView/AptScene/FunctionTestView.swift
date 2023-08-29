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
    @EnvironmentObject var weatherKitManager: WeatherKitManager
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
                    weatherKitManager.getWeather(latitude: locationManager.latitude, longitude: locationManager.longitude)
                    environmentModel.environmentRecord?.rawWeather = weatherKitManager.condition
//                    environmentModel.getCurrentEnvironment()
         
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
                    let array = ["sunrise", "morning", "afternoon", "sunset", "evening", "night"]
                    indexTime = (indexTime + 7) % 6
                    environmentModel.environmentRecordViewData.time = array[indexTime]
                    print(indexTime)
                    print(environmentModel.environmentRecordViewData.time)
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
                    let array = ["clear", "cloudy", "rainy", "snowy"]
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
//                    EyeViewController().resetFaceAnchor()
//                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                }) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.white)
                        .frame(width: 80, height: 48)
                        .overlay(
                            Text("Reset\nFace")
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
}

struct FunctionTestView_Previews: PreviewProvider {
    
    static var previews: some View {
        FunctionTestView()
            .environmentObject(ViewRouter())
            .environmentObject(EnvironmentViewModel())
    }
}
