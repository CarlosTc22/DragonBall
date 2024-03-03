//
//  SplashViewController.swift
//  DragonBall
//
//  Created by Juan Carlos Torrejon Cañedo on 19/2/24.
//

import UIKit

// Protocol defining interactions with the SplashViewController's ViewModel.
protocol SplashViewControllerDelegate {
    var viewState: ((SplashViewState) -> Void)? { get set }
    var loginViewModel: LoginViewControllerDelegate { get }
    var heroesViewModel: HeroesViewControllerDelegate { get }
    
    func onViewAppear()
}

// Possible states during the initial loading of the application.
enum SplashViewState {
    case loading(_ isLoading: Bool)
    case navigateToLogin
    case navigateToHeroes
}

// View controller for the initial loading screen.
class SplashViewController: UIViewController {
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    var viewModel: SplashViewControllerDelegate?
    
    // Lifecycle: Called after the controller's view has been loaded into memory.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setObservers()
        viewModel?.onViewAppear()
    }
    
    // Prepares the view before it is displayed.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // Prepares necessary data before transitioning.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SPLASH_TO_LOGIN",
           let loginViewController = segue.destination as? LoginViewController {
            loginViewController.viewModel = viewModel?.loginViewModel
        } else if segue.identifier == "SPLASH_TO_HEROES",
                  let heroesViewController = segue.destination as? HeroesViewController {
            heroesViewController.viewModel = viewModel?.heroesViewModel
        }
    }
    
    // Sets observers for changes in the view state.
    private func setObservers() {
        viewModel?.viewState = { [weak self] state in
            DispatchQueue.main.async {
                switch state {
                case .loading(let isLoading):
                    self?.loading.isHidden = !isLoading
                case .navigateToLogin:
                    self?.performSegue(withIdentifier: "SPLASH_TO_LOGIN", sender: nil)
                case .navigateToHeroes:
                    self?.performSegue(withIdentifier: "SPLASH_TO_HEROES", sender: nil)
                }
            }
        }
    }
}
