//
//  UD_RoundViewController.swift
//  UnoDealer
//
//  Created by mac on 2/26/17.
//  Copyright © 2017 VietAnh. All rights reserved.
//

import UIKit
import FirebaseDatabase
import MBProgressHUD
class UD_RoundViewController: UIViewController {

    @IBOutlet weak var roundTableView: UITableView!
    var room:Room!
    var listRound:[Round] = [Round]()
    let ref = FIRDatabase.database().reference(withPath: "rooms")
    override func viewDidLoad() {
        super.viewDidLoad()
        roundTableView.register(UINib(nibName: "UD_RoomTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "UD_RoomTableViewCell")
        // Do any additional setup after loading the view.
        MBProgressHUD.showAdded(to: self.view, animated: true)
        ref.child(room.key).child("rounds").queryOrdered(byChild: "date").observe(.value, with: { snapshot in
            var newItems: [Round] = []
            for item in snapshot.children {
                let groceryItem = Round(snapshot: item as! FIRDataSnapshot)
                newItems.append(groceryItem)
            }
            self.listRound = newItems.reversed()
            self.roundTableView.reloadData()
            MBProgressHUD.hide(for: self.view, animated: true)
        })
    }

    @IBAction func clickBack(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickNewRound(_ sender: UIButton) {
        let roundRef = ref.child(room.key).child("rounds").childByAutoId()
        let date = NSDate()
        let newRound = Round(date: date.timeIntervalSince1970, completed: false)
        roundRef.setValue(newRound.toAnyObject())
    }
}

extension UD_RoundViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listRound.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UD_RoomTableViewCell", for: indexPath as IndexPath) as! UD_RoomTableViewCell
        cell.lblDate.text = convertDateToString(date: listRound[indexPath.row].date)
        cell.lblStatus.text = listRound[indexPath.row].completed ? "Closed" : "Open"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if listRound[indexPath.row].completed == false {
            let playVC = UD_PlayViewController(nibName: "UD_PlayViewController", bundle: Bundle.main)
            playVC.round = listRound[indexPath.row]
            playVC.room = self.room
            self.navigationController?.pushViewController(playVC, animated: true)
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
            
                // Create the alert controller
                let alertController = UIAlertController(title: "", message: "Do you want close ?", preferredStyle: .alert)
                
                // Create the actions
                let closeAction = UIAlertAction(title: "Close", style: UIAlertActionStyle.default) {
                    UIAlertAction in
//                    self.ref.child(self.listRoom[indexPath.row].key).updateChildValues(["completed":true])
                    self.roundTableView.reloadData()
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
                    UIAlertAction in
                    
                }
                
                // Add the actions
                alertController.addAction(closeAction)
                alertController.addAction(cancelAction)
                
                // Present the controller
                self.present(alertController, animated: true, completion: nil)
        }
        return [delete]
    }
}
