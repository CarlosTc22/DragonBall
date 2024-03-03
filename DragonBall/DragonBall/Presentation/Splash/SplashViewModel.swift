//
//  SplashViewModel.swift
//  DragonBall
//
//  Created by Juan Carlos Torrejon Cañedo on 19/2/24.
//

import Foundation

// ViewModel for SplashViewController that manages the startup logic.
class SplashViewModel: SplashViewControllerDelegate {
    private let apiProvider: ApiProviderProtocol
    private let secureDataProvider: SecureDataProviderProtocol
    
    var viewState: ((SplashViewState) -> Void)?
    var loginViewModel: LoginViewControllerDelegate {
        LoginViewModel(apiProvider: apiProvider, secureDataProvider: secureDataProvider)
    }
    var heroesViewModel: HeroesViewControllerDelegate {
        HeroesViewModel(apiProvider: apiProvider,
                        secureDataProvider: secureDataProvider)
    }
    
    // Checks if the user is logged in by verifying if a token exists.
    private var isLogged: Bool {
        secureDataProvider.getToken()?.isEmpty == false
    }
    
    // Initializes the ViewModel with necessary dependencies.
    init(apiProvider: ApiProviderProtocol, secureDataProvider: SecureDataProviderProtocol) {
        self.apiProvider = apiProvider
        self.secureDataProvider = secureDataProvider
    }
    
    // Logic executed when the view appears. Determines the navigation flow based on the authentication status.
    func onViewAppear() {
        viewState?(.loading(true))
        
        // Simulates a check or loading that takes 2 seconds.
        DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(2)) {
            if self.isLogged {
                self.viewState?(.navigateToHeroes)
            } else {
                self.viewState?(.navigateToLogin)
            }
        }
    }
}
