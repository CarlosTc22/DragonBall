//
//  Hero.swift
//  DragonBall
//
//  Created by Juan Carlos Torrejon Cañedo on 16/2/24.
//

import Foundation
import CoreData

// Define an alias for an array of heroes, improving code readability.
public typealias Heroes = [Hero]

// Represents a hero in the application.
public struct Hero: Codable, Equatable {
    // MARK: - Coding Keys
    // Specifies coding keys for JSON serialization, including a custom key for 'isFavorite'.
    enum CodingKeys: String, CodingKey {
        case id, name, description, photo
        case isFavorite = "favorite" // Maps 'isFavorite' to the key 'favorite' in JSON.
    }
    
    // MARK: - Properties
    public let id: String?
    public let name: String?
    public let description: String?
    public let photo: String?
    public let isFavorite: Bool?
    
    // MARK: - Initializer
    // Initializes a new hero with provided values.
    public init(id: String?, name: String?, description: String?, photo: String?, isFavorite: Bool?) {
        self.id = id
        self.name = name
        self.description = description
        self.photo = photo
        self.isFavorite = isFavorite
    }
}

// MARK: - CoreData Conversion
// Extension to convert a 'Hero' to a managed object 'HeroDAO' for use with CoreData.
extension Hero: ManagedObjectConvertible {
    // Converts 'Hero' to 'HeroDAO' and inserts it into the provided CoreData context.
    // Returns the created 'HeroDAO' object or nil if creation fails.
    @discardableResult
    func toManagedObject(in context: NSManagedObjectContext) -> HeroDAO? {
        let entityName = HeroDAO.entityName
        guard let entityDescription = NSEntityDescription.entity(forEntityName: entityName, in: context) else {
            NSLog("Can't create entity \(entityName)")
            return nil
        }
        
        // Creates an instance of 'HeroDAO' with the entity description and the CoreData context.
        let object = HeroDAO(entity: entityDescription, insertInto: context)
        object.id = id
        object.name = name
        object.heroDescription = description
        object.photo = photo
        // Ensures a boolean value for 'favorite', using 'false' as default value if 'isFavorite' is nil.
        object.favorite = isFavorite ?? false
        // Initially, the hero has no associated locations.
        object.locations = []
        return object
    }
}
