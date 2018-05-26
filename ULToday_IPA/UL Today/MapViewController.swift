//
//  MapViewController.swift
//  UL Timetable
//
//  Created by Andrew on 8/11/16.
//  Copyright © 2016 Andrew Design. All rights reserved.
//

import UIKit
import MapKit
import CoreGraphics

class MapViewController: UIViewController {
    
    
    @IBOutlet var mapView: MKMapView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationItem.titleView = UIImageView.init(image: UIImage(named:"ul-logo"))
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        let initialLocation = CLLocation(latitude: 52.673500, longitude: -8.572982)
        let regionRadius: CLLocationDistance = 1000
        func centerMapOnLocation(_ location: CLLocation) {
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                      regionRadius * 2.0, regionRadius * 2.0)
            mapView.setRegion(coordinateRegion, animated: true)
        }
        
        centerMapOnLocation(initialLocation)
        
        let mapList = AppData.shared.campusMap
        for index in 0 ..< mapList.count {
            let mapItem = mapList[index] as! [String: Any]
            let lat: Double = ((mapItem["loc"] as! String).components(separatedBy: ",")[0] as NSString).doubleValue
            let lon: Double = ((mapItem["loc"] as! String).components(separatedBy: ",")[1] as NSString).doubleValue
            let title = mapItem["name"] as! String
            let item = MapItem(title: title, coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon))
            
            mapView.addAnnotation(item)
            
        }
        
    }
    
    @IBAction func doneButton(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    
    var locationManager = CLLocationManager()
    var mylocationCoordinat: MKAnnotation?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if CLLocationManager.locationServicesEnabled() {
            let authorizationStatus = CLLocationManager.authorizationStatus()
            if authorizationStatus == .authorizedAlways || authorizationStatus == .authorizedWhenInUse {
                locationManager.delegate = self
                locationManager.startUpdatingLocation()
            } else if authorizationStatus == .notDetermined {
                locationManager.requestWhenInUseAuthorization()
                locationManager.delegate = self
            }
        }
    }
}

extension MapViewController: MKMapViewDelegate, CLLocationManagerDelegate
{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        if let myLocation = self.mylocationCoordinat, myLocation.coordinate.latitude == annotation.coordinate.latitude, myLocation.coordinate.longitude == annotation.coordinate.longitude {
            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "yourLocation")
            
            annotationView.canShowCallout = true
            annotationView.rightCalloutAccessoryView = UIButton.init(type: UIButtonType.detailDisclosure)

            UIGraphicsBeginImageContext(CGSize(width: 40, height: 40))
            #imageLiteral(resourceName: "location").draw(in: CGRect(x: 0, y: 0, width: 40, height: 40))
            if let image = UIGraphicsGetImageFromCurrentImageContext() {
                annotationView.image = image
            }
            UIGraphicsEndImageContext()
            return annotationView
        } else {
            let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "annotationView")
            
            annotationView.canShowCallout = true
            annotationView.rightCalloutAccessoryView = UIButton.init(type: UIButtonType.detailDisclosure)
            return annotationView
        }
        
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl)
    {
        guard let annotation = view.annotation else
        {
            return
        }
        
        let urlString = String(format: "http://maps.apple.com/?ll=%f,%f&z=15&q=%@",  (annotation.coordinate.latitude), (annotation.coordinate.longitude), ((annotation.title)??.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).replacingOccurrences(of: " ", with: "+"))!)
        guard let url = URL(string: urlString) else
        {
            return
        }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    // MARK: - location manager delegate
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            manager.startUpdatingLocation()
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        if let newLocation = locations.last {
            
            let coordinate2D = newLocation.coordinate
            
            if let myLocation = self.mylocationCoordinat {
                self.mapView.removeAnnotation(myLocation)
            }
            let annotation = MKPointAnnotation()
            annotation.title = "You are here"
            annotation.coordinate = coordinate2D
            self.mapView.addAnnotation(annotation)
            self.mylocationCoordinat = annotation
            
//            let mapItem = MapItem(title: "You are here", coordinate: coordinate2D)
        }
    }
}
