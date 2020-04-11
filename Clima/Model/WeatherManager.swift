import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager : WeatherManager, weather: WeatherModel)
    
    func didFailWithError(error : Error)
}


struct WeatherManager {
    var url = "https://api.openweathermap.org/data/2.5/weather?appid=0a49a90f0c47b9ddd944cf834a21e687&units=metric"
    
    
    var delgate : WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
       // let urlString = "\(url)&q=\(cityName)"
        urlEncoderForCity(urlString: cityName)
    }
    
    func fetchWeather(latitude : CLLocationDegrees, longitude : CLLocationDegrees)  {
        //let urlString = "\(url)&lat=\(latitude)&lon=\(longitude)"
        urlEncoderForCoordinates(lon: longitude, lat: latitude)
    }
    
    func urlEncoderForCity(urlString : String) {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.openweathermap.org"
        components.path = "/data/2.5/weather"
        components.queryItems = [
            URLQueryItem(name: "appid", value: "0a49a90f0c47b9ddd944cf834a21e687"),
            URLQueryItem(name: "units", value: "metric"),
            URLQueryItem(name: "q", value: urlString)
        ]
        let urlString = components.url
        performRequest(with: urlString!)
    }
    
    func urlEncoderForCoordinates(lon : CLLocationDegrees, lat: CLLocationDegrees) {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.openweathermap.org"
        components.path = "/data/2.5/weather"
        components.queryItems = [
            URLQueryItem(name: "appid", value: "0a49a90f0c47b9ddd944cf834a21e687"),
            URLQueryItem(name: "units", value: "metric"),
            URLQueryItem(name: "lat", value: "\(lat)"),
            URLQueryItem(name: "lon", value: "\(lon)")
        ]
        let urlString = components.url
        performRequest(with: urlString!)
    }
    
    //Send a request to the webserver with the url and get the data
    func performRequest(with urlString : URL) {
     
        //1. Create URL
        let url = urlString
            print ("Url: ",url)
            //2. Create URLSession
            let session = URLSession(configuration: .default)
            
            //3. Give the session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil{
                    self.delgate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                   if let weather = self.parseJSON(safeData){
                    self.delgate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            //4. Start the task
            task.resume()
        
    }
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let cityName = decodedData.name
            let temp = decodedData.main.temp
            let id = decodedData.weather[0].id
            let description = decodedData.weather[0].description
            
            let weather = WeatherModel(conditionId: id, cityName: cityName, temperatur: temp, description: description)
          //  weather.conditionName
            return weather
        }
        catch {
            delgate?.didFailWithError(error: error)
            return nil
        }
        
    }
    
}
