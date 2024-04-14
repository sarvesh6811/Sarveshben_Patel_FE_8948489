
import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var zoomControl: UISlider!
    var locationTracker: CLLocationManager!
    var initialLocation: CLLocationCoordinate2D?
    var destinationLocation: CLLocationCoordinate2D?
    var locationQuery: String?
    var historyViewController: HistoryViewController? // Reference to HistoryViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeLocationManager()
        mapView.delegate = self
        if let locationName = locationQuery {
            placeDestinationMarker(cityName: locationName)
        }
    }

    func initializeLocationManager() {
        locationTracker = CLLocationManager()
        locationTracker.delegate = self
        locationTracker.requestWhenInUseAuthorization()
        locationTracker.startUpdatingLocation()
    }

    @IBAction func zoomControlValueChanged(_ sender: UISlider) {
        let zoomFactor = CLLocationDegrees(sender.value)
        let region = MKCoordinateRegion(center: mapView.centerCoordinate, span: MKCoordinateSpan(latitudeDelta: zoomFactor, longitudeDelta: zoomFactor))
        mapView.setRegion(region, animated: true)
    }

    @IBAction func planRoute(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Enter Locations", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Start Location"
        }
        
        alertController.addTextField { textField in
            textField.placeholder = "End Location"
        }
        
        let confirmAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            guard let startLocation = alertController.textFields?.first?.text,
                  let endLocation = alertController.textFields?.last?.text else { return }
            
            // Generate route and display it on the map
            self?.placeStartAndEndLocations(startLocation: startLocation, endLocation: endLocation)
            
            // Create a map interaction and save it to history
            let mapDetails = "Start: \(startLocation), End: \(endLocation), Mode: Driving, Distance: 44 km"
            let mapInteraction = Interaction(source: .map, type: .map, details: mapDetails, dateTime: Date())
            // Assuming there's a reference to HistoryViewController, call saveInteraction method
            self?.historyViewController?.saveInteraction(mapInteraction)
        }
        
        alertController.addAction(confirmAction)
        present(alertController, animated: true)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first, initialLocation == nil {
            initialLocation = location.coordinate
            let startPoint = MKPointAnnotation()
            startPoint.coordinate = location.coordinate
            startPoint.title = "Start Location"
            mapView.addAnnotation(startPoint)
        }
    }

    func placeDestinationMarker(cityName: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(cityName) { [weak self] (placemarks, error) in
            guard let strongSelf = self, let placemark = placemarks?.first, let location = placemark.location else { return }
            strongSelf.destinationLocation = location.coordinate
            let endPoint = MKPointAnnotation()
            endPoint.coordinate = location.coordinate
            endPoint.title = cityName
            strongSelf.mapView.addAnnotation(endPoint)
            strongSelf.generateRoute(from: strongSelf.initialLocation!, to: location.coordinate, travelMode: .automobile) // Default mode
        }
    }

    func modifyRoute(travelMode: MKDirectionsTransportType) {
        guard let initialLocation = self.initialLocation, let destinationLocation = self.destinationLocation else { return }
        generateRoute(from: initialLocation, to: destinationLocation, travelMode: travelMode)
    }

    func generateRoute(from startCoordinate: CLLocationCoordinate2D, to endCoordinate: CLLocationCoordinate2D, travelMode: MKDirectionsTransportType) {
        mapView.removeOverlays(mapView.overlays)

        let startPlacemark = MKPlacemark(coordinate: startCoordinate)
        let endPlacemark = MKPlacemark(coordinate: endCoordinate)

        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: startPlacemark)
        request.destination = MKMapItem(placemark: endPlacemark)
        request.transportType = travelMode

        let directions = MKDirections(request: request)
        directions.calculate { [unowned self] (response, error) in
            guard let route = response?.routes.first else { return }
            self.mapView.addOverlay(route.polyline, level: .aboveRoads)
            self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
        }
    }
    
    func placeStartAndEndLocations(startLocation: String, endLocation: String) {
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(startLocation) { [weak self] (startPlacemarks, startError) in
            guard let strongSelf = self, let startPlacemark = startPlacemarks?.first else {
                // Handle error or show message that start location is invalid
                return
            }
            
            geocoder.geocodeAddressString(endLocation) { (endPlacemarks, endError) in
                guard let endPlacemark = endPlacemarks?.first else {
                    // Handle error or show message that end location is invalid
                    return
                }
                
                strongSelf.generateRoute(from: startPlacemark.location!.coordinate, to: endPlacemark.location!.coordinate, travelMode: .automobile)
            }
        }
    }

    @IBAction func setAutoTravel(_ sender: UIButton) {
        modifyRoute(travelMode: .automobile)
    }

    @IBAction func setBikeTravel(_ sender: UIButton) {
        modifyRoute(travelMode: .walking)
    }

    @IBAction func setWalkingTravel(_ sender: UIButton) {
        modifyRoute(travelMode: .walking)
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = UIColor.blue
            renderer.lineWidth = 4
            return renderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
}
