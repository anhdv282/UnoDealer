//
//  UD_MainViewController.swift
//  UnoDealer
//
//  Created by mac on 1/4/17.
//  Copyright © 2017 VietAnh. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import MBProgressHUD

class UD_MainViewController: UIViewController {
    var username:String?
    let refUsers = FIRDatabase.database().reference(withPath: "users")
    var listUserJoin:[UD_User] = [UD_User]()
    @IBOutlet weak var lblUsername: UILabel!

    @IBOutlet weak var tableViewUsers: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewUsers.register(UINib(nibName: "UD_UserJoinTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "UD_UserJoinTableViewCell")
        refUsers.queryOrdered(byChild: "date").observe(.value, with: { snapshot in
            var newItems: [UD_User] = [UD_User]()
            
            for item in snapshot.children {
                let groceryItem = UD_User(snapshot: item as! FIRDataSnapshot)
                newItems.append(groceryItem)
            }
            
            self.listUserJoin = newItems.reversed()
            self.tableViewUsers.reloadData()
            MBProgressHUD.hide(for: self.view, animated: true)
        })
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        self.lblUsername.text = username ?? ""
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clickJoin(_ sender: Any) {
        let roomVC = UD_RoomViewController(nibName: "UD_RoomViewController", bundle: Bundle.main)
        self.navigationController?.pushViewController(roomVC, animated: true)
    }

    @IBAction func clickLogout(_ sender: Any) {
        do {
            try FIRAuth.auth()!.signOut()
            _ = self.navigationController?.popViewController(animated: true)
        } catch {
            
        }
    }
    
    @IBAction func clickAddNewPlayer(_ sender: Any) {
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Add new player", message: "", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.placeholder = "Name"
        }

        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            print("Text field: \(textField?.text)")
            let date = NSDate()
            let udUser = UD_User(dateJoined: date.timeIntervalSince1970, email : "new@new.com", username: textField?.text ?? "", isActive: true, income: 0)
            // 3
            let udUserRef = self.refUsers.childByAutoId()
            
            // 4
            udUserRef.setValue(udUser.toAnyObject())
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            
        }))
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension UD_MainViewController : UITableViewDelegate,UITableViewDataSource {
    // datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listUserJoin.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UD_UserJoinTableViewCell", for: indexPath as IndexPath) as! UD_UserJoinTableViewCell
        cell.txtCards.isHidden = true
        cell.amount.isHidden = false
        cell.username.text = listUserJoin[indexPath.row].username
        cell.amount.text = "\(listUserJoin[indexPath.row].income) VND"
        return cell
    }
}

