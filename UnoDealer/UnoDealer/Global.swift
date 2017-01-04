//
//  Global.swift
//  UnoDealer
//
//  Created by mac on 1/4/17.
//  Copyright © 2017 VietAnh. All rights reserved.
//

import Foundation
import UIKit

func showAlertView(_ viewController : UIViewController, title : String, message : String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
    viewController.present(alert, animated: true, completion: nil)
}
