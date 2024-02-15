//
//  ApiProvider.swift
//  DragonBall
//
//  Created by Juan Carlos Torrejon Cañedo on 15/2/24.
//

import Foundation

protocol ApiProviderProtocol {
    func login(for user: String, with password: String)
}

class ApiProvider: ApiProviderProtocol {
    // MARK: - Constants -
    static private let apiBaseURL = "https://dragonball.keepcoding.education/api"
    
    private enum Endpoint {
        static let login = "/auth/login"
        static let heroes = "/heros/all"
        static let heroLocations = "/heros/locations"
    }
    
    // MARK: - ApiProviderProtocol -
    func login(for user: String, with password: String) {
        guard let url = URL(string: "\(ApiProvider.apiBaseURL)\(Endpoint.login)") else {
            return
        }
        
        guard let loginData = String(format: "%@:%@",
                                     user, password).data(using: .utf8)?.base64EncodedString() else {
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Basic \(loginData)",
                            forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil else {
                return
            }
            
            guard let data,
                  (response as? HTTPURLResponse)?.statusCode == 200 else {
                return
            }
            
            guard let responseData = String(data: data, encoding: .utf8) else {
                return
            }
            
        }.resume()
    }
}
