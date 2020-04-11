import Foundation

struct WeatherModel {
    let conditionId : Int
    let cityName : String
    let temperatur :Double
    let description : String
 
    var temperatureString : String {
        String(format: "%.1f", temperatur)
    }
    var conditionName : String {
        switch conditionId {
            
        case (200...232):
            return "cloud.bolt"
            
        case (300...321):
            return "cloud.drizzle"
            
        case (500...531):
            return "cloud.rain"
            
        case (600...622):
            return "cloud.snow"
            
        case (700...781):
            return "cloud.fog"
            
        case (800):
            return "sun.max"
            
        case (801):
            return "cloud.sun"
            
        case (802...804):
            return "cloud"
            
        default:
            return "cloud"
        }
    }
}

