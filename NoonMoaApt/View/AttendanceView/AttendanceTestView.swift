//
//  AttendanceTestView.swift
//  NoonMoaApt
//
//  Created by kimpepe on 2023/08/03.
//

import SwiftUI

struct AttendanceTestView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var environmentModel: EnvironmentModel
    @EnvironmentObject var weatherKitManager: WeatherKitManager
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var aptModel: AptModel
    
    @State private var indexTime: Int = 0
    @State private var indexWeather: Int = 0
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    let array = ["sunrise", "morning", "afternoon", "sunset", "evening", "night"]
                    indexTime = (indexTime + 7) % 6
                    environmentModel.currentTime = array[indexTime]
                    environmentModel.convertEnvironmentToViewData(isInputCurrentData: true, weather: environmentModel.currentWeather, time: environmentModel.currentTime, isThunder: environmentModel.currentIsThunder)
                    print(indexTime)
                    print(environmentModel.currentTime)
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
                    environmentModel.currentWeather = array[indexWeather]
                    print(indexWeather)
                    print(environmentModel.currentWeather)
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
            Spacer()
        }
    }
}

struct AttendanceTestView_Previews: PreviewProvider {
    static var previews: some View {
        AttendanceTestView()
    }
}
