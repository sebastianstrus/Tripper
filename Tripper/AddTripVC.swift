//
//  AddTripVC.swift
//  TravelBook
//
//  Created by Sebastian Strus on 2017-03-10.
//  Copyright © 2017 Sebastian Strus. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class AddTripVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, CLLocationManagerDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var timeTF: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionTV: UITextView!
    @IBOutlet weak var expensePicker: UIPickerView!
    @IBOutlet weak var mapView: MKMapView!
    
    var expenses: [String]?
    var currentExpense: String?
    var locationManager: CLLocationManager!
    var start : MKPointAnnotation?
    var goal : MKPointAnnotation?
    var currentLatitude = 0.0
    var currentLongitude = 0.0
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.distanceFilter = 1000
        locationManager.desiredAccuracy = 1000
        locationManager.startUpdatingLocation()
        locationManager.requestWhenInUseAuthorization()
        
        expenses = ["0-1.000kr", "1.001-2.000kr", "2.001-5.000kr", "5.001-10.000kr", "10.001-20.000kr", "20.000-50.000kr"]
        currentExpense = expenses![0]
        
        niceViews()
        view.addSubview(scrollView)
        let add = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(addTapped))
        navigationItem.rightBarButtonItems = [add]
        expensePicker.delegate = self
        expensePicker.dataSource = self
    }

    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func addTapped() {
        if (!(titleTF.text?.isEmpty)!) {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            var alreadyExists = false
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Trip")
            do {
                let trips = try context.fetch(request) as! [Trip]
                for trip in trips {
                    print("In CoreData: \(trip.title) Current: \(titleTF.text)")
                    if trip.title == titleTF.text {
                        alreadyExists = true
                    }
                }
            }
            catch let error {
                print("\(error)")
            }
            if !alreadyExists {
                let tripDescription = NSEntityDescription.entity(forEntityName: "Trip", in: context)!
                let newTrip = NSManagedObject(entity: tripDescription, insertInto: context) as! Trip
                newTrip.title = titleTF.text
                newTrip.journeyTime = timeTF.text
                newTrip.image = UIImagePNGRepresentation(imageView.image!)! as NSData?
                newTrip.tripDescription = descriptionTV.text
                newTrip.expense = currentExpense
                if currentLatitude != 0.0 {
                    newTrip.placeLongitude = currentLongitude
                    newTrip.placeLatitude = currentLatitude
                }
                do {
                    try context.save()
                }
                catch let error {
                    print(error)
                }
                performSegue(withIdentifier: "ToMainMenu", sender: nil)
                alert(info: "Successfully saved!")
            } else {
                let title = titleTF.text
                alertAlreadyExists(title: title!)
            }
        }
        else {
            alert(info: "Title field can't be empty!")
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        scrollView.contentSize = CGSize(width: 375
            , height: 850)
    }
    
    @IBAction func libraryButton(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }

    @IBAction func cameraButton(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        imageView.image = image
        self.dismiss(animated: true, completion: nil);
    }

    func saveImage() {
        let imageData = UIImageJPEGRepresentation(imageView.image!, 0.6)
        let compressedIPEGImage = UIImage(data: imageData!)
        UIImageWriteToSavedPhotosAlbum(compressedIPEGImage!, nil, nil, nil)
    }
    
    func saveNotice() {
        let alertController = UIAlertController(title: "Image Saved", message: "Your picture was successfully saved in photo library.", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    
    // PickerView
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return expenses!.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return expenses?[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentExpense = expenses?[row]
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func alert(info: String) {
        let alertController = UIAlertController(title: "Alert", message: "\(info)", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
    func alertAlreadyExists(title: String) {
        let alertController = UIAlertController(title: "Alert", message: "Trip with the title \"\(title)\" already exists in your list!", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let span = MKCoordinateSpan(latitudeDelta: 100, longitudeDelta: 100)
            let lookHereRegion = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(lookHereRegion, animated: true)
        }
    }
    
    
    // Mark trip on map
    @IBAction func onLongPress(_ sender: UILongPressGestureRecognizer) {
        if !(titleTF.text?.isEmpty)! {
            if sender.state == .began {
                let position = sender.location(in: mapView)
                let coordinate = mapView.convert(position, toCoordinateFrom: mapView)
                currentLatitude = coordinate.latitude
                currentLongitude = coordinate.longitude
                if let existing = goal {
                    mapView.removeAnnotation(existing)
                }
                let  annotation = MKPointAnnotation()
                annotation.title = titleTF.text
                annotation.coordinate = coordinate
                mapView.addAnnotation(annotation)
                goal = annotation
            }
        }
        else {
            alert(info: "Title can'n be empty!")
        }
        
    }
    

}
