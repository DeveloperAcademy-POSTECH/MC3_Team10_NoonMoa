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
        
        LottieView(name: environmentViewModel.environmentViewData.lottieImageName, animationSpeed: 1)
            .ignoresSafeArea()
            .opacity(0.6)
    }
}

struct SceneWeather_Previews: PreviewProvider {
    static var previews: some View {
        SceneWeather()
            .environmentObject(EnvironmentViewModel())
    }
}
