//
//  PostStudentLocation.swift
//  OnTheMap
//
//  Created by nang saw on 20/01/2021.
//

import Foundation

struct PostStudentLocation: Codable {
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Double
    let longitude: Double
}
