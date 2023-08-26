import SwiftUI
import WeatherKit
import CoreLocation

struct WeatherTestView: View {
    @EnvironmentObject var weatherKitManager: WeatherKitManager
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var environmentModel: EnvironmentModel

    var body: some View {

        if locationManager.authorisationStatus == .authorizedWhenInUse {
            VStack {
                Label(weatherKitManager.symbol, systemImage: weatherKitManager.symbol)
                Text(weatherKitManager.condition)
                Text(weatherKitManager.temp)
                Button(action: {  weatherKitManager.getWeather(latitude: 4, longitude: 45)
                    environmentModel.rawWeather = weatherKitManager.condition
                    print("hello")

                }) {
                    Text("Button")
                }
                Text(String(locationManager.latitude))
                Text(String(locationManager.longitude))
                Text(String(environmentModel.rawWeather))
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
