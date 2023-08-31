import SwiftUI
import WeatherKit
import CoreLocation

struct WeatherTestView: View {
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var environmentViewModel: EnvironmentViewModel
    @State private var dateHour: Int = 0
    @State private var sunriseHour: Int = 0
    @State private var sunsetHour: Int = 0
    
    var body: some View {
        
        if locationManager.authorisationStatus == .authorizedWhenInUse {
            VStack {
                Label(environmentViewModel.symbol, systemImage: environmentViewModel.symbol)
                Text(environmentViewModel.environment.rawWeather)
                Text(String(describing: environmentViewModel.environment.rawSunriseTime))
                Text(String(describing: environmentViewModel.environment.rawSunsetTime))
                Text(environmentViewModel.temp)
                Text("---------")
                Text(environmentViewModel.environmentViewData.weather)
                Text(environmentViewModel.environmentViewData.time)
                Button(action: {
              
                }) {
                    Text("Button")
                }
            }
            .task(priority: .userInitiated) {
                    await environmentViewModel.getWeather(latitude: locationManager.latitude, longitude: locationManager.longitude)
                    print("weatherkit task")
                }
            
        } else {
            //사용자가 위치 허용하지 않았을 때
            Text("Error loading location")
        }
    }
}

struct WeatherTestView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherTestView()
    }
}
