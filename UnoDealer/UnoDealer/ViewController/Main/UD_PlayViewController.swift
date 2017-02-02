//
//  UD_PlayViewController.swift
//  UnoDealer
//
//  Created by mac on 1/10/17.
//  Copyright © 2017 VietAnh. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import MBProgressHUD
class UD_PlayViewController: UIViewController {
    var user:User!
    var room:Room!
    var listUserJoin:[UD_User] = [UD_User]()
    let refUsers = FIRDatabase.database().reference(withPath: "users")
    @IBOutlet weak var tableViewUser: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewUser.register(UINib(nibName: "UD_UserJoinTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "UD_UserJoinTableViewCell")
        FIRAuth.auth()!.addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            self.user = User(authData: user)
        }
        MBProgressHUD.showAdded(to: self.view, animated: true)
        //        refUsers.child(room.key).queryOrderedByKey().observe(.value, with: { (snapshot) in
        //
        //        })
        refUsers.queryOrdered(byChild: "date").observe(.value, with: { snapshot in
            var newItems: [UD_User] = [UD_User]()
            
            for item in snapshot.children {
                let groceryItem = UD_User(snapshot: item as! FIRDataSnapshot)
                newItems.append(groceryItem)
            }
            
            self.listUserJoin = newItems.reversed()
            self.tableViewUser.reloadData()
            MBProgressHUD.hide(for: self.view, animated: true)
        })
        //        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clickBack(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickDone(_ sender: UIButton) {
        // Create the alert controller
        let alertController = UIAlertController(title: "Do you want Finish this game ?", message: "", preferredStyle: .alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "Finish", style: UIAlertActionStyle.default) {
            UIAlertAction in
            //
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            
        }
        
        // Add the actions
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func clickClose(_ sender: UIButton) {
        
    }
}

extension UD_PlayViewController : UITableViewDelegate,UITableViewDataSource {
    // datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listUserJoin.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UD_UserJoinTableViewCell", for: indexPath as IndexPath) as! UD_UserJoinTableViewCell
        cell.txtCards.isHidden = false
        cell.amount.isHidden = true
        cell.username.text = listUserJoin[indexPath.row].username
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .normal, title: "No Joined") { (action, indexPath) in
            self.listUserJoin.remove(at: indexPath.row)
            self.tableViewUser.reloadData()
        }
        let winner = UITableViewRowAction(style: .destructive, title: "Winner") { (action, indexPath) in
            
            self.listUserJoin[indexPath.row].isWinner = !self.listUserJoin[indexPath.row].isWinner
            tableView.cellForRow(at: indexPath)?.backgroundColor = self.listUserJoin[indexPath.row].isWinner ? UIColor.red:UIColor.clear
            self.tableViewUser.reloadData()
        }
        return [winner,delete]
    }
}
