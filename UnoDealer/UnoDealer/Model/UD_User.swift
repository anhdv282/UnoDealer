//
//  UD_User.swift
//  UnoDealer
//
//  Created by mac on 1/23/17.
//  Copyright © 2017 VietAnh. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct UD_User {
    
    let key: String
    let dateJoined: Double
    let email: String
    let username: String
    let income: Float
    var isActive: Bool
    var isWinner: Bool = false
    let ref: FIRDatabaseReference?
    
    
    init(dateJoined: Double, email: String, username: String, isActive: Bool, income: Float, key: String = "") {
        self.key = key
        self.username = username
        self.email = email
        self.isActive = isActive
        self.dateJoined = dateJoined
        self.income = income
        self.ref = nil
    }
    
    init(snapshot: FIRDataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        dateJoined = snapshotValue["date"] as! Double
        email = snapshotValue["email"] as! String
        username = snapshotValue["username"] as! String
        isActive = snapshotValue["isActive"] as! Bool
        income = snapshotValue["income"] as! Float
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "date": dateJoined,
            "email": email,
            "username": username,
            "isActive": isActive,
            "income": income
        ]
    }
}
