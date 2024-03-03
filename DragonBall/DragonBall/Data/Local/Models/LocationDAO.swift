//
//  LocationDAO.swift
//  DragonBall
//
//  Created by Juan Carlos Torrejón Cañedo on 2/3/24.
//

import Foundation
import CoreData

@objc(LocationDAO)
class LocationDAO: NSManagedObject {
    @NSManaged var id: String?
    @NSManaged var latitude: String?
    @NSManaged var longitude: String?
    @NSManaged var date: String?
    @NSManaged var hero: HeroDAO?
}

extension LocationDAO: ModelConvertible {
    static var entityName = "LocationDAO"
    
    func toModel() -> HeroLocation? {
        return HeroLocation(
            id: id,
            latitude: latitude,
            longitude: longitude,
            date: date,
            hero: hero?.toModel()
        )
    }
}
