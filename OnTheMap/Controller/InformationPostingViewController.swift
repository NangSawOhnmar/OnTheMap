//
//  InformationPostingViewController.swift
//  OnTheMap
//
//  Created by nang saw on 19/01/2021.
//

import UIKit
import MapKit

class InformationPostingViewController: UIViewController {

    @IBOutlet weak var enterInformationView: UIView!
    @IBOutlet weak var enterLocationTextField: UITextField!
    @IBOutlet weak var enterLinkTextField: UITextField!
    @IBOutlet weak var findLocationBtn: LoginButton!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    var coordinate: CLLocationCoordinate2D?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func tappedFindLocationButton(_ sender: Any) {
        setLoading(true)
        guard let location = enterLocationTextField.text else {
            showFailureAlert(message: "Empty Location Name", title: "Enter location name to find on the map.")
            return
        }
        findGeocodePosition(location)
    }
    
    @IBAction func tappedCancelBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FinishSpotMap" {
            let vc = segue.destination as! SpotMapViewController
            vc.coordinate = self.coordinate
            vc.mediaUrl = enterLinkTextField.text
            vc.location = enterLocationTextField.text
        }
    }
    
    // MARK: Find geocode position
    private func findGeocodePosition(_ location: String) {
        CLGeocoder().geocodeAddressString(location) { (newMarker, error) in
            if let error = error {
                self.showFailureAlert(message: error.localizedDescription, title: "Location Not Found")
                self.setLoading(false)
            } else {
                var location: CLLocation?
                
                if let marker = newMarker, marker.count > 0 {
                    location = marker.first?.location
                }
                
                if let location = location {
                    self.coordinate = location.coordinate
                    self.performSegue(withIdentifier: "FinishSpotMap", sender: self)
                } else {
                    self.showFailureAlert(message: "Please try again later.", title: "Location Not Found")
                    self.setLoading(false)
                    print("There was an error.")
                }
            }
        }
    }
    
    func setLoading(_ isloading: Bool) {
        if isloading{
            activityIndicatorView.startAnimating()
        }else{
            activityIndicatorView.stopAnimating()
        }
        enterLinkTextField.isEnabled = !isloading
        enterLocationTextField.isEnabled = !isloading
        findLocationBtn.isEnabled = !isloading
    }
}
