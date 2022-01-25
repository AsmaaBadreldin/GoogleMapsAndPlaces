//
//  UIViewControllerExtention.swift
//  GoogleMapsAndPlaces
//
//  Created by Asmaa Badreldin on 1/25/22.
//

import Foundation
import UIKit

extension UIViewController{
    
    func showToast(message : String) {
        let toastLabel = UILabel(frame: CGRect(x: 50, y: self.view.frame.size.height/2 - 80, width: self.view.frame.size.width - 100, height: 160))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center
        toastLabel.numberOfLines = 0
        toastLabel.font = UIFont(name: "GESSTwoLight-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 5.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    func getPresentedController() -> UIViewController {
        var topViewController = UIApplication.shared.delegate!.window!!.rootViewController!
        while (topViewController.presentedViewController != nil) {
            topViewController = topViewController.presentedViewController!
        }
        return topViewController
    }
}
