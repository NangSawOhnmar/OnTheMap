//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by nang saw on 16/01/2021.
//

import Foundation

class UdacityClient {
    
    struct Auth {
        static var accountKey = ""
        static var sessionId = ""
        static var objectId = ""
    }
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        static let accountKeyParam = "/users/\(Auth.accountKey)"
        
        case createSession
        case signUp
        case deleteSession
        case getStudentLocation
        case addStudentLocation
        case updateStudentLocation
        
        var stringValue: String {
            switch self {
            case .createSession: return Endpoints.base + "/session"
            case .signUp: return "https://auth.udacity.com/sign-up"
            case .deleteSession: return Endpoints.base + "/session"
            case .getStudentLocation: return Endpoints.base + "/StudentLocation?order=-updatedAt&limit=100"
            case .addStudentLocation: return Endpoints.base + "/StudentLocation"
            case .updateStudentLocation: return Endpoints.base + "/StudentLocation/\(Auth.objectId)"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func createSession(username: String, password: String, completion: @escaping(Bool,Error?) -> Void) {
        let body = PostSession(udacity: Udacity(username: username, password: password))
        taskForPOSTRequest(range: 5, url: Endpoints.createSession.url, responseType: SessionResponse.self, body: body) { response,error in
            if let response = response {
                Auth.accountKey = response.account.key
                Auth.sessionId = response.session.id
                print("Account key:", Auth.accountKey)
                completion(true,nil)
            }else{
                completion(false,error)
            }
        }
    }
    
    class func deleteSession(completion: @escaping(Bool,Error?) -> Void) {
        var request = URLRequest(url: Endpoints.deleteSession.url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let _ = data else {
                DispatchQueue.main.async {
                    completion(false,error)
                }
                return
            }
            DispatchQueue.main.async {
                completion(true,nil)
            }
        }
        task.resume()
    }
    
    class func getStudentLocation(completion: @escaping([StudentInformation],Error?) -> Void) -> URLSessionTask{
        let task = taskForGETRequest(url: Endpoints.getStudentLocation.url, response: StudentInformationResult.self) { response,error in
            if let response = response {
                completion(response.results,nil)
            }else{
                completion([],error)
            }
        }
        return task
    }
    
    class func addStudentLocation(location: PostStudentLocation, completion: @escaping(Bool,Error?) -> Void) {
        let body = location
        taskForPOSTRequest(range: 0, url: Endpoints.addStudentLocation.url, responseType: AddStudentInformationResponse.self, body: body) { response,error in
            if let response = response {
                Auth.objectId = response.objectId
                completion(true,nil)
            }else{
                completion(false,error)
            }
        }
    }
    
    class func updateStudentLocation(location: PostStudentLocation, completion: @escaping(Bool,Error?) -> Void) {
        let body = location
        var request = URLRequest(url: Endpoints.updateStudentLocation.url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let data = try! JSONEncoder().encode(body)
        request.httpBody = data
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                DispatchQueue.main.async {
                    completion(false,error)
                }
                return
            }else{
                DispatchQueue.main.async {
                    completion(true,nil)
                }
            }
            print(String(data: data!, encoding: .utf8)!)
        }
        task.resume()
    }
    
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, response: ResponseType.Type, completion: @escaping(ResponseType?,Error?) -> Void) -> URLSessionTask{
        let task = URLSession.shared.dataTask(with: url) { data,response,error in
            guard let data = data else{
                DispatchQueue.main.async {
                    completion(nil,error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject,nil)
                }
            }catch{
                do{
                    let errorResponse = try decoder.decode(UdacityResponse.self, from: data)
                    DispatchQueue.main.async {
                        completion(nil,errorResponse)
                    }
                }catch{
                    DispatchQueue.main.async {
                        completion(nil,error)
                    }
                }
            }
        }
        task.resume()
        return task
    }
    
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(range: Int,url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping(ResponseType?,Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let data = try! JSONEncoder().encode(body)
        request.httpBody = data
        
        let task = URLSession.shared.dataTask(with: request) { (data,response,error) in
            guard let data = data else{
                DispatchQueue.main.async {
                    completion(nil,error)
                }
                return
            }
            let range = Range(NSRange(range..<data.count))
            let newData = data.subdata(in: range!)
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: newData)
                DispatchQueue.main.async {
                    completion(responseObject,nil)
                }
            }catch {
                do{
                    let errorResponse = try decoder.decode(UdacityResponse.self, from: newData)
                    DispatchQueue.main.async{
                        completion(nil,errorResponse)
                    }
                }catch{
                    DispatchQueue.main.async {
                        completion(nil,error)
                    }
                }
            }
        }
        task.resume()
    }
    
}
