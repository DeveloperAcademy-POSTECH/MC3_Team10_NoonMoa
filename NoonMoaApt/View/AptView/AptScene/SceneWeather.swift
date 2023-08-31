//
//  SceneWeather.swift
//  MC3
//
//  Created by 최민규 on 2023/07/15.
//

import SwiftUI
import Lottie

struct SceneWeather: View {
    @EnvironmentObject var environmentViewModel: EnvironmentViewModel

    var body: some View {
        
        //이렇게 분기처리한 이유: 로띠는 뷰를 다시 그려도 이전 재생중이던 애니메이션이 실행되어 업데이트가 되지 않았다.
        switch environmentViewModel.environment?.rawWeather {
        case "clear":
            LottieView(name: Lottie.clearMorning, animationSpeed: 1)
                .ignoresSafeArea()
                .opacity(0.6)
        case "cloudy":
            LottieView(name: Lottie.cloudyMorning, animationSpeed: 1)
                .ignoresSafeArea()
                .opacity(0.6)
        case "rainy":
            LottieView(name: Lottie.rainyMorning, animationSpeed: 1)
                .ignoresSafeArea()
                .opacity(0.6)
        case "snowy":
            LottieView(name: Lottie.snowyMorning, animationSpeed: 1)
                .ignoresSafeArea()
        default: EmptyView()
        }
    }
}

struct SceneWeather_Previews: PreviewProvider {
    static var previews: some View {
        SceneWeather()
            .environmentObject(EnvironmentViewModel())
    }
}
