//
//  MapViewController.swift
//  UIComponents
//
//  Created by Semih Emre ÜNLÜ on 9.01.2022.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkLocationPermission()
        addLongGestureRecognizer()
    }
    
    // MARK: - Functions
    
    func addLongGestureRecognizer() {
        let longPressGesture = UILongPressGestureRecognizer(target: self,
                                                            action: #selector(handleLongPressGesture(_ :)))
        self.view.addGestureRecognizer(longPressGesture)
    }
    
    @objc func handleLongPressGesture(_ sender: UILongPressGestureRecognizer) {
        let point = sender.location(in: mapView)
        let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "Pinned"
        mapView.addAnnotation(annotation)
    }
    
    func checkLocationPermission() {
        switch self.locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse, .authorized:
            locationManager.requestLocation()
        case .denied, .restricted:
            //popup gosterecegiz. go to settings butonuna basildiginda
            //kullaniciyi uygulamamizin settings sayfasina gonder
            popupAlertController()
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        @unknown default:
            fatalError()
        }
    }
    
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
    
    private lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        return locationManager
    }()
    
    // MARK: - IBActions
    
    @IBAction func showCurrentLocationTapped(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
}

// MARK: - Extensions

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinate = locations.first?.coordinate else { return }
        print("latitude: \(coordinate.latitude)")
        print("longitude: \(coordinate.longitude)")
        
        mapView.setCenter(coordinate, animated: true)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationPermission()
    }
    
}
