//
//  Global.swift
//  UnoDealer
//
//  Created by mac on 1/4/17.
//  Copyright © 2017 VietAnh. All rights reserved.
//

import Foundation
import UIKit
//static global
let EMAIL = "email"
let PASSWORD = "password"
//
var mode:AMLoginSignupViewMode = .signup
func showAlertView(_ viewController : UIViewController, title : String, message : String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
    viewController.present(alert, animated: true, completion: nil)
}

func isValidEmail(_ testStr:String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: testStr)
}

func convertDateToString(date: Double) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd MMM yyyy - HH:mm:ss"
    return dateFormatter.string(from: Date(timeIntervalSince1970: date) as Date) ?? ""
}

enum AMLoginSignupViewMode {
    case login
    case signup
}

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
}

private protocol _Optional {//http://stackoverflow.com/questions/25846561/swift-printing-optional-variable
    func unwrappedString() -> String
}

extension Optional: _Optional {
    fileprivate func unwrappedString() -> String {
        switch self {
        case .some(let wrapped as _Optional): return wrapped.unwrappedString()
        case .some(let wrapped): return String(describing: wrapped)
        case .none: return String(describing: self)
        }
    }
}

postfix operator ~?
public postfix func ~? <X> (x: X?) -> String {
    return x.unwrappedString()
}
