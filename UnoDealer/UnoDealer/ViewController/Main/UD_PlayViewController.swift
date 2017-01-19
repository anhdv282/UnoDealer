//
//  UD_PlayViewController.swift
//  UnoDealer
//
//  Created by mac on 1/10/17.
//  Copyright © 2017 VietAnh. All rights reserved.
//

import UIKit
import FirebaseAuth
class UD_PlayViewController: UIViewController {
    var user:User!
    var room:Room!
    var listUserJoin:[User] = [User]()
    
    @IBOutlet weak var tableViewUser: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        FIRAuth.auth()!.addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            self.user = User(authData: user)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clickBack(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }

    
    @IBAction func clickClose(_ sender: UIButton) {
        if room.addedByUser == user.email {
            print("Close")
        } else {
            showAlertView(self, title: "Error", message: "Error")
        }
    }
}

extension UD_PlayViewController : UITableViewDelegate,UITableViewDataSource {
    // datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listUserJoin.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UD_UserJoinTableViewCell", for: indexPath as IndexPath) as! UD_UserJoinTableViewCell
        return cell
    }
}
