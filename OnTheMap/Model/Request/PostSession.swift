//
//  PostSession.swift
//  OnTheMap
//
//  Created by nang saw on 16/01/2021.
//

import Foundation

struct PostSession: Codable {
    let udacity: Udacity
}

struct Udacity: Codable {
    let username: String
    let password: String
}
