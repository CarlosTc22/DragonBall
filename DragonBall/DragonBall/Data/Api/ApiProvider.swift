//
//  ApiProvider.swift
//  DragonBall
//
//  Created by Juan Carlos Torrejon Cañedo on 15/2/24.
//

import Foundation

// Extensión de NotificationCenter para facilitar la gestión de notificaciones específicas de la API.
public extension NotificationCenter {
    static let apiLoginNotification = Notification.Name("NOTIFICATION_API_LOGIN")
    static let tokenKey = "KEY_TOKEN"
}

// Protocolo que define los servicios disponibles para interactuar con la API.
public protocol ApiProviderProtocol {
    init(secureDataProvider: SecureDataProviderProtocol)
    func login(for user: String, with password: String)
    func getHeroes(_ heroName: String?, completion: ((Heroes) -> Void)?)
    func getLocations(by heroId: String, completion: ((HeroLocations) -> Void)?)
}

// Implementación del proveedor de API para interactuar con un servicio web específico.
class ApiProvider: ApiProviderProtocol {
    // Base URL para las peticiones a la API.
    static private let apiBaseURL = "https://dragonball.keepcoding.education/api"
    
    // Endpoint URLs para las diferentes peticiones a la API.
    private enum Endpoint {
        static let login = "/auth/login"
        static let heores = "/heros/all"
        static let locations = "/heros/locations"
    }
    
    // Proveedor de datos seguro para manejar, por ejemplo, tokens de autenticación.
    private let secureDataProvider: SecureDataProviderProtocol
    
    required init(secureDataProvider: SecureDataProviderProtocol) {
        self.secureDataProvider = secureDataProvider
    }
    
    // MARK: - Métodos del protocolo ApiProviderProtocol -
    
    // Realiza el inicio de sesión y notifica mediante NotificationCenter.
    func login(for user: String, with password: String) {
        guard let url = URL(string: "\(ApiProvider.apiBaseURL)\(Endpoint.login)") else {
            // Considerar enviar notificación de error
            return
        }
        
        guard let loginData = String(format: "%@:%@", user, password).data(using: .utf8)?.base64EncodedString() else {
            // Considerar enviar notificación de error
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Basic \(loginData)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            // Manejo de error de la petición
            guard error == nil else {
                // Enviar notificación de error
                return
            }
            
            // Validación del código de estado HTTP
            guard let data, (response as? HTTPURLResponse)?.statusCode == 200 else {
                // Enviar notificación de error
                return
            }
            
            // Decodificación de los datos recibidos
            guard let responseData = String(data: data, encoding: .utf8) else {
                // Enviar notificación de error
                return
            }
            
            NotificationCenter.default.post(
                name: NotificationCenter.apiLoginNotification,
                object: nil,
                userInfo: [NotificationCenter.tokenKey: responseData]
            )
        }.resume()
    }
    
    // Obtiene héroes y llama al completion con el resultado.
    func getHeroes(_ heroName: String? = nil, completion: ((Heroes) -> Void)? = nil) {
        guard let url = URL(string: "\(ApiProvider.apiBaseURL)\(Endpoint.heores)"),
              let token = secureDataProvider.getToken() else {
            completion?([])
            return
        }
        
        let jsonData: [String: Any] = ["name": heroName ?? ""]
        guard let jsonParameters = try? JSONSerialization.data(withJSONObject: jsonData) else {
            completion?([])
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        urlRequest.httpBody = jsonParameters
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil, let data, (response as? HTTPURLResponse)?.statusCode == 200,
                  let heroes = try? JSONDecoder().decode([Hero].self, from: data) else {
                completion?([])
                return
            }
            
            completion?(heroes)
        }.resume()
    }
    
    // Obtiene las ubicaciones de un héroe específico y llama al completion con el resultado.
    func getLocations(by heroId: String, completion: ((HeroLocations) -> Void)? = nil) {
        guard let url = URL(string: "\(ApiProvider.apiBaseURL)\(Endpoint.locations)"),
              let token = secureDataProvider.getToken() else {
            completion?([])
            return
        }
        
        let jsonData: [String: Any] = ["id": heroId]
        guard let jsonParameters = try? JSONSerialization.data(withJSONObject: jsonData) else {
            completion?([])
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        urlRequest.httpBody = jsonParameters
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil, let data, (response as? HTTPURLResponse)?.statusCode == 200,
                  let locations = try? JSONDecoder().decode([HeroLocation].self, from: data) else {
                completion?([])
                return
            }
            
            completion?(locations)
        }.resume()
    }
}
