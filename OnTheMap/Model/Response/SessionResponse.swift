//
//  SessionResponse.swift
//  OnTheMap
//
//  Created by nang saw on 16/01/2021.
//

import Foundation

struct SessionResponse: Codable{
    let account: Account
    let session: Session
}

struct Account: Codable {
    let registered: Bool
    let key: String
}

struct Session: Codable {
    let id: String
    let expiration: String
}
