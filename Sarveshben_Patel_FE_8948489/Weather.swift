import UIKit
import CoreLocation
import CoreData

class WeatherViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!

    @IBOutlet weak var locationLabel: UILabel!
    let locationManager = CLLocationManager()
    let weatherAPIKey = "c9104f9a911c20731f5b79a3426b4bcd"
    var selectedLocation: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()

        if let location = selectedLocation {
            fetchWeatherData(forCity: location)
        } else {
            fetchWeatherData(forCity: "Waterloo")
        }
    }

    // Input button for location
    @IBAction func showCityInputAlert(_ sender: UIButton) {
        let alert = UIAlertController(title: "Where would you like to go \n Enter your destination  here", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "City Name"
        }
        let submitAction = UIAlertAction(title: "OK", style: .default) { [unowned self, alert] _ in
            if let cityName = alert.textFields?.first?.text {
                self.fetchWeatherData(forCity: cityName)
            }
        }
        alert.addAction(submitAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)

        present(alert, animated: true)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let _ = locations.first {
            // Handle location update
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }

    // Call data of city name
    func fetchWeatherData(forCity cityName: String) {
        guard let encodedCityName = cityName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(encodedCityName)&appid=\(weatherAPIKey)"
        performWeatherRequest(with: urlString)
    }

    // Weather Request
    func performWeatherRequest(with urlString: String) {
        guard let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else { return }

        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil else { return }

            do {
                let json = try JSONDecoder().decode(WeatherData.self, from: data)
                DispatchQueue.main.async {
                    self?.updateUI(with: json)
                }
            } catch {
                print("JSON Decoding Error: \(error)")
            }
        }
        task.resume()
    }

    func kelvinToCelsius(kelvin: Double) -> Double {
        return kelvin - 273.15
    }

    // To show data
    func updateUI(with weatherData: WeatherData) {
        cityNameLabel.text = weatherData.name
        locationLabel.text = weatherData.name
        weatherDescriptionLabel.text = weatherData.weather.first?.description

        let tempCelsius = kelvinToCelsius(kelvin: weatherData.main.temp)
        let roundedTempCelsius = round(tempCelsius)
        let formattedTemp = String(format: "%.0f", roundedTempCelsius)
        temperatureLabel.text = "\(formattedTemp) °C"

        humidityLabel.text = "\(weatherData.main.humidity)%"
        let speedInKmPH = weatherData.wind.speed * 3.6
        windSpeedLabel.text = String(format: "%.2f km/h", speedInKmPH)

        if let iconCode = weatherData.weather.first?.icon {
            updateWeatherIcon(with: iconCode)
        }
    }

    // Update Weather Icon
    func updateWeatherIcon(with iconCode: String) {
        let iconName = mapIconCodeToAssetName(iconCode)
        weatherIconImageView.image = UIImage(named: iconName)
    }
    func saveWeatherData(_ weatherData: WeatherData) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "WeatherDataEntity", in: managedContext)!
        let weather = NSManagedObject(entity: entity, insertInto: managedContext)

        weather.setValue(Date(), forKey: "dateTime")  // Store current date and time
        weather.setValue(weatherData.main.temp, forKey: "temperature")
        weather.setValue(weatherData.main.humidity, forKey: "humidity")
        weather.setValue(weatherData.weather.first?.description, forKey: "weatherDescription")
        weather.setValue(weatherData.wind.speed, forKey: "windSpeed")

        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    

    
    func mapIconCodeToAssetName(_ code: String) -> String {
        switch code {
        case "01d": return "clearSkyDAY"
        case "01n": return "clearSkyNight"
        case "02d": return "fewCloudsDAY"
        case "02n": return "fewCloudsNight"
        case "03d", "03n": return "scatteredClouds"
        case "04d", "04n": return "brokenClouds"
        case "09d", "09n": return "showerRain"
        case "10d": return "rainDay"
        case "10n": return "rainNight"
        case "11d": return "thunderstorm"
        case "13d": return "snow"
        case "50d": return "mist"
        default: return "default"
        }
    }
}

// Weather Data Structures
struct WeatherData: Codable {
    let name: String
    let weather: [Weather]
    let main: Main
    let wind: Wind
}

struct Weather: Codable {
    let description: String
    let icon: String
}

struct Main: Codable {
    let temp: Double
    let humidity: Int
}

struct Wind: Codable {
    let speed: Double
}

//
//import UIKit
//import CoreLocation
//
//class WeatherViewController: UIViewController, CLLocationManagerDelegate {
//
//    @IBOutlet weak var cityNameLabel: UILabel!
//    @IBOutlet weak var weatherDescriptionLabel: UILabel!
//    @IBOutlet weak var weatherIconImageView: UIImageView!
//    @IBOutlet weak var temperatureLabel: UILabel!
//    @IBOutlet weak var humidityLabel: UILabel!
//    @IBOutlet weak var windSpeedLabel: UILabel!
//
//    @IBOutlet weak var locationLabel: UILabel!
//    let locationManager = CLLocationManager()
//    let weatherAPIKey = "c9104f9a911c20731f5b79a3426b4bcd"
//    var selectedLocation: String?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        locationManager.delegate = self
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.requestLocation()
//
//        if let location = selectedLocation {
//            fetchWeatherData(forCity: location)
//        } else {
//            fetchWeatherData(forCity: "Waterloo")
//        }
//    }
//
//    // Input button for location
//    @IBAction func showCityInputAlert(_ sender: UIButton) {
//        let alert = UIAlertController(title: "Where would you like to go \\n Enter your destination  here", message: nil, preferredStyle: .alert)
//        alert.addTextField { textField in
//            textField.placeholder = "City Name"
//        }
//        let submitAction = UIAlertAction(title: "OK", style: .default) { [unowned self, alert] _ in
//            if let cityName = alert.textFields?.first?.text {
//                self.fetchWeatherData(forCity: cityName)
//            }
//        }
//        alert.addAction(submitAction)
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//        alert.addAction(cancelAction)
//
//        present(alert, animated: true)
//    }
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if let _ = locations.first {
//            // Handle location updates here
//        }
//    }
//
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print("Failed to find user's location: \(error.localizedDescription)")
//    }
//
//    func fetchWeatherData(forCity city: String) {
//        // Implement weather data fetching here
//        // On success, update UI and save interaction
//        let weatherDescription = "Sunny" // Example weather description
//        weatherDescriptionLabel.text = weatherDescription
//        saveWeatherInteraction(weatherDescription: weatherDescription, city: city)
//    }
//
//    func saveWeatherInteraction(weatherDescription: String, city: String) {
//        let interaction = Interaction(
//            source: .weather,
//            type: .weather,
//            details: "\(city): \(weatherDescription)",
//            dateTime: Date()
//        )
//        // Call the method to save interaction to history
//        if let historyVC = presentingViewController as? HistoryViewController {
//            historyVC.saveInteraction(interaction)
//        }
//    }
//}
