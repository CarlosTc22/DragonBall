//
//  LoginViewModel.swift
//  DragonBall
//
//  Created by Juan Carlos Torrejon Cañedo on 14/2/24.
//

import Foundation

class LoginViewModel: LoginViewControllerDelegate {
    let apiProvider : ApiProviderProtocol
    
    // MARK: - Properties -
    var viewState: ((LoginViewState) -> Void)?

    // MARK: - Initializers -
    init(apiProvider : ApiProviderProtocol) {
        self.apiProvider = apiProvider
    }

    // MARK: - Public functions -
    func onLoginPressed(email: String?, password: String?) {
        viewState?(.loading(true))

        DispatchQueue.global().async {
            guard self.isValid(email: email) else {
                self.viewState?(.loading(false))
                self.viewState?(.showErrorEmail("Indique un email válido"))
                return
            }

            guard self.isValid(password: password) else {
                self.viewState?(.loading(false))
                self.viewState?(.showErrorPassword("Indique una password válida"))
                return
            }

            self.doLoginWith(
                email: email ?? "",
                password: password ?? ""
            )
        }
    }

    // MARK: - Private functions -
    private func isValid(email: String?) -> Bool {
        email?.isEmpty == false && (email?.contains("@") ?? false)
    }

    private func isValid(password: String?) -> Bool {
        password?.isEmpty == false && (password?.count ?? 0) >= 4
    }

    private func doLoginWith(email: String, password: String) {

    }
}
