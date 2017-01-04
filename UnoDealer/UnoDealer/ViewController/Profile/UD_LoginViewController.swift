//
//  UD_LoginViewController.swift
//  UnoDealer
//
//  Created by mac on 1/4/17.
//  Copyright © 2017 VietAnh. All rights reserved.
//

import UIKit
import FirebaseAuth
class UD_LoginViewController: UIViewController {
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblPassword: UILabel!
    @IBOutlet weak var constraintTop: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtUsername.delegate = self
        self.txtPassword.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clickSignIn(_ sender: Any) {
        if txtUsername.text == nil || txtUsername.text == "" {
            showAlertView(self, title: "", message: "Please fill in email field to continue")
            self.txtUsername.becomeFirstResponder()
        } else if txtPassword.text == nil || txtPassword.text == "" {
            showAlertView(self, title: "", message: "Please fill in password field to continue")
            self.txtPassword.becomeFirstResponder()
        } else {
            FIRAuth.auth()?.signIn(withEmail: txtUsername.text!, password: txtPassword.text!) { (user, error) in
                if error == nil {
                    self.moveToMainView(username: (user?.email)!)
                } else {
                    showAlertView(self, title: "", message: "Cannot register")
                }
            }
        }
    }

    @IBAction func clickFacebookSignIn(_ sender: Any) {
    }

    @IBAction func clickForgotPassword(_ sender: Any) {
    }
    
    @IBAction func clickRegister(_ sender: Any) {
        let signUpVC = UD_SignUpViewController(nibName: "UD_SignUpViewController", bundle: Bundle.main)
        self.navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    func moveToMainView(username: String) {
        let mainViewVC = UD_MainViewController(nibName: "UD_MainViewController", bundle: Bundle.main)
        mainViewVC.username = username
        self.navigationController?.pushViewController(mainViewVC, animated: true)
    }
}

extension UD_LoginViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.constraintTop.constant = 30
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.constraintTop.constant = 100
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtUsername {
            self.txtPassword.becomeFirstResponder()
        } else {
            self.clickSignIn(Any.self)
        }
        return true
    }
}
