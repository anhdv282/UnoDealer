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
    var listUserAdd:[UD_User] = [UD_User]()
    var existWinner:Bool = false
    var indexWinner:Int = -1
    let refUsers = FIRDatabase.database().reference(withPath: "users")
    let refRooms = FIRDatabase.database().reference(withPath: "rooms")
    @IBOutlet weak var viewAddUser: UIView!
    @IBOutlet weak var tableViewUser: UITableView!
    @IBOutlet weak var tableViewUserAdd: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewUserAdd.register(UINib(nibName: "UD_UserAddTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "UD_UserAddTableViewCell")
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
            if snapshot.exists() {
                var newItems: [UD_User] = [UD_User]()
                for item in snapshot.children {
                    let groceryItem = UD_User(snapshot: item as! FIRDataSnapshot)
                    newItems.append(groceryItem)
                }
                
                self.listUserAdd = newItems.reversed()
                self.tableViewUserAdd.reloadData()
            } else {
                print("Yuck")
            }
            MBProgressHUD.hide(for: self.view, animated: true)
        })
        
        refRooms.child(room.key).child("users").observe(.value, with: { (snapshot) in
            if snapshot.exists() {
                var newItems: [UD_User] = [UD_User]()
                for item in snapshot.children {
                    let groceryItem = UD_User(snapshot: item as! FIRDataSnapshot)
                    newItems.append(groceryItem)
                }
                
                self.listUserJoin = newItems.reversed()
                self.tableViewUser.reloadData()
            }
        })
        //        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func clickCloseAddUser(_ sender: UIButton) {
        self.viewAddUser.isHidden = true
    }
    
    @IBAction func clickBack(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func clickDone(_ sender: UIButton) {
        // Create the alert controller
        let alertController = UIAlertController(title: "Finish this game ?", message: "", preferredStyle: .alert)
        
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
        self.viewAddUser.isHidden = false
    }
    
    func addNewUser(user : UD_User) {
        let roomUser = refRooms.child(room.key).child("users").child(user.key)
        roomUser.setValue(user.toAnyObject()) { (error, ref) in
            if error == nil {
                print("Done")
            } else {
                print("Fail")
            }
        }
    }
    
    func removeUser(user : UD_User) {
        let roomUser = refRooms.child(room.key).child("users").child(user.key)
        roomUser.removeValue()
    }
}

extension UD_PlayViewController : UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        addToolBar(textField: textField)
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        print("\(textField.text)")
        if indexWinner > -1 {
            let keyUser:String = self.listUserJoin[indexWinner].key
            let userPath = refRooms.child(room.key).child("users").child(keyUser)
            let incomePath = userPath.child("income")
            let income = self.listUserJoin[indexWinner].income
            let newIncome = (textField.text == "") ? 0 : Float(textField.text!)
            let finalIncome = income + newIncome!
            MBProgressHUD.showAdded(to: self.view, animated: true)
            incomePath.setValue(finalIncome, withCompletionBlock: { (error, ref) in
                if error == nil {
//                    self.tableViewUser.reloadData()
                } else {
                    showAlertView(self, title: "", message: (error?.localizedDescription)!)
                }
                MBProgressHUD.hide(for: self.view, animated: true)
            })
        } else {
            showAlertView(self, title: "", message: "Please choose a winner!")
        }
        return true
    }
    
    func addToolBar(textField: UITextField) {
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76 / 255, green: 217 / 255, blue: 100 / 255, alpha: 1)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(donePressed))
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        
        
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        
        textField.delegate = self
        textField.inputAccessoryView = toolBar
    }
    
    func donePressed() {
        view.endEditing(true)
        
    }
    
    func cancelPressed() {
        view.endEditing(true) // or do something
    }
}

extension UD_PlayViewController : UITableViewDelegate,UITableViewDataSource {
    // datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (tableView == tableViewUser) ? listUserJoin.count : listUserAdd.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tableViewUser {
            let cellUserJoin = tableView.dequeueReusableCell(withIdentifier: "UD_UserJoinTableViewCell", for: indexPath as IndexPath) as! UD_UserJoinTableViewCell
            print("\(listUserJoin[indexPath.row].isWinner)")
            cellUserJoin.txtCards.isHidden = listUserJoin[indexPath.row].isWinner
            cellUserJoin.txtCards.delegate = self
            cellUserJoin.amount.isHidden = listUserJoin[indexPath.row].isWinner ? false : true
            cellUserJoin.amount.text = "\(listUserJoin[indexPath.row].income)"
            cellUserJoin.username.text = listUserJoin[indexPath.row].username
            cellUserJoin.selectionStyle = .none
            return cellUserJoin
        } else {
            let cellUserAdd = tableView.dequeueReusableCell(withIdentifier: "UD_UserAddTableViewCell", for: indexPath as IndexPath) as! UD_UserAddTableViewCell
            cellUserAdd.labelName.text = listUserAdd[indexPath.row].username
            return cellUserAdd
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if tableView == tableViewUser {
            if self.listUserJoin[indexPath.row].isWinner {
                return true
            }
            return !self.existWinner
        } else {
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let cell = tableView.cellForRow(at: indexPath) as? UD_UserJoinTableViewCell
        
        let winner = UITableViewRowAction(style: .destructive, title: self.existWinner ? "Not Winner" : "Winner") { (action, indexPath) in
            self.listUserJoin[indexPath.row].isWinner = !self.listUserJoin[indexPath.row].isWinner
            cell?.backgroundColor = self.listUserJoin[indexPath.row].isWinner ? UIColor.red:UIColor.clear
            cell?.txtCards.isEnabled = !self.listUserJoin[indexPath.row].isWinner
            self.indexWinner = !self.existWinner ? indexPath.row : -1
            self.existWinner = !self.existWinner
            self.tableViewUser.reloadData()
        }
        
        return [winner]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tableViewUserAdd {
            if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
                tableView.cellForRow(at: indexPath)?.accessoryType = .none
                self.removeUser(user: self.listUserAdd[indexPath.row])
            } else {
                tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
                self.addNewUser(user: self.listUserAdd[indexPath.row])
            }
        }
    }
}
