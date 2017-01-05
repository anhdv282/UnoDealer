//
//  UD_MainViewController.swift
//  UnoDealer
//
//  Created by mac on 1/4/17.
//  Copyright © 2017 VietAnh. All rights reserved.
//

import UIKit
import FirebaseAuth
class UD_MainViewController: UIViewController {
    var username:String?
    @IBOutlet weak var lblUsername: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            self.navigationController?.popViewController(animated: true)
        } catch {
            
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
