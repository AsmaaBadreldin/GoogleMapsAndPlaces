//
//  RealmService.swift
//  GoogleMapsAndPlaces
//
//  Created by Asmaa Badreldin on 1/25/22.
//

import Foundation
import RealmSwift
import Realm


class RealmService {
    private init() {}
    static let shared = RealmService()
    lazy var realm:Realm = {
        return try! Realm()
    }()
    
    func addData(object: Object) {
        try! realm.write {
            realm.add(object)
        }
    }
    
    func deleteAllFromDatabase() {
        try!   realm.write {
            realm.deleteAll()
        }
    }
    
    func deleteFromDb(object: Object) {
        try!   realm.write {
            realm.delete(object)
        }
    }
    
    func deleteObject<T: Object>(_ object: T){
        do{
            try! realm.write {
                realm.delete(object)
            }
        }catch{
            post(error: error)
        }
    }
    
    func addListOfObject(_ objects: [Object]){
        do{
            try! realm.write {
                realm.add(objects)
            }
        }catch{
            post(error: error)
        }
    }
    
    func deleteAll(_ objects: [Object]){
        do {
            try realm.write {
                realm.delete(objects)
            }
        }catch{
            post(error: error)
        }
    }
    
    func create<T:Object>(_ object:T){
        do{
            try realm.write {
                realm.add(object)
            }
        }catch{
            post(error: error)
        }
    }
    
    func update<T: Object>(_ object: T, with dictionary: [String: Any?]) {
        do {
            try realm.write {
                for (key, value) in dictionary {
                    object.setValue(value, forKey: key)
                }
            }
        } catch {
            post(error:error)
        }
    }
    
    func post(error:Error) {
        NotificationCenter.default.post(name: NSNotification.Name("RealmError"), object: error)
    }
}
