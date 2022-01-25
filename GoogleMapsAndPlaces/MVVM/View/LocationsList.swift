//
//  LocationListVC.swift
//  GoogleMapsAndPlaces
//
//  Created by Asmaa Badreldin on 1/25/22.
//

import Foundation
import UIKit

class LocationListVC: UIViewController {
    
    lazy var locationVM : LocationVM = {
        return LocationVM()
    }()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        getSavedPlaces()
        
        tableView.register(UINib(nibName: "PlaceCell", bundle: nil), forCellReuseIdentifier: "PlaceCell")
    }

    // get saved places
    func getSavedPlaces(){
        locationVM.savedPlaces.append(contentsOf: locationVM.getSavedPlaces())
    }
}

//Mark:-UITableViewDelegate,UITableViewDataSource
extension LocationListVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationVM.savedPlaces.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceCell") as! PlaceCell
        
        cell.setData(place: locationVM.savedPlaces[indexPath.row])
        
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension LocationListVC: PlaceCellDelegate{
    // get place details
    func getPlaceDetails(cell: PlaceCell, sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddPlaceVC") as! AddPlaceVC
        if let index = tableView.indexPath(for: cell)?.row{
            vc.selctedPlace = self.locationVM.savedPlaces[index]
            vc.editMode = true
            vc.delegate = self
            self.present(vc, animated: true, completion: nil)
        }
    }
}

extension LocationListVC:DismissVCDelegate{
    func dismissVC() {
       getSavedPlaces()
        tableView.reloadData()
    }
}
