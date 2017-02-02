//
//  UD_LoginSignUpViewController.swift
//  UnoDealer
//
//  Created by mac on 1/23/17.
//  Copyright © 2017 VietAnh. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import MBProgressHUD
class UD_LoginSignUpViewController: UIViewController {

    let animationDuration = 0.25
    let ref = FIRDatabase.database().reference(withPath: "users")
    
    
    //MARK: - background image constraints
    @IBOutlet weak var backImageLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var backImageBottomConstraint: NSLayoutConstraint!
    
    
    //MARK: - login views and constrains
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var loginContentView: UIView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginButtonVerticalCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginWidthConstraint: NSLayoutConstraint!
    
    
    //MARK: - signup views and constrains
    @IBOutlet weak var signupView: UIView!
    @IBOutlet weak var signupContentView: UIView!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var signupButtonVerticalCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var signupButtonTopConstraint: NSLayoutConstraint!
    
    
    //MARK: - logo and constrains
    @IBOutlet weak var logoView: UIView!
    @IBOutlet weak var logoTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoButtomInSingupConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoCenterConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var forgotPassTopConstraint: NSLayoutConstraint!
//    @IBOutlet weak var socialsView: UIView!
    
    
    //MARK: - input views
    @IBOutlet weak var loginEmailInputView: AMInputView!
    @IBOutlet weak var loginPasswordInputView: AMInputView!
    @IBOutlet weak var signupEmailInputView: AMInputView!
    @IBOutlet weak var signupPasswordInputView: AMInputView!
    @IBOutlet weak var signupPasswordConfirmInputView: AMInputView!
    
