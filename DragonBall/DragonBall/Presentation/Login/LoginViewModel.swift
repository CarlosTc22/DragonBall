//
//  LoginViewModel.swift
//  DragonBall
//
//  Created by Juan Carlos Torrejon Cañedo on 14/2/24.
//

import Foundation

// ViewModel for LoginViewController that handles the login logic.
class LoginViewModel: LoginViewControllerDelegate {
    
    private let apiProvider: ApiProviderProtocol // API provider to make network calls.
    private let secureDataProvider: SecureDataProviderProtocol // Provider to securely store data (e.g., authentication token).
    
    // MARK: - Properties -
    var viewState: ((LoginViewState) -> Void)? // Manages the view state to update the UI based on specific events.
    // Provides the ViewModel for the heroes view, which will be used after successful login.
    var heroesViewModel: HeroesViewControllerDelegate {
        return HeroesViewModel(apiProvider: apiProvider,
                               secureDataProvider: secureDataProvider)
    }
    
    // Initializes the ViewModel with required dependencies.
    init(apiProvider: ApiProviderProtocol, secureDataProvider: SecureDataProviderProtocol) {
        self.apiProvider = apiProvider
        self.secureDataProvider = secureDataProvider
        
        // Listens to the login response notification.
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onLoginResponse),
            name: NotificationCenter.apiLoginNotification,
            object: nil
        )
    }
    
    // Unsubscribes from notifications when the instance is being destroyed.
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // Function called when the user presses the login button.
    func onLoginPressed(email: String?, password: String?) {
        viewState?(.loading(true)) // Indicates that the login process has started.
        
        DispatchQueue.global().async {
            // Validates email and password before attempting to login.
            guard self.isValid(email: email) else {
                self.viewState?(.loading(false))
                self.viewState?(.showErrorEmail("Please provide a valid email"))
                return
            }
            
            guard self.isValid(password: password) else {
                self.viewState?(.loading(false))
                self.viewState?(.showErrorPassword("Please provide a valid password"))
                return
            }
            
            // Performs the login request with the provided credentials.
            self.doLoginWith(email: email ?? "", password: password ?? "")
        }
    }
    
    // Function called in response to the successful login notification.
    @objc private func onLoginResponse(_ notification: Notification) {
        defer { viewState?(.loading(false)) } // Ensures the loading indicator is hidden regardless of the result.
        
        guard let token = notification.userInfo?[NotificationCenter.tokenKey] as? String,
              !token.isEmpty else {
            // Handles the case of login failure.
            return
        }
        
        // Saves the received authentication token and navigates to the next view.
        secureDataProvider.save(token: token)
        viewState?(.navigateToNext)
    }
    
    // Validates the email.
    func isValid(email: String?) -> Bool {
        return email?.isEmpty == false && (email?.contains("@") ?? false)
    }
    
    // Validates the password.
    func isValid(password: String?) -> Bool {
        return password?.isEmpty == false && (password?.count ?? 0) >= 4
    }
    
    // Performs the login request through the API provider.
    private func doLoginWith(email: String, password: String) {
        apiProvider.login(for: email, with: password)
    }
}
