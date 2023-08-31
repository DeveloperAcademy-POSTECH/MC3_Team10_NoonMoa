import Foundation
import WeatherKit

@MainActor class WeatherKitManager: ObservableObject {
    @Published var weather: Weather?
    @Published var condition: String?
    @Published var date: Date?
    @Published var sunrise: Date?
    @Published var sunset: Date?
    @Published var environment: EnvironmentRecord?

    func getWeather(latitude: Double, longitude: Double) async {
        print("getWeather | latitude: \(latitude), longtitude: \(longitude)")
        Task(priority: .userInitiated) {
            do {
                weather = try await Task(priority: .userInitiated) {
                    return try await WeatherService.shared.weather(for:.init(latitude: latitude, longitude: longitude))
                }.value
    
                self.condition = weather?.currentWeather.condition.rawValue ?? "shsh"
                self.date = Date()
                self.sunrise = weather?.dailyForecast[0].sun.sunrise
                self.sunset = weather?.dailyForecast[0].sun.sunset
                print(latitude)
                print(longitude)
                self.environment = EnvironmentRecord(rawWeather: condition!, rawTime: date!, rawSunriseTime: sunrise!, rawSunsetTime: sunset!)
//                EnvironmentViewModel().convertRawDataToEnvironment(isInputAttndanceRecord: false, environmentModel: EnvironmentViewModel().environment!)
                print(String(self.environment?.rawWeather ?? "안되네"))
            } catch {
                print("Weather error: \(error)")
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
}


