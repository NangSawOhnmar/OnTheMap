//
//  ViewController.swift
//  OnTheMap
//
//  Created by nang saw on 16/01/2021.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: LoginButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.text = ""
        passwordTextField.text = ""
    }

    @IBAction func loginTapped(_ sender: Any) {
        setLoggingIn(true)
        UdacityClient.createSession(username: self.emailTextField.text ?? "", password: self.passwordTextField.text ?? "", completion: handleLoginResponse(success:error:))
    }
    
    @IBAction func signupTapped(_ sender: Any) {
        UIApplication.shared.open(UdacityClient.Endpoints.signUp.url, options: [:], completionHandler: nil)
    }
    
    func handleLoginResponse(success: Bool, error: Error?) {
        setLoggingIn(false)
        if success{
            self.performSegue(withIdentifier: "completeLogin", sender: self)
        }else{
            showFailureAlert(message: error?.localizedDescription ?? "", title: "Login Failed")
        }
    }
    
    func setLoggingIn(_ loggingIn: Bool) {
        if loggingIn{
            activityIndicator.startAnimating()
        }else{
            activityIndicator.stopAnimating()
        }
        emailTextField.isEnabled = !loggingIn
        passwordTextField.isEnabled = !loggingIn
        loginButton.isEnabled = !loggingIn
    }
    
}

extension UIViewController {
    func showFailureAlert(message: String, title: String) {
        let alertVC = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
}

