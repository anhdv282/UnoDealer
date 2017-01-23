//
//  Room.swift
//  UnoDealer
//
//  Created by mac on 1/5/17.
//  Copyright © 2017 VietAnh. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

struct Room {
    
    let key: String
    let date: Double
    let addedByUser: String
    let ref: FIRDatabaseReference?
    var completed: Bool
    
    init(date: Double, addedByUser: String, completed: Bool, key: String = "") {
        self.key = key
        self.addedByUser = addedByUser
        self.completed = completed
        self.date = date
        self.ref = nil
    }
    
    init(snapshot: FIRDataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        date = snapshotValue["date"] as! Double
        addedByUser = snapshotValue["addedByUser"] as! String
        completed = snapshotValue["completed"] as! Bool
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "date": date,
            "addedByUser": addedByUser,
            "completed": completed
        ]
    }
}


