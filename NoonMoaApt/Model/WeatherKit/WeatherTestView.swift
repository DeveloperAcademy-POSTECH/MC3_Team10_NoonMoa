import SwiftUI
import WeatherKit
import CoreLocation

struct WeatherTestView: View {
    @EnvironmentObject var weatherKitManager: WeatherKitManager
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var environmentViewModel: EnvironmentViewModel
    @State private var dateHour: Int = 0
    @State private var sunriseHour: Int = 0
    @State private var sunsetHour: Int = 0
    
    var body: some View {
        
        if locationManager.authorisationStatus == .authorizedWhenInUse {
            VStack {
                Label(weatherKitManager.symbol, systemImage: weatherKitManager.symbol)
                Text(weatherKitManager.condition ?? "111")
                Text(weatherKitManager.temp)
                
                Text(environmentViewModel.environment?.rawWeather ?? "nil")
                Text(String(describing: environmentViewModel.environment?.rawTime ?? Date()))
                Text(String(describing: environmentViewModel.environment?.rawSunriseTime ?? Date()))
                Text(String(describing: environmentViewModel.environment?.rawSunsetTime ?? Date()))

                Button(action: {
                    DispatchQueue.main.async {
                        environmentViewModel.convertWeatherToEnvironmentRecord(using: weatherKitManager)
                        environmentViewModel.convertRawDataToEnvironment(isInputAttndanceRecord: false, environmentModel: environmentViewModel.environment ?? EnvironmentRecord(rawWeather: "", rawTime: Date(), rawSunriseTime: Date(), rawSunsetTime: Date()))
                    }
                    print("아아아아ㅏ아아")
                }) {
                    Text("Button")
                }
            }
            .task(priority: .userInitiated) {
                    await weatherKitManager.getWeather(latitude: locationManager.latitude, longitude: locationManager.longitude)
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
