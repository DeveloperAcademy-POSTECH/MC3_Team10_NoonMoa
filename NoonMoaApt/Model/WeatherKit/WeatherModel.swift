import Foundation
import WeatherKit

@MainActor class WeatherKitManager: ObservableObject {
    @Published var weather: Weather?
    @Published var sunEvents: Date?
    
    func getWeather(latitude: Double, longitude: Double) {
        print("getWeather | latitude: \(latitude), longtitude: \(longitude)")
        async {
            do {
                weather = try await Task.detached(priority: .userInitiated) {
                    print(latitude)
                    print(longitude)
                    return try await WeatherService.shared.weather(for:.init(latitude: latitude, longitude: longitude))
                }.value
            } catch {
                print("Weather error: \(error)") // Log any error
                fatalError("\(error)")
            }
        }
    }

    
    var symbol: String {
        weather?.currentWeather.symbolName ?? "xmark"
    }
    
    var temp: String {
        let temp = weather?.currentWeather.temperature
        let convertedTemp = temp?.converted(to: .celsius).description
        return convertedTemp ?? "Connecting to WeatherKit"
    }
    
    var condition: String {
        let condition = weather?.currentWeather.condition.rawValue
        return condition ?? "Connecting to WeatherKit"
    }
    
    //TODO: 현재 글로벌 타임으로 출력되는데, 우리가 시간의 text비교로 day/night 구분을 하기 때문에 해당 timezone으로 변형이 필요하다.
    //TODO: 비동기처리로 날씨를 받아오다보니, 변수에 반영되기 이전에 서버 저장이 이뤄질 가능성이 높다. 해결필요.
    var sunrise: Date {
        let sunrise = weather?.dailyForecast[0].sun.sunrise
//        let dateFormatter = DateFormatter()
//                   dateFormatter.dateFormat = "HH:mm"
//
//        let sunriseHour = dateFormatter.string(from: sunrise ?? Date())
        return sunrise ?? Date()
    }

    var sunset: Date {
        let sunset = weather?.dailyForecast[0].sun.sunset
//        let dateFormatter = DateFormatter()
//                   dateFormatter.dateFormat = "HH:mm"
//
//        let sunsetHour = dateFormatter.string(from: sunset ?? Date())
        return sunset ?? Date()
    }
}
