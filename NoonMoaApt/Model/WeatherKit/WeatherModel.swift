import Foundation
import WeatherKit

@MainActor class WeatherKitManager: ObservableObject {
    @Published var weather: Weather?
    
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
}
