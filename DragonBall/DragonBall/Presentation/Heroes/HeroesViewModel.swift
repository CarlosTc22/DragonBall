//
//  HeroesViewModel.swift
//  DragonBall
//
//  Created by Juan Carlos Torrejon Cañedo on 16/2/24.
//

import Foundation

// ViewModel for HeroesViewController that manages the logic for loading and presenting heroes.
class HeroesViewModel: HeroesViewControllerDelegate {
    private let apiProvider: ApiProviderProtocol
    private let secureDataProvider: SecureDataProviderProtocol
    
    private var heroes: [Hero] = []
    
    var viewState: ((HeroesViewState) -> Void)?
    
    var heroesCount: Int {
        return heroes.count
    }
    
    var loginViewModel: LoginViewControllerDelegate {
        LoginViewModel(apiProvider: apiProvider, secureDataProvider: secureDataProvider)
    }
    
    init(apiProvider: ApiProviderProtocol, secureDataProvider: SecureDataProviderProtocol) {
        self.apiProvider = apiProvider
        self.secureDataProvider = secureDataProvider
    }
    
    func onViewAppear() {
        viewState?(.loading(true))
        loadHeroes()
    }
    
    func heroBy(index: Int) -> Hero? {
        return index >= 0 && index < heroesCount ? heroes[index] : nil
    }
    
    func heroDetailViewModel(for index: Int) -> HeroDetailViewControllerDelegate? {
        guard let hero = heroBy(index: index) else { return nil }
        return HeroDetailViewModel(apiProvider: apiProvider, hero: hero)
    }
    
    private func loadHeroes() {
        DispatchQueue.global().async {
            self.apiProvider.getHeroes(nil) { heroes in
                self.updateHeroes(heroes)
            }
        }
    }
    
    private func updateHeroes(_ heroes: [Hero]) {
        DispatchQueue.main.async {
            // Here you could update CoreData with the new heroes if needed
            self.heroes = heroes
            self.viewState?(.loading(false))
            self.viewState?(.updateData)
        }
    }
}
