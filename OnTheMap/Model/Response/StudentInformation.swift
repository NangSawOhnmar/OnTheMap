//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by nang saw on 17/01/2021.
//

import Foundation

struct StudentInformationResult: Codable {
    let results: [StudentInformation]
}
struct StudentInformation: Codable {
    let createdAt: String
    let firstName: String
    let lastName: String
    let latitude: Double
    let longitude: Double
    let mapString: String
    let mediaURL: String
    let objectId: String
    let uniqueKey: String
    let updatedAt: String
}
