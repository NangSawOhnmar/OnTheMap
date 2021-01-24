//
//  StudentsLocationMapViewController.swift
//  OnTheMap
//
//  Created by nang saw on 17/01/2021.
//

import UIKit
import MapKit

class StudentsLocationMapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    var currentTask: URLSessionTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        mapView.delegate = self
        loadStudentsLocation()
    }
    
    func loadStudentsLocation() {
        currentTask?.cancel()
        currentTask = UdacityClient.getStudentLocation(completion: { data,error in
            if error != nil{
                self.showFailureAlert(message: error?.localizedDescription ?? "", title: "Failed!")
            }else{
                InformationModel.studentInfoModel = data
                
                // The "locations" array is an array of dictionary objects that are similar to the JSON
                // data that you can download from parse.
                let locations = InformationModel.studentInfoModel
                
                // We will create an MKPointAnnotation for each dictionary in "locations". The
                // point annotations will be stored in this array, and then provided to the map view.
                var annotations = [MKPointAnnotation]()
                
                // The "locations" array is loaded with the sample data below. We are using the dictionaries
                // to create map annotations. This would be more stylish if the dictionaries were being
                // used to create custom structs. Perhaps StudentLocation structs.
                
                for dictionary in locations {
                    // Notice that the float values are being used to create CLLocationDegree values.
                    // This is a version of the Double type.
                    let lat = CLLocationDegrees(dictionary.latitude)
                    let long = CLLocationDegrees(dictionary.longitude)
                    
                    // The lat and long are used to create a CLLocationCoordinates2D instance.
                    let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    
                    let first = dictionary.firstName
                    let last = dictionary.lastName
                    let mediaURL = dictionary.mediaURL
                    
                    // Here we create the annotation and set its coordiate, title, and subtitle properties
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    annotation.title = "\(first) \(last)"
                    annotation.subtitle = mediaURL
                    
                    // Finally we place the annotation in an array of annotations.
                    annotations.append(annotation)
                }
                self.mapView.addAnnotations(annotations)
            }
            })
        }
    
    @IBAction func tappedLogoutButton(_ sender: Any) {
        UdacityClient.deleteSession(completion: handleLogoutResponse(success:error:))
    }
    
    @IBAction func tappedRefreshButton(_ sender: Any) {
        loadStudentsLocation()
    }
    
    @IBAction func tappedAddLocationButton(_ sender: Any) {
        self.performSegue(withIdentifier: "AddLocation", sender: self)
    }
    
    func handleLogoutResponse(success: Bool, error: Error?) {
        if success{
            self.dismiss(animated: true, completion: nil)
        }else{
            self.showFailureAlert(message: error?.localizedDescription ?? "", title: "Logout Failed")
        }
    }
    
    func showActivityIndicator() {
        activityIndicatorView.isHidden = false
        activityIndicatorView.startAnimating()
    }
    
    func hideActivityIndicator() {
        activityIndicatorView.stopAnimating()
        activityIndicatorView.isHidden = true
    }
}

extension StudentsLocationMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        pinView?.displayPriority = .required
        return pinView
    }
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
            }
        }
    }
    
}
