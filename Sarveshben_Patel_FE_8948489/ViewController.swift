import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    // Outlets
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var bgImage: UIImageView!
    
    @IBOutlet weak var cityTemp: UILabel!
    
    @IBOutlet weak var wind: UILabel!
    @IBOutlet weak var cityHumidity: UILabel!
    let locationManager = CLLocationManager()
    let weatherAPIKey = "c9104f9a911c20731f5b79a3426b4bcd"
    override func viewDidLoad() {
        super.viewDidLoad()
        bgImage.alpha = 0.25
        locationManager.delegate = self
        map.showsUserLocation = true
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    //  CLLocationManagerDelegate Method
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            updateMapRegion(location)
            fetchWeatherData(for: location.coordinate)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }

    //Map Update
    private func updateMapRegion(_ location: CLLocation) {
        let region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        map.setRegion(region, animated: true)
    }

    // Fetch Weather Data
    private func fetchWeatherData(for coordinate: CLLocationCoordinate2D) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(coordinate.latitude)&lon=\(coordinate.longitude)&appid=\(weatherAPIKey)&units=metric"
        guard let url = URL(string: urlString) else { return }

        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil else { return }
            do {
                let weatherData = try JSONDecoder().decode(WeatherData.self, from: data)
                DispatchQueue.main.async {
                    self?.updateWeatherDisplay(with: weatherData)
                }
            } catch {
                print("Error decoding weather data: \(error)")
            }
        }
        task.resume()
    }

    // Update Weather Display
    private func updateWeatherDisplay(with weatherData: WeatherData) {
        cityTemp.text = String(format: "%.0f°C", weatherData.main.temp)
        wind.text = String(format: "%.1f km/h", weatherData.wind.speed * 3.6)  
        cityHumidity.text = "\(weatherData.main.humidity)%"
    }

    // Weather Data Model
    struct WeatherData: Codable {
        let main: Main
        let wind: Wind
    }

    struct Main: Codable {
        let temp: Double
        let humidity: Int
    }

    struct Wind: Codable {
        let speed: Double
    }
}
