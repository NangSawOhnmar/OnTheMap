//
//  UdacityResponse.swift
//  OnTheMap
//
//  Created by nang saw on 16/01/2021.
//

import Foundation


struct UdacityResponse: Codable {
    let code: Int
    let error: String
}

extension UdacityResponse: LocalizedError {
    var errorDescription: String? {
        return error
    }
}
