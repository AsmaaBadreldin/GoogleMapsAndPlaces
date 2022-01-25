//
//  MainVC.swift
//  GoogleMapsAndPlaces
//
//  Created by Asmaa Badreldin on 1/25/22.
//

import UIKit
import GoogleMaps
import GooglePlaces

class MainVC: UIViewController {
    
    var mapView : GMSMapView!
    @IBOutlet weak var mapViewContainer: UIView!
    
    lazy var locationVM : LocationVM = {
        return LocationVM()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        getSavedPlaces()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        initMapView()
        
        getMapMarkers()
    }
    
    @IBAction func addLocationBtn(_ sender: UIButton) {
        if self.locationVM.selectedLocation != nil{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddPlaceVC") as! AddPlaceVC
            vc.selectedLocation = self.locationVM.selectedLocation
            vc.delegate = self
            self.present(vc, animated: true, completion: nil)
        }else{
            showToast(message: "please select place first")
        }
    }
    
    @IBAction func getSavedLocation(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LocationListVC") as! LocationListVC
        self.present(vc, animated: true, completion: nil)
    }
    
    func getSavedPlaces(){
        locationVM.savedPlaces.append(contentsOf: locationVM.getSavedPlaces())
    }
    
    // init map view
    private func initMapView(){
        let camera = GMSCameraPosition.camera(withLatitude: 24.801, longitude: 46.6002, zoom: 3.0)
        self.mapView = GMSMapView.map(withFrame: mapViewContainer.bounds, camera: camera)
        self.mapView.delegate = self
        self.mapView.isMyLocationEnabled = true
        
        locationMangerSetUp()

        mapViewContainer.addSubview(self.mapView)
    }
    
    //location manger setup
    func locationMangerSetUp(){
        //Location Manager code to fetch current location
        self.locationVM.locationManager.delegate = self
        self.locationVM.locationMangerSetUP(locationManger: self.locationVM.locationManager)
    }
        
    // get saved markers
    func getMapMarkers(){
        mapView.clear()
        
        // get saved places
        let places = locationVM.savedPlaces
        for place in places{
            // set places markers on the map
            let marker = GMSMarker()
            marker.position = place.coordinate
            marker.icon = UIImage(named: locationVM.getPlaceIcon(type: place.type))
            marker.appearAnimation = .pop
            marker.map = mapView
        }
    }
}

//MARK:- GMSMapViewDelegate
extension MainVC: GMSMapViewDelegate{
        func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
            print ("MarkerTapped Locations: \(marker.position.latitude), \(marker.position.longitude)")
            if marker != locationVM.selectedMarker{
                if let place = self.locationVM.savedPlaces.first(where: {$0.longitude == marker.position.longitude && $0.latitude == marker.position.latitude}) {
                   // do something with place
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddPlaceVC") as! AddPlaceVC
                    vc.selctedPlace = place
                    vc.editMode = true
                    vc.delegate = self
                    self.present(vc, animated: true, completion: nil)
                } else {
                   // item could not be found
                }
            }
            return true
        }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        self.locationVM.selectedLocation = coordinate
        self.locationVM.selectedMarker.position = coordinate
        self.locationVM.selectedMarker.map = mapView
    }
}

//MARK:- CLLocationManagerDelegate
extension MainVC:CLLocationManagerDelegate{
    //Location Manager delegates to get current location of user
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 3.0)
            
        self.mapView?.animate(to: camera)
        
        self.locationVM.locationManager.stopUpdatingLocation()
    }
}

extension MainVC:DismissVCDelegate{
    func dismissVC() {
        self.getSavedPlaces()
        self.getMapMarkers()
        self.showToast(message: "place saved")
    }
}
