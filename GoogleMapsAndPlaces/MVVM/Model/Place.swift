//
//  Place.swift
//  GoogleMapsAndPlaces
//
//  Created by Asmaa Badreldin on 1/25/22.
//

import Foundation
import RealmSwift
import CoreLocation

class Place: Object {
    @objc dynamic var name: String? = nil
    @objc dynamic var phone: String? = nil
    @objc dynamic var type: Int = 0
    @objc dynamic var latitude = 0.0
    @objc dynamic var longitude = 0.0
    
    /// Computed properties are ignored in Realm
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(
            latitude: latitude,
            longitude: longitude)
    }
}
