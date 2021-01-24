//
//  SpotMapViewController.swift
//  OnTheMap
//
//  Created by nang saw on 20/01/2021.
//

import UIKit
import MapKit

class SpotMapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    var currentTask: URLSessionTask?
    var coordinate: CLLocationCoordinate2D?
    var mediaUrl: String?
    var location: String?
    let firstName: String = "Ben"
    let lastName: String = "Ten"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let coordinate = coordinate else {
            return
        }
        showLocation(coordinate: coordinate)
    }
    
    @IBAction func tappedFinishButton(_ sender: Any) {
        let location = PostStudentLocation(uniqueKey: UdacityClient.Auth.accountKey, firstName: self.firstName, lastName: self.lastName, mapString: self.location!, mediaURL: self.mediaUrl!, latitude: coordinate!.latitude, longitude: coordinate!.longitude)
        if UdacityClient.Auth.objectId == ""{
            UdacityClient.addStudentLocation(location: location, completion: handleAddStudentLocationResponse(success:error:))
        }else{
            showOverriteAlert(location: location)
        }
    }
    
    func handleAddStudentLocationResponse(success: Bool, error: Error?) {
        if success{
            self.performSegue(withIdentifier: "FinishAddLocation", sender: self)
        }else{
            self.showFailureAlert(message: error?.localizedDescription ?? "", title: "Add location failed.")
        }
    }
    
    func showOverriteAlert(location: PostStudentLocation) {
        let alertVC = UIAlertController(title: "", message: "You have already posted a location. Would you like to overwrite your current location?", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Overwrite", style: .default, handler: { (action: UIAlertAction) in
            UdacityClient.updateStudentLocation(location: location, completion: self.handleAddStudentLocationResponse(success:error:))
        }))
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction) in
                alertVC.dismiss(animated: true, completion: nil)
        }))
        self.present(alertVC, animated: true)
    }

}

extension SpotMapViewController: MKMapViewDelegate {
    func showLocation(coordinate: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "\(self.firstName) \(self.lastName)"
        annotation.subtitle = mediaUrl
        
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        DispatchQueue.main.async {
            self.mapView.addAnnotation(annotation)
            self.mapView.setRegion(region, animated: true)
            self.mapView.regionThatFits(region)
        }
    }
    
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
