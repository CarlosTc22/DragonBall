//
//  LoginViewController.swift
//  DragonBall
//
//  Created by Juan Carlos Torrejon Cañedo on 14/2/24.
//

import UIKit

// Define the interactions with the LoginViewController's ViewModel.
protocol LoginViewControllerDelegate {
    var viewState: ((LoginViewState) -> Void)? { get set }
    var heroesViewModel: HeroesViewControllerDelegate { get }
    
    func onLoginPressed(email: String?, password: String?)
}

// Possible states of the view during the login process.
enum LoginViewState {
    case loading(_ isLoading: Bool)
    case showErrorEmail(_ error: String?)
    case showErrorPassword(_ error: String?)
    case navigateToNext
}

// View controller for the login screen.
class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emailFieldError: UILabel!
    @IBOutlet weak var passwordFieldError: UILabel!
    @IBOutlet weak var loadingView: UIView!
    
    // Action linked to the login button.
    @IBAction func onLoginPressed() {
        viewModel?.onLoginPressed(email: emailField.text, password: passwordField.text)
    }
    
    var viewModel: LoginViewControllerDelegate?
    
    // Identifiers for the text fields.
    private enum FieldType: Int {
        case email = 0
        case password
    }
    
    // Configures the view and sets up observers for changes in the ViewModel's state.
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        setupObservers()
    }
    
    // Prepares necessary data before transitioning.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LOGIN_TO_HEROES",
           let heroesViewController = segue.destination as? HeroesViewController {
            heroesViewController.viewModel = viewModel?.heroesViewModel
        }
    }
    
    // Configures the initial user interface and delegates for the text fields.
    private func configureViews() {
        emailField.delegate = self
        emailField.tag = FieldType.email.rawValue
        passwordField.delegate = self
        passwordField.tag = FieldType.password.rawValue
        
        // Allows hiding the keyboard when tapping outside of text fields.
        view.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        )
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // Observes changes in the ViewModel's view state to update the UI.
    private func setupObservers() {
        viewModel?.viewState = { [weak self] state in
            DispatchQueue.main.async {
                switch state {
                case .loading(let isLoading):
                    self?.loadingView.isHidden = !isLoading
                    
                case .showErrorEmail(let error):
                    self?.emailFieldError.text = error
                    self?.emailFieldError.isHidden = error?.isEmpty ?? true
                    
                case .showErrorPassword(let error):
                    self?.passwordFieldError.text = error
                    self?.passwordFieldError.isHidden = error?.isEmpty ?? true
                    
                case .navigateToNext:
                    self?.performSegue(withIdentifier: "LOGIN_TO_HEROES", sender: nil)
                }
            }
        }
    }
}

// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    // Hides error messages when the user finishes editing the fields.
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch FieldType(rawValue: textField.tag) {
        case .email:
            emailFieldError.isHidden = true
        case .password:
            passwordFieldError.isHidden = true
        default: break
        }
    }
}
