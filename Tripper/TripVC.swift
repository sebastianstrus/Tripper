//
//  TripVC.swift
//  Tripper
//
//  Created by Sebastian Strus on 2017-03-11.
//  Copyright © 2017 Sebastian Strus. All rights reserved.
//

import UIKit
import MapKit

class TripVC: UIViewController, CLLocationManagerDelegate {


    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionTV: UITextView!
    @IBOutlet weak var expenseLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    
    var locationManager: CLLocationManager!
    var trip: Trip!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        niceViews()

        view.addSubview(scrollView)
        if let t = trip {
            titleLabel.text = t.title
            time.text = t.journeyTime
            imageView.image = UIImage(data: t.image as! Data)
            descriptionTV.text = t.tripDescription
            expenseLabel.text = t.expense
        }
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.distanceFilter = 1000
        locationManager.desiredAccuracy = 1000
        locationManager.startUpdatingLocation()
        locationManager.requestWhenInUseAuthorization()
        
        let coordinate = CLLocationCoordinate2D(latitude: (trip?.placeLatitude)!, longitude: (trip?.placeLongitude)!)
        let  annotation = MKPointAnnotation()
        annotation.title = trip?.title
        
        
        

        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        scrollView.contentSize = CGSize(width: 375
            , height: 750)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userCenter = CLLocationCoordinate2D(latitude: trip.placeLatitude, longitude: trip.placeLongitude)

        let region = MKCoordinateRegion(center: userCenter, span: MKCoordinateSpan(latitudeDelta: 100, longitudeDelta: 100))
        
        mapView.setRegion(region, animated: true)
    }
    
    func niceViews() {
        imageView.layer.borderWidth = 1.0
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        descriptionTV.layer.borderWidth = 1.0
        descriptionTV.layer.masksToBounds = true
        descriptionTV.layer.cornerRadius = 10
        mapView.layer.borderWidth = 1.0
        mapView.layer.masksToBounds = true
        mapView.layer.cornerRadius = 10
    }
    
    
    
    
    
    
    
}
