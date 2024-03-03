//
//  HeroLocation.swift
//  DragonBall
//
//  Created by Juan Carlos Torrejon Cañedo on 19/2/24.
//

import Foundation
import CoreData

// Define an alias for an array of hero locations, improving code readability.
public typealias HeroLocations = [HeroLocation]

// Represents the geographic location of a hero.
public struct HeroLocation: Codable, Equatable {
    // MARK: - Coding Keys
    // Specifies coding keys for JSON serialization, using custom names for some properties.
    enum CodingKeys: String, CodingKey {
        case id, hero, latitude = "latitud", longitude = "longitud", date = "dateShow"
    }
    
    // MARK: - Properties
    let id: String?
    let latitude: String?
    let longitude: String?
    let date: String?
    let hero: Hero?
    
    // MARK: - Initialization
    // Allows initializing a `HeroLocation` with specific values, including the associated hero.
}

// MARK: - CoreData Conversion
// Extension to convert `HeroLocation` to `LocationDAO` for use with CoreData.
extension HeroLocation: ManagedObjectConvertible {
    // Converts `HeroLocation` to `LocationDAO` and inserts it into the provided CoreData context.
    // Returns the created `LocationDAO` object or nil if creation fails.
    @discardableResult
    func toManagedObject(in context: NSManagedObjectContext) -> LocationDAO? {
        let entityName = LocationDAO.entityName
        guard let entityDescription = NSEntityDescription.entity(forEntityName: entityName, in: context) else {
            NSLog("Can't create entity \(entityName)")
            return nil
        }
        
        // Creates an instance of `LocationDAO` with the entity description and the CoreData context.
        let object = LocationDAO(entity: entityDescription, insertInto: context)
        object.id = id
        object.latitude = latitude
        object.longitude = longitude
        object.date = date
        // Converts and assigns the associated hero to `HeroDAO`, if it exists.
        object.hero = hero?.toManagedObject(in: context)
        
        return object
    }
}
