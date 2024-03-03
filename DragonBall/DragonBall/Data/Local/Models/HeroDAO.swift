//
//  HeroDAO.swift
//  DragonBall
//
//  Created by Juan Carlos Torrejon Cañedo on 16/2/24.
//

import Foundation
import CoreData

// MARK: - HeroDAO Definition
@objc(HeroDAO)
class HeroDAO: NSManagedObject {
    @NSManaged var id: String?
    @NSManaged var name: String?
    @NSManaged var heroDescription: String?
    @NSManaged var photo: String?
    @NSManaged var favorite: Bool
    @NSManaged var locations: [LocationDAO]
}

// MARK: - Conversion to Model
extension HeroDAO: ModelConvertible {
    static var entityName = "HeroDAO"
    
    /// Converts HeroDAO to Hero model for use outside of CoreData.
    func toModel() -> Hero? {
        return Hero(
            id: id,
            name: name,
            description: heroDescription,
            photo: photo,
            isFavorite: favorite
        )
    }
}
