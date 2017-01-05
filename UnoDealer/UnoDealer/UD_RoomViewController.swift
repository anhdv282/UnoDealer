//
//  UD_RoomViewController.swift
//  UnoDealer
//
//  Created by mac on 1/4/17.
//  Copyright © 2017 VietAnh. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class UD_RoomViewController: UIViewController {
    @IBOutlet weak var myTableView: UITableView!
    var user: User!
    let ref = FIRDatabase.database().reference(withPath: "rooms")
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.register(UINib(nibName: "UD_RoomTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "UD_RoomTableViewCell")
        // Do any additional setup after loading the view.
        FIRAuth.auth()!.addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            self.user = User(authData: user)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func clickAdd(_ sender: Any) {
        // Create the alert controller
        let alertController = UIAlertController(title: "", message: "Do you want add a new play room", preferredStyle: .alert)
        
        // Create the actions
        let addAction = UIAlertAction(title: "Add", style: UIAlertActionStyle.default) {
            UIAlertAction in
            let date = NSDate()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateString = dateFormatter.string(from: date as Date)
            // 2
            let groceryItem = Room(date: "test", addedByUser: self.user.email, completed: false)
            // 3
            let groceryItemRef = self.ref.child("test")
            
            // 4
            groceryItemRef.setValue(groceryItem.toAnyObject())
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            
        }
        
        // Add the actions
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
    }
    
}

extension UD_RoomViewController : UITableViewDelegate,UITableViewDataSource {
    // datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UD_RoomTableViewCell", for: indexPath as IndexPath) as! UD_RoomTableViewCell
        return cell
    }
}
