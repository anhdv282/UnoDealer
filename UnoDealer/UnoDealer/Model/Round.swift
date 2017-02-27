//
//  Round.swift
//  UnoDealer
//
//  Created by mac on 2/26/17.
//  Copyright © 2017 VietAnh. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

struct Round {
    let key: String
    let date: Double
    let ref: FIRDatabaseReference?
    var completed: Bool
    
    init(date: Double, completed: Bool, key: String = "") {
        self.key = key
        self.completed = completed
        self.date = date
        self.ref = nil
    }
    
    init(snapshot: FIRDataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        date = snapshotValue["date"] as! Double
        completed = snapshotValue["completed"] as! Bool
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "date": date,
            "completed": completed
        ]
    }
}
