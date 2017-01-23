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
    let dateJoined: String
    let username: String
    let income: Float
    var isActive: Bool
    let ref: FIRDatabaseReference?
    
    
    init(dateJoined: String, username: String, isActive: Bool, income: Float, key: String = "") {
        self.key = key
        self.username = username
        self.isActive = isActive
        self.dateJoined = dateJoined
        self.income = income
        self.ref = nil
    }
    
    init(snapshot: FIRDataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        dateJoined = snapshotValue["dateJoined"] as! String
        username = snapshotValue["username"] as! String
        isActive = snapshotValue["isActive"] as! Bool
        income = snapshotValue["income"] as! Float
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "date": dateJoined,
            "username": username,
            "isActive": isActive,
            "income": income
        ]
    }
}
