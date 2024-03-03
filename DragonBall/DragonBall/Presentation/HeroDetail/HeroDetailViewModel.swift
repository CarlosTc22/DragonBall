//
//  HeroDetailViewModel.swift
//  DragonBall
//
//  Created by Juan Carlos Torrejon Cañedo on 16/2/24.
//

import Foundation

// HeroDetailViewModel coordinates the interaction between the hero detail view and the model, managing data loading and presentation.
class HeroDetailViewModel: HeroDetailViewControllerDelegate {
    // API provider to load data from a web service.
    private let apiProvider: ApiProviderProtocol
    
    // View state to be updated in response to data changes.
    var viewState: ((HeroDetailViewState) -> Void)?
    
    // Current hero and its locations.
    private var hero: Hero
    private var locations: [HeroAnnotation] = []
    
    // Initializer that receives an API provider and the hero to display.
    init(apiProvider: ApiProviderProtocol, hero: Hero) {
        self.apiProvider = apiProvider
        self.hero = hero
    }
    
    // Called when the view appears. Initiates data loading.
    func onViewAppear() {
        // Notifies the view observer that data loading has started.
        viewState?(.loading(true))
        
        // Loads hero's locations asynchronously.
        DispatchQueue.global().async {
            guard let heroId = self.hero.id else { return }
            self.apiProvider.getLocations(by: heroId) { locations in
                self.manageLocations(locations)
                // Notifies the view observer that data loading has finished and provides the loaded data.
                self.viewState?(.loading(false))
                self.viewState?(
                    .updateData(hero: self.hero, locations: self.locations)
                )
            }
        }
    }
    
    // Transforms locations obtained from the API into annotations for the map.
    private func manageLocations(_ locations: HeroLocations) {
        self.locations = locations.compactMap { heroLocation in
            // Tries to convert latitude and longitude strings to Double.
            guard let latitude = Double(heroLocation.latitude ?? ""),
                  let longitude = Double(heroLocation.longitude ?? "") else {
                return nil
            }
            
            // Creates a map annotation for each valid location.
            return HeroAnnotation(
                title: self.hero.name ?? "Location",
                coordinate: .init(latitude: latitude, longitude: longitude),
                info: heroLocation.date ?? "Top Secret"
            )
        }
    }
}
