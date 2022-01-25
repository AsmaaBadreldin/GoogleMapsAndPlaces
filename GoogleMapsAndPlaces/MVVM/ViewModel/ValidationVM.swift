//
//  ValidationVM.swift
//  GoogleMapsAndPlaces
//
//  Created by Asmaa Badreldin on 1/25/22.
//

import Foundation
import UIKit

class ValidationVM: NSObject {
    
    public static let shared = ValidationVM()
    
    func validate(values: (type: ValidationType, inputValue: String, textField: UITextField)...) -> (UITextField, Valid) {
        for valueToBeChecked in values {
            switch valueToBeChecked.type {
            case .phoneNo:
                if let tempValue = isValidString((valueToBeChecked.inputValue, .phoneNo, .emptyPhone, .inValidPhone)) {
                    return (valueToBeChecked.textField, tempValue)
                }
            }
        }
        return (UITextField(), .success)
    }
    
    func isValidString(_ input: (text: String, regex: RegEx, emptyAlert: AlertMessages, invalidAlert: AlertMessages)) -> Valid? {
        if input.text.isEmpty {
            return .failure(.error, input.emptyAlert)
        } else if isValidRegEx(input.text, input.regex) != true {
            return .failure(.error, input.invalidAlert)
        }
        return nil
    }
    
    func isValidRegEx(_ testStr: String, _ regex: RegEx) -> Bool {
        let stringTest = NSPredicate(format: "SELF MATCHES %@", regex.rawValue)
        let result = stringTest.evaluate(with: testStr)
        return result
    }
}

enum Alert {//for failure and success results
    case success
    case failure
    case error
}

//for success or failure of validation with alert message
enum Valid {
    case success
    case failure(Alert, AlertMessages)
}

enum ValidationType {
    case phoneNo
}

enum RegEx: String {
    case phoneNo = "[0-9]{9,13}" // PhoneNo 10-14 Digits
}

enum AlertMessages: String {
    case inValidPhone = "Please inter valid phone number"

    case emptyPhone = "Empty Phone"
}
