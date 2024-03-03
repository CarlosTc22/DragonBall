//
//  HeroAnnotation.swift
//  DragonBall
//
//  Created by Juan Carlos Torrejon Cañedo on 16/2/24.
//

import MapKit
import UIKit

// HeroAnnotation defines a custom annotation to display heroes on a map.
class HeroAnnotation: NSObject, MKAnnotation {
    // The title of the annotation, typically the name of the hero.
    var title: String?
    
    // The geographic location of the annotation. This is a requirement of the MKAnnotation protocol.
    var coordinate: CLLocationCoordinate2D
    
    // Additional information or description of the hero. This property is not part of the MKAnnotation protocol, but is used to store additional data.
    var info: String
    
    // Initializer to create a new hero annotation with a title, geographic coordinates, and a description.
    init(title: String, coordinate: CLLocationCoordinate2D, info: String) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
    }
}
