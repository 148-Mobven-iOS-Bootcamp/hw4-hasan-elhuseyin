//
//  MapViewController.swift
//  UIComponents
//
//  Created by Semih Emre ÜNLÜ on 9.01.2022.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Show app section in settings app
        // UserDefaults.standard.register(defaults: [String : Any]())
        
        // Check the location permission
        checkLocationPermission()
        // Add a long gesture recognizer
        addLongGestureRecognizer()
    }
    
    // MARK: - Variables
    
    // Create a CLLocationManager object and set its delegate to self
    private lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        return locationManager
    }()
    
    // MARK: - Functions
    
    // Add long gesture recognizer function
    func addLongGestureRecognizer() {
        let longPressGesture = UILongPressGestureRecognizer(target: self,
                                                            action: #selector(handleLongPressGesture(_ :)))
        self.view.addGestureRecognizer(longPressGesture)
    }
    
    // Selector objective-c function for addLongGestureRecognizer()
    @objc func handleLongPressGesture(_ sender: UILongPressGestureRecognizer) {
        // Get the location from mapView
        let point = sender.location(in: mapView)
        // Convert the location to coordinates
        let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
        // Create MKPointAnnotation object
        let annotation = MKPointAnnotation()
        // Set the annotation coordinate to the coordinate we got from mapView
        annotation.coordinate = coordinate
        // Set the annotation title
        annotation.title = "Pinned"
        // Add the annotation to mapView
        mapView.addAnnotation(annotation)
    }
    
    // Function to check the location permission
    func checkLocationPermission() {
        switch self.locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse, .authorized:
            // If the location permission is authorized; request the location
            locationManager.requestLocation()
        case .denied, .restricted:
            // If the location permission is denied or restricted; show a popup and redirect to the settings app
            popupAlertController()
            break
        case .notDetermined:
            // If the location permission is not determined; request for authorization
            locationManager.requestWhenInUseAuthorization()
        @unknown default:
            fatalError()
        }
    }
    
    // Function to show a popup alert controller that redirects the user to the settings app
    func popupAlertController() {
        // Create UIAlertController object
        let alertController = UIAlertController(title: "Location Permission Required",
                                                message: "Please enable location permissions in settings.",
                                                preferredStyle: .alert)
        
        // Set the ok action for the alert
        let okAction = UIAlertAction(title: "Settings", style: .default, handler: {(cAlertAction) in
            // Redirect to Settings app
            UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
        })
        
        // Set the cancel action for the alert
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        // Add ok and cancel actions to the alert
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        // Present the alert
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - IBActions
    
    @IBAction func showCurrentLocationTapped(_ sender: UIButton) {
        // Request the location when this button is tapped
        locationManager.requestLocation()
    }
    
}

// MARK: - Extensions

// Extension to update the map center when the location is updated
extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinate = locations.first?.coordinate else { return }
        print("latitude: \(coordinate.latitude)")
        print("longitude: \(coordinate.longitude)")
        
        mapView.setCenter(coordinate, animated: true)
    }
    
    // If 'didFailWithError'; run checkLocationPermission()
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        checkLocationPermission()
    }
    
}
