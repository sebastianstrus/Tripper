//
//  MapVC.swift
//  Tripper
//
//  Created by Sebastian Strus on 2017-03-12.
//  Copyright © 2017 Sebastian Strus. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapVC: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager: CLLocationManager!
    var allTrips: [Trip]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getTripsFromCoreData()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.distanceFilter = 1000
        locationManager.desiredAccuracy = 1000
        locationManager.startUpdatingLocation()
        locationManager.requestWhenInUseAuthorization()
        mapView.delegate = self
        
        for trip in allTrips! as [Trip] {
            let coordinate = CLLocationCoordinate2D(latitude: trip.placeLatitude, longitude: trip.placeLongitude)
            let  annotation = MKPointAnnotation()
            annotation.title = trip.title
            annotation.coordinate = coordinate
            mapView.addAnnotation(annotation)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let span = MKCoordinateSpan(latitudeDelta: 100, longitudeDelta: 100)
            let lookHereRegion = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(lookHereRegion, animated: true)
        }
    }
    
    // retrive from CoreData
    func getTripsFromCoreData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Trip")
        do {
            let trips = try context.fetch(request) as! [Trip]
            allTrips = trips
        }
        catch let error {
            print("\(error)")
        }
    }
}
