//
//  PlaceCell.swift
//  GoogleMapsAndPlaces
//
//  Created by Asmaa Badreldin on 1/25/22.
//

import UIKit

class PlaceCell: UITableViewCell {
    @IBOutlet weak var placeNameLbl: UILabel!
    
    var delegate:PlaceCellDelegate?
    @IBOutlet weak var placeImgLbl: UIImageView!
    
    
    lazy var locationVM : LocationVM = {
        return LocationVM()
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func placeDetailsBtnClicked(_ sender: UIButton) {
        self.delegate?.getPlaceDetails(cell: self, sender: sender)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //set values in cell
    func setData(place: Place) {
        if let name = place.name{
            self.placeNameLbl.text = name
        }
        
        let type = place.type
        
        self.placeImgLbl.image = UIImage(named: locationVM.getPlaceIcon(type: type))
    }
}

// place delegate
protocol PlaceCellDelegate {
    func getPlaceDetails(cell:PlaceCell,sender:UIButton)
}
