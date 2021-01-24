//
//  StudentsLocationListViewController.swift
//  OnTheMap
//
//  Created by nang saw on 17/01/2021.
//

import UIKit

class StudentsLocationListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    var currentTask: URLSessionTask?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        loadStudentLocation()
    }
    
    func loadStudentLocation() {
        currentTask?.cancel()
        currentTask = UdacityClient.getStudentLocation(completion: { data,error in
            if error != nil{
                self.showFailureAlert(message: error?.localizedDescription ?? "", title: "Failed!")
            }else{
                InformationModel.studentInfoModel = data
                self.tableView.reloadData()
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    @IBAction func tappedLogoutButton(_ sender: Any) {
        UdacityClient.deleteSession(completion: handleLogoutResponse(success:error:))
    }
    
    @IBAction func tappedRefreshButton(_ sender: Any) {
        loadStudentLocation()
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

extension StudentsLocationListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return InformationModel.studentInfoModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentsLocationTableViewCell") as! LocationListTableViewCell
        let studentInfo = InformationModel.studentInfoModel[indexPath.row]
        cell.labelName.text = studentInfo.firstName + studentInfo.lastName
        cell.labelMediaUrl.text = studentInfo.mediaURL
        cell.imgView.image = UIImage(named: "icon_pin")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let studentInfo = InformationModel.studentInfoModel[indexPath.row]
        UIApplication.shared.open(URL(string: studentInfo.mediaURL)!, options: [:], completionHandler: nil)
    }
}
