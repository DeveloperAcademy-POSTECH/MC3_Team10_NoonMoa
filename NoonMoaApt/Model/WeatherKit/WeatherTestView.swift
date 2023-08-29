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
                Text(weatherKitManager.condition)
                Text(weatherKitManager.temp)
                Text("dateHour: \(dateHour)")
                Text("sunriseHour: \(sunriseHour)")
                Text("sunsetHour: \(sunsetHour)")
               
                Button(action: {
                    weatherKitManager.getWeather(latitude: locationManager.latitude, longitude: locationManager.longitude)
                    environmentViewModel.environmentRecord?.rawWeather = weatherKitManager.condition
                    
                    //TODO: 어디 놓냐에 따라 실행 시기에 따라,
                    let myFormatter = DateFormatter()
                    myFormatter.dateFormat = "HH"  // 변환할 형식
                    self.dateHour = Int(myFormatter.string(from: Date())) ?? 0
                    self.sunriseHour = Int(myFormatter.string(from: weatherKitManager.sunrise)) ?? 0
                    self.sunsetHour = Int(myFormatter.string(from: weatherKitManager.sunset)) ?? 0

                }) {
                    Text("Button")
                }
                Text(String(locationManager.latitude))
                Text(String(locationManager.longitude))
                Text(String(environmentViewModel.environmentRecord?.rawWeather ?? "weather not available"))
            }
            .task {
                weatherKitManager.getWeather(latitude: locationManager.latitude, longitude: locationManager.longitude)
                print(locationManager.latitude)
                print(locationManager.longitude)
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
