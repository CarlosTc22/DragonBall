//
//  MocksApiProvider.swift
//  DragonBallTests
//
//  Created by Juan Carlos Torrejón Cañedo on 3/3/24.
//

import Foundation
import DragonBall

class MockApiService: ApiProviderProtocol {
    
    var shouldReturnError: Bool = false
    var mockHeroesResponse: [[String: Any]] = [] // Ajusta según sea necesario
    var responseStatusCode: Int = 200 // Simula diferentes códigos de estado HTTP
    enum MockResponse {
        case success
        case error(String)
        case malformedResponse
        case non200StatusCode(Int)
    }
    
    var mockResponse: MockResponse = .success
    
    private let responseDataHeroes: [[String: Any]] = [
        [
            "id": "D13A40E5-4418-4223-9CE6-D2F9A28EBE94",
            "name": "Goku",
            "description": "Sobran las presentaciones cuando se habla de Goku. El Saiyan fue enviado al planeta Tierra, pero hay dos versiones sobre el origen del personaje. Según una publicación especial, cuando Goku nació midieron su poder y apenas llegaba a dos unidades, siendo el Saiyan más débil. Aun así se pensaba que le bastaría para conquistar el planeta. Sin embargo, la versión más popular es que Freezer era una amenaza para su planeta natal y antes de que fuera destruido, se envió a Goku en una incubadora para salvarle.",
            "photo": "https://cdn.alfabetajuega.com/alfabetajuega/2020/12/goku1.jpg?width=300",
            "favorite": false
        ],
        [
            "id": "6E1B907C-EB3A-45BA-AE03-44FA251F64E9",
            "name": "Vegeta",
            "description": "Vegeta es todo lo contrario. Es arrogante, cruel y despreciable. Quiere conseguir las bolas de Dragón y se enfrenta a todos los protagonistas, matando a Yamcha, Ten Shin Han, Piccolo y Chaos. Es despreciable porque no duda en matar a Nappa, quien entonces era su compañero, como castigo por su fracaso. Tras el intenso entrenamiento de Goku, el guerrero se enfrenta a Vegeta y estuvo a punto de morir. Lejos de sobreponerse, Vegeta huye del planeta Tierra sin saber que pronto tendrá que unirse a los que considera sus enemigos.",
            "photo": "https://cdn.alfabetajuega.com/alfabetajuega/2020/12/vegetita.jpg?width=300",
            "favorite": false
        ]
    ]
    
    required init(secureDataProvider: DragonBall.SecureDataProviderProtocol) {}
    
    func login(for user: String, with password: String) {
        switch mockResponse {
        case .success:
            NotificationCenter.default.post(
                name: NotificationCenter.apiLoginNotification,
                object: nil,
                userInfo: [NotificationCenter.tokenKey: "123456789abcdef"]
            )
        case .error(let errorMessage):
            NotificationCenter.default.post(
                name: NotificationCenter.apiLoginNotification,
                object: nil,
                userInfo: ["error": errorMessage]
            )
        default:
            break
        }
    }
    
    func getHeroes(_ heroName: String?, completion: (([Hero]) -> Void)?) {
        switch mockResponse {
        case .success:
            do {
                let data = try JSONSerialization.data(withJSONObject: responseDataHeroes)
                var heroes = try JSONDecoder().decode([Hero].self, from: data)
                if let heroName = heroName, !heroName.isEmpty {
                    heroes = heroes.filter { $0.name == heroName }
                }
                completion?(heroes)
            } catch {
                completion?([])
            }
        default:
            completion?([])
        }
    }

    
    func getLocations(by heroId: String, completion: ((HeroLocations) -> Void)?) {
        if shouldReturnError {
            completion?([])
            return
        }
        
    }
}
