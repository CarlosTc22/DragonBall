//
//  HeroesViewController.swift
//  DragonBall
//
//  Created by Juan Carlos Torrejon Cañedo on 16/2/24.
//

import UIKit

// Define the interactions between the heroes view and its ViewModel.
protocol HeroesViewControllerDelegate {
    var viewState: ((HeroesViewState) -> Void)? { get set }
    var heroesCount: Int { get }
    var loginViewModel: LoginViewControllerDelegate { get }
    
    func onViewAppear()
    func heroBy(index: Int) -> Hero?
    func heroDetailViewModel(for index: Int) -> HeroDetailViewControllerDelegate?
}

// Possible states of the heroes view during data loading and updates.
enum HeroesViewState {
    case loading(_ isLoading: Bool)
    case updateData
}

// View controller that displays a list of heroes.
class HeroesViewController: UIViewController {
    
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: HeroesViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        
        configureViews()
        setupObservers()
        viewModel?.onViewAppear()
    }
    
    @IBAction func logOut(_ sender: Any) {
        let secureDataProvider = SecureDataProvider()
        secureDataProvider.save(token: "")
        
        navigateToLoginScreen()
    }
    
    func navigateToLoginScreen() {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        if let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
            loginViewController.viewModel = viewModel?.loginViewModel
            let navigationController = UINavigationController(rootViewController: loginViewController)
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let sceneDelegate = windowScene.delegate as? SceneDelegate {
                sceneDelegate.window?.rootViewController = navigationController
                sceneDelegate.window?.makeKeyAndVisible()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HEROES_TO_HERO_DETAIL",
           let selectedIndexPath = sender as? IndexPath,
           let heroDetailVC = segue.destination as? HeroDetailViewController,
           let detailViewModel = viewModel?.heroDetailViewModel(for: selectedIndexPath.row) {
            heroDetailVC.viewModel = detailViewModel
        }
    }
    
    private func configureViews() {
        tableView.register(UINib(nibName: "HeroCellView", bundle: nil), forCellReuseIdentifier: "HeroCellView")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupObservers() {
        viewModel?.viewState = { [weak self] state in
            DispatchQueue.main.async {
                switch state {
                case .loading(let isLoading):
                    self?.loadingView.isHidden = !isLoading
                case .updateData:
                    self?.tableView.reloadData()
                }
            }
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension HeroesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.heroesCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return HeroCellView.estimatedHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HeroCellView.identifier,
                                                       for: indexPath) as? HeroCellView,
              let hero = viewModel?.heroBy(index: indexPath.row) else {
            return UITableViewCell()
        }
        
        cell.updateWith(name: hero.name, photoURL: hero.photo, about: hero.description)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "HEROES_TO_HERO_DETAIL", sender: indexPath)
    }
}
