//
//  MapsVC.swift
//  GradutionThesis
//
//  Created by Buğra Tunçer on 26.02.2020.
//  Copyright © 2020 Buğra Tunçer. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
class OwnerMapsVC: UIViewController{
    
    let locationManager = CLLocationManager()
    @IBOutlet weak var locationText: UITextField!
    @IBOutlet weak var mapsView: GMSMapView!
    override func viewDidLoad() {
        self.makeAlert()
        super.viewDidLoad()
        getCurrentLocation()
        mapsView.settings.compassButton = true
        mapsView.settings.myLocationButton = true
        mapsView.isMyLocationEnabled = true
        // Do any additional setup after loading the view.
    }
    @IBAction func locationClicked(_ sender: Any) {
        goToPlaces()
    }
    func goToPlaces() {
        
        locationText.resignFirstResponder()
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        present(acController, animated: true, completion: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var ownerRegisterVC = segue.destination as! OwnerRegisterVC
        ownerRegisterVC.locationText = locationText.text!
        
    }
    
    func getCurrentLocation() {
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
}
extension OwnerMapsVC : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue : CLLocationCoordinate2D = manager.location?.coordinate else {return}
        print("locations = \(locValue.latitude)\(locValue.longitude )")
    }
}
extension OwnerMapsVC : GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        dismiss(animated: true, completion: nil)
        
        self.mapsView.clear()
        self.locationText.text = place.name
        
        
        /*
         let placeGmap = GoogleMapObjects()
         placeGmap.lat = place.coordinate.latitude
         placeGmap.long = place.coordinate.longitude
         placeGmap.address = place.name*/
        
        //self.delegate?.getThePlaceAddress(vc: self, place: placeGmap, tag: self.FieldTag)
        
        let cord2D = CLLocationCoordinate2D(latitude: (place.coordinate.latitude), longitude: (place.coordinate.longitude))
        
        let marker = GMSMarker()
        marker.position =  cord2D
        marker.title = "Location"
        marker.snippet = place.name
        
        let markerImage = UIImage(named: "icon_offer_pickup")!
        let markerView = UIImageView(image: markerImage)
        marker.iconView = markerView
        marker.map = self.mapsView
        
        self.mapsView.camera = GMSCameraPosition.camera(withTarget: cord2D, zoom: 15)
        
        
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        
    }
    func makeAlert() {
        let alert = UIAlertController(title: "", message: "LUTFEN MAHALLE ISMI GIRINIZ", preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    
}
