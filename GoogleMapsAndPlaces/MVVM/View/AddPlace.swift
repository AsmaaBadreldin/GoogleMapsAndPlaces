//
//  AddPlaceVC.swift
//  GoogleMapsAndPlaces
//
//  Created by Asmaa Badreldin on 1/25/22.
//

import UIKit
import CoreLocation

class AddPlaceVC: UIViewController {

    @IBOutlet weak var homeBtn: UIButton!
    @IBOutlet weak var restBtn: UIButton!
    @IBOutlet weak var parkBtn: UIButton!
    
    @IBOutlet weak var placeNameTxt: UITextField!
    @IBOutlet weak var placePhoneTxt: UITextField!
    
    var selectedLocation :CLLocationCoordinate2D?
    var selctedPlace: Place?
    
    @IBOutlet weak var addBTn: UIButton!
    var editMode: Bool = false
    
    lazy var locationVM : LocationVM = {
        return LocationVM()
    }()

    var delegate:DismissVCDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if editMode{
            self.editModeHandler()
        }
    }
        
    //select home place
    @IBAction func homeBtnHandler(_ sender: UIButton) {
        homeBtnChecked()
    }
    
    //select restaurant place
    @IBAction func restBtnHandler(_ sender: UIButton) {
        resBtnChecked()
    }
    
    //select park place
    @IBAction func parkBtnHandler(_ sender: UIButton) {
        parkBtnChecked()
    }
    
    @IBAction func addPlaceBtnHandler(_ sender: UIButton) {
      validationCheck()
    }

}

extension AddPlaceVC{
    
    // input textfield validation
    func validationCheck(){
        if locationVM.locationType == 0{
            showToast(message: "please select place type first")
            return
        }
        
        if checkPlaceName() == false{
            showToast(message: "place lenght should be more than four charchters")
            return
        }
        
        if locationVM.validatePlacePhone(phoneTxt: placePhoneTxt){
            if editMode{
                editPlace()
            }else{
                savePlace()
            }
        }else{
            showToast(message: "phone num is not valid")
        }
    }

    // check place name validation
    func checkPlaceName() -> Bool{
        guard let placeName = placeNameTxt.text else{
            return false
        }
        
        if placeName.count < 4{
            return false
        }
        
        return true
    }
    
    // save place
    func savePlace(){
        // save place to the db
        locationVM.savePlace(name: placeNameTxt.text ?? "", phone: placePhoneTxt.text ?? "", type: locationVM.locationType, coordinate: selectedLocation!)
        dismissVC()
    }
    
    // edit saved place
    func editPlace(){
        // add new object
        let newObj = locationVM.setNewObj(name: placeNameTxt.text ?? "", phone: placePhoneTxt.text ?? "", type: locationVM.locationType)
        locationVM.updateLocation(oldObj: self.selctedPlace!, newObj: newObj)

        dismissVC()
    }
    
    // edit mode design handler
    func editModeHandler(){
        if let place = selctedPlace{
            switch place.type {
            case LocationTypeEnum.home.rawValue :
                homeBtnChecked()
            case LocationTypeEnum.restaurant.rawValue :
                resBtnChecked()
            case LocationTypeEnum.park.rawValue :
                parkBtnChecked()
            default:
                print("nothing")
            }
           
            placePhoneTxt.text = place.phone
            placeNameTxt.text = place.name
            
            addBTn.setTitle("Save", for: .normal)
        }
    }
    
    func dismissVC(){
        self.dismiss(animated: true) {
            if self.delegate != nil {
                self.delegate?.dismissVC()
            }
        }
    }
    
    // home btn design handler
    func homeBtnChecked(){
        locationVM.locationType = LocationTypeEnum.home.rawValue
        homeBtn.backgroundColor = UIColor.yellow
        restBtn.backgroundColor = UIColor.blue
        parkBtn.backgroundColor = UIColor.blue
    }
    
    // restaurant btn design handler
    func resBtnChecked(){
        locationVM.locationType = LocationTypeEnum.restaurant.rawValue
        restBtn.backgroundColor = UIColor.yellow
        homeBtn.backgroundColor = UIColor.blue
        parkBtn.backgroundColor = UIColor.blue
    }
    
    //park btn design handler
    func parkBtnChecked(){
        locationVM.locationType = LocationTypeEnum.park.rawValue
        parkBtn.backgroundColor = UIColor.yellow
        restBtn.backgroundColor = UIColor.blue
        homeBtn.backgroundColor = UIColor.blue
    }
}

//MARK:-UITextFieldDelegate
extension AddPlaceVC:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       self.view.endEditing(true)
       return true
    }
}