    let userDefaults = UserDefaults.standard
    //MARK: - controller
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set view to login mode
        toggleViewMode(animated: false)
        self.loginEmailInputView.textFieldView.text = userDefaults.string(forKey: EMAIL) ?? ""
        if userDefaults.string(forKey: EMAIL) != "" {
            self.loginEmailInputView.labelView.text = ""
        }
        self.loginPasswordInputView.textFieldView.text = userDefaults.string(forKey: PASSWORD) ?? ""
        if userDefaults.string(forKey: PASSWORD) != "" {
            self.loginPasswordInputView.labelView.text = ""
        }
        //add keyboard notification
        NotificationCenter.default.addObserver(self, selector: #selector(keyboarFrameChange(notification:)), name: .UIKeyboardWillChangeFrame, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - button actions
    @IBAction func loginButtonTouchUpInside(_ sender: AnyObject) {
        
        if mode == .signup {
            toggleViewMode(animated: true)
            
        } else{
            if loginEmailInputView.textFieldView.text == nil || loginEmailInputView.textFieldView.text == "" {
                showAlertView(self, title: "", message: "Please fill in email field to continue")
                loginEmailInputView.textFieldView.becomeFirstResponder()
            } else if loginPasswordInputView.textFieldView.text == nil || loginPasswordInputView.textFieldView.text == "" {
                showAlertView(self, title: "", message: "Please fill in password field to continue")
                self.loginPasswordInputView.textFieldView.becomeFirstResponder()
            } else if !isValidEmail(loginEmailInputView.textFieldView.text ?? "") {
                showAlertView(self, title: "", message: "Email is invalid!")
            } else {
                MBProgressHUD.showAdded(to: self.view, animated: true)
                FIRAuth.auth()?.signIn(withEmail: loginEmailInputView.textFieldView.text!, password: loginPasswordInputView.textFieldView.text!) { (user, error) in
                    MBProgressHUD.hide(for: self.view, animated: true)
                    if error == nil {
                        self.setUserDefaults(email: self.signupEmailInputView.textFieldView.text!, password: self.signupPasswordInputView.textFieldView.text!)
                        self.setUserDefaults(email: self.signupEmailInputView.textFieldView.text!, password: self.signupPasswordInputView.textFieldView.text!)
                        self.moveToMainView(username: (user?.email)!)
                    } else {
                        showAlertView(self, title: "", message: "\(error!.localizedDescription~?)")
                    }
                }
            }
        }
    }
    
    @IBAction func signupButtonTouchUpInside(_ sender: AnyObject) {
        
        if mode == .login {
            toggleViewMode(animated: true)
        }else{
            
            if signupEmailInputView.textFieldView.text == nil || signupEmailInputView.textFieldView.text == "" {
                showAlertView(self, title: "", message: "Please fill in email field to continue")
                signupEmailInputView.textFieldView.becomeFirstResponder()
            } else if signupPasswordInputView.textFieldView.text == nil || signupPasswordInputView.textFieldView.text == "" {
                showAlertView(self, title: "", message: "Please fill in password field to continue")
                signupPasswordInputView.textFieldView.becomeFirstResponder()
            } else if signupPasswordConfirmInputView.textFieldView.text == nil || signupPasswordConfirmInputView.textFieldView.text == "" {
                showAlertView(self, title: "", message: "Please fill in confirm password field to continue")
                signupPasswordConfirmInputView.textFieldView.becomeFirstResponder()
            } else if signupPasswordInputView.textFieldView.text != signupPasswordConfirmInputView.textFieldView.text {
                showAlertView(self, title: "", message: "Password is not match")
            } else if !isValidEmail(signupEmailInputView.textFieldView.text ?? "") {
                showAlertView(self, title: "", message: "Email is invalid!")
            } else {
                MBProgressHUD.showAdded(to: self.view, animated: true)
                FIRAuth.auth()?.createUser(withEmail: signupEmailInputView.textFieldView.text!, password: signupPasswordInputView.textFieldView.text!) { (user, error) in
                    if error == nil {
                        FIRAuth.auth()?.signIn(withEmail: self.signupEmailInputView.textFieldView.text!, password: self.signupPasswordInputView.textFieldView.text!) { (user, error) in
                            if error == nil {
                                let date = NSDate()
                                
                                let udUser = UD_User(dateJoined: date.timeIntervalSince1970, email : self.signupEmailInputView.textFieldView.text ?? "", username: self.signupEmailInputView.textFieldView.text ?? "", isActive: true, income: 0)
                                // 3
                                let udUserRef = self.ref.child(user?.uid ?? "")
                                
                                // 4
                                udUserRef.setValue(udUser.toAnyObject())
                                self.setUserDefaults(email: self.signupEmailInputView.textFieldView.text!, password: self.signupPasswordInputView.textFieldView.text!)
                                self.moveToMainView(username: (user?.email)!)
                            } else {
                                showAlertView(self, title: "Cannot register", message: "\(error)")
                            }
                        }
                    } else {
                        showAlertView(self, title: "Cannot register", message: "\(error!.localizedDescription~?)")
                    }
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
            }
            //TODO: signup by this data
            NSLog("Email:\(signupEmailInputView.textFieldView.text) Password:\(signupPasswordInputView.textFieldView.text), PasswordConfirm:\(signupPasswordConfirmInputView.textFieldView.text)")
        }
    }
    
    func moveToMainView(username: String) {
        let mainViewVC = UD_MainViewController(nibName: "UD_MainViewController", bundle: Bundle.main)
        mainViewVC.username = username
        self.navigationController?.pushViewController(mainViewVC, animated: true)
    }
    
    func setUserDefaults(email:String,password:String) {
        userDefaults.set(email, forKey: EMAIL)
        userDefaults.set(password, forKey: PASSWORD)
    }
    //MARK: - toggle view
    func toggleViewMode(animated:Bool){
        
        // toggle mode
        mode = mode == .login ? .signup:.login
        
        
        // set constraints changes
        backImageLeftConstraint.constant = mode == .login ? 0:-self.view.frame.size.width
        
        
        loginWidthConstraint.isActive = mode == .signup ? true:false
        logoCenterConstraint.constant = (mode == .login ? -1:1) * (loginWidthConstraint.multiplier * self.view.frame.size.width)/2
        loginButtonVerticalCenterConstraint.priority = mode == .login ? 300:900
        signupButtonVerticalCenterConstraint.priority = mode == .signup ? 300:900
        
        
        //animate
        self.view.endEditing(true)
        
        UIView.animate(withDuration:animated ? animationDuration:0) {
            
            //animate constraints
            self.view.layoutIfNeeded()
            
            //hide or show views
            self.loginContentView.alpha = mode == .login ? 1:0
            self.signupContentView.alpha = mode == .signup ? 1:0
            
            
            // rotate and scale login button
            let scaleLoginX:CGFloat = mode == .login ? 1:1.5
            let scaleLoginY:CGFloat = mode == .login ? 1:1.5
            let rotateAngleLogin:CGFloat = mode == .login ? 0:CGFloat(-M_PI_2)
            
            var transformLogin = CGAffineTransform(scaleX: scaleLoginX, y: scaleLoginY)
            transformLogin = transformLogin.rotated(by: rotateAngleLogin)
            self.loginButton.transform = transformLogin
            
            
            // rotate and scale signup button
            let scaleSignupX:CGFloat = mode == .signup ? 1:1.5
            let scaleSignupY:CGFloat = mode == .signup ? 1:1.5
            let rotateAngleSignup:CGFloat = mode == .signup ? 0:CGFloat(-M_PI_2)
            
            var transformSignup = CGAffineTransform(scaleX: scaleSignupX, y: scaleSignupY)
            transformSignup = transformSignup.rotated(by: rotateAngleSignup)
            self.signupButton.transform = transformSignup
        }
        
    }
    
    
    //MARK: - keyboard
    func keyboarFrameChange(notification:NSNotification){
        
        let userInfo = notification.userInfo as! [String:AnyObject]
        
        // get top of keyboard in view
        let topOfKetboard = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue .origin.y
        
        
        // get animation curve for animate view like keyboard animation
        var animationDuration:TimeInterval = 0.25
        var animationCurve:UIViewAnimationCurve = .easeOut
        if let animDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber {
            animationDuration = animDuration.doubleValue
        }
        
        if let animCurve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber {
            animationCurve =  UIViewAnimationCurve.init(rawValue: animCurve.intValue)!
        }
        
        
        // check keyboard is showing
        let keyboardShow = topOfKetboard != self.view.frame.size.height
        
        
        //hide logo in little devices
        let hideLogo = self.view.frame.size.height < 667
        
        // set constraints
        backImageBottomConstraint.constant = self.view.frame.size.height - topOfKetboard
        
        logoTopConstraint.constant = keyboardShow ? (hideLogo ? 0:20):50
        logoHeightConstraint.constant = keyboardShow ? (hideLogo ? 0:40):60
        logoBottomConstraint.constant = keyboardShow ? 20:32
        logoButtomInSingupConstraint.constant = keyboardShow ? 20:32
        
        forgotPassTopConstraint.constant = keyboardShow ? 30:45
        
        loginButtonTopConstraint.constant = keyboardShow ? 25:30
        signupButtonTopConstraint.constant = keyboardShow ? 23:35
        
        loginButton.alpha = keyboardShow ? 1:0.7
        signupButton.alpha = keyboardShow ? 1:0.7
        
        
        
        // animate constraints changes
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(animationDuration)
        UIView.setAnimationCurve(animationCurve)
        
        self.view.layoutIfNeeded()
        
        UIView.commitAnimations()
        
    }
    
    //MARK: - hide status bar in swift3
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
