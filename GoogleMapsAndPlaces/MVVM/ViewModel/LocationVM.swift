//
//  LocationVM.swift
//  GoogleMapsAndPlaces
//
//  Created by Asmaa Badreldin on 1/25/22.
//

import Foundation
import UIKit
import GooglePlaces
import GoogleMaps
import RealmSwift

class LocationVM {
    
    init() {}

    var locationManager = CLLocationManager()
    var selectedLocation :CLLocationCoordinate2D?
    var selectedMarker: GMSMarker = GMSMarker()

    var locationType = 0 // default 0
    var placePhone : String?

    var placeModel:Place?
    
    var savedPlaces = [Place]()

    // setup locationManger
    func locationMangerSetUP(locationManger:CLLocationManager){
        locationManger.requestWhenInUseAuthorization()
        locationManger.desiredAccuracy = kCLLocationAccuracyBest
        locationManger.startUpdatingLocation()
    }
    
    // validate place phone num
    func validatePlacePhone(phoneTxt : UITextField) -> Bool {
        placePhone = phoneTxt.text
        let response = ValidationVM.shared.validate(
            values:
                (.phoneNo, placePhone ?? "", phoneTxt)
        )
        
        switch response.1 {
        case .success:
            break
        case .failure(_, let message):
            return false
        }
        
        return true
    }
    
    // save selected place
    func savePlace(name:String, phone:String,type:Int ,coordinate:CLLocationCoordinate2D){
        let place = Place()
        place.name = name
        place.phone = phone
        place.type = type
        place.latitude = coordinate.latitude
        place.longitude = coordinate.longitude
        
        RealmService.shared.addData(object: place)
    }

    // get places saved
    func getSavedPlaces() -> Results<Place>{
        let results = RealmService.shared.realm.objects(Place.self)
        print(results)
        return results
    }
    
    // init new place obj
    func setNewObj(name:String , phone:String , type:Int) -> Place{
        let newObj = Place()
        newObj.phone = phone
        newObj.name = name
        newObj.type = type
        
        return newObj
    }
    
   // update saved place
    func updateLocation(oldObj:Place, newObj:Place){
         let objects = RealmService.shared.realm.objects(Place.self).filter("latitude = %@", oldObj.latitude)

         let realm = try! Realm()
         if let obj = objects.first {
             try! realm.write {
                 obj.name = newObj.name
                 obj.phone = newObj.phone
                 obj.type = newObj.type
             }
         }
    }
    
    // get place icon occording to its type
    func getPlaceIcon(type:Int) -> String{
        switch type{
        case LocationTypeEnum.home.rawValue:
            return LocationImgEnum.home.rawValue
        case LocationTypeEnum.restaurant.rawValue:
            return LocationImgEnum.restaurant.rawValue
        case LocationTypeEnum.park.rawValue:
            return LocationImgEnum.park.rawValue
        default:
            return LocationImgEnum.home.rawValue
        }
    }
}
