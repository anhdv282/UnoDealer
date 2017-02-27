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
import MBProgressHUD

class UD_RoomViewController: UIViewController {
    @IBOutlet weak var myTableView: UITableView!
    var user: User!
    var listRoom:[Room] = [Room]()
    let ref = FIRDatabase.database().reference(withPath: "rooms")
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.register(UINib(nibName: "UD_RoomTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "UD_RoomTableViewCell")
        // Do any additional setup after loading the view.
        FIRAuth.auth()!.addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            self.user = User(authData: user)
        }
        MBProgressHUD.showAdded(to: self.view, animated: true)
        ref.queryOrdered(byChild: "date").observe(.value, with: { snapshot in
            var newItems: [Room] = []
            
            for item in snapshot.children {
                let groceryItem = Room(snapshot: item as! FIRDataSnapshot)
                newItems.append(groceryItem)
            }
            
            self.listRoom = newItems.reversed()
            self.myTableView.reloadData()
            MBProgressHUD.hide(for: self.view, animated: true)
        })
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
            //            let dateFormatter = DateFormatter()
            //            dateFormatter.dateFormat = "dd MMM yyyy - HH:mm"
            //            let dateString = dateFormatter.string(from: date as Date)
            // 2
            let groceryItem = Room(date: date.timeIntervalSince1970, addedByUser: self.user.uid, completed: false)
            // 3
            //            let groceryItemRef = self.ref.child(dateString)
            let groceryItemRef = self.ref.childByAutoId()
            // 4
            groceryItemRef.setValue(groceryItem.toAnyObject())
            //            self.addNewRoom()
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
    
    @IBAction func clickBack(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
}

extension UD_RoomViewController : UITableViewDelegate,UITableViewDataSource {
    // datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listRoom.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UD_RoomTableViewCell", for: indexPath as IndexPath) as! UD_RoomTableViewCell
        cell.lblDate.text = convertDateToString(date: listRoom[indexPath.row].date)
        cell.lblStatus.text = listRoom[indexPath.row].completed ? "Closed" : "Open"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if listRoom[indexPath.row].completed == false {
//            let playVC = UD_PlayViewController(nibName: "UD_PlayViewController", bundle: Bundle.main)
//            playVC.round = listRoom[indexPath.row]
//            self.navigationController?.pushViewController(playVC, animated: true)
            let roundVC = UD_RoundViewController(nibName: "UD_RoundViewController", bundle: Bundle.main)
            roundVC.room = listRoom[indexPath.row]
            self.navigationController?.pushViewController(roundVC, animated: true)
        } else {
            showAlertView(self, title: "", message: "This game is closed")
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Close") { (action, indexPath) in
            // delete item at indexPath
            if self.listRoom[indexPath.row].addedByUser == self.user.uid {
                // Create the alert controller
                let alertController = UIAlertController(title: "", message: "Do you want close ?", preferredStyle: .alert)
                
                // Create the actions
                let closeAction = UIAlertAction(title: "Close", style: UIAlertActionStyle.default) {
                    UIAlertAction in
                    self.ref.child(self.listRoom[indexPath.row].key).updateChildValues(["completed":true])
                    self.myTableView.reloadData()
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
                    UIAlertAction in
                    
                }
                
                // Add the actions
                alertController.addAction(closeAction)
                alertController.addAction(cancelAction)
                
                // Present the controller
                self.present(alertController, animated: true, completion: nil)
                
            } else {
                showAlertView(self, title: "", message: "You don't have permission to close")
            }
        }
        return [delete]
    }
}
