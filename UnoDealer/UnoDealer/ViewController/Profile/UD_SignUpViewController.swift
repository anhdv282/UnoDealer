//
//  UD_SignUpViewController.swift
//  UnoDealer
//
//  Created by mac on 1/4/17.
//  Copyright © 2017 VietAnh. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class UD_SignUpViewController: UIViewController {
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblPassword: UILabel!
    @IBOutlet weak var lblConfirmPassword: UILabel!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    
    @IBOutlet weak var constraintTop: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        txtUsername.delegate = self
        txtPassword.delegate = self
        txtConfirmPassword.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clickSubmit(_ sender: Any) {
        if txtUsername.text == nil || txtUsername.text == "" {
            showAlertView(self, title: "", message: "Please fill in email field to continue")
            self.txtUsername.becomeFirstResponder()
        } else if txtPassword.text == nil || txtPassword.text == "" {
            showAlertView(self, title: "", message: "Please fill in password field to continue")
            self.txtPassword.becomeFirstResponder()
        } else if txtConfirmPassword.text == nil || txtConfirmPassword.text == "" {
            showAlertView(self, title: "", message: "Please fill in confirm password field to continue")
            self.txtConfirmPassword.becomeFirstResponder()
        } else if self.txtPassword.text != self.txtConfirmPassword.text {
            showAlertView(self, title: "", message: "Password is not match")
        } else if !isValidEmail(txtUsername.text ?? "") {
            showAlertView(self, title: "", message: "Email is invalid!")
        } else {
            FIRAuth.auth()?.createUser(withEmail: txtUsername.text!, password: txtPassword.text!) { (user, error) in
                if error == nil {
                    FIRAuth.auth()?.signIn(withEmail: self.txtUsername.text!, password: self.txtPassword.text!) { (user, error) in
                        if error == nil {
                            self.moveToMainView(username: (user?.email)!)
                        } else {
                            showAlertView(self, title: "Cannot register", message: "\(error)")
                        }
                    }
                } else {
                    showAlertView(self, title: "Cannot register", message: "\(error)")
                }
            }
        }
    }
    
    @IBAction func clickBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func moveToMainView(username: String) {
        let mainViewVC = UD_MainViewController(nibName: "UD_MainViewController", bundle: Bundle.main)
        mainViewVC.username = username
        self.navigationController?.pushViewController(mainViewVC, animated: true)
    }
}

extension UD_SignUpViewController: UITextFieldDelegate {
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
        } else if textField == txtPassword {
            self.txtConfirmPassword.becomeFirstResponder()
        } else {
            self.clickSubmit(Any.self)
        }
        return true
    }
}
