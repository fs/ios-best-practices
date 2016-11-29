//
//  SignUpWithEmailViewController.swift
//  swift-base
//
//  Created by Nikita Asabin on 04.02.16.
//  Copyright © 2016 Flatstack. All rights reserved.
//

import UIKit

class SignUpWithEmailViewController: UIViewController, FSKeyboardScrollSupport {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfiramtionTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var firstNameValidationErrorLabel: UILabel!
    @IBOutlet weak var lastNameValidationErrorLabel: UILabel!
    @IBOutlet weak var emailValidationErrorLabel: UILabel!
    @IBOutlet weak var passwordValidationErrorLabel: UILabel!
    @IBOutlet weak var passwordConfiramtionValidationErrorLabel: UILabel!
    
    var mode: AutorizationMode?
    var fs_keyboardScrollSupportScrollView: UIScrollView? {
        return self.scrollView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.fs_keyboardScrollSupportRemoveNotifications()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.fs_keyboardScrollSupportRegisterForNotifications()
    }
    
    
    @IBAction func signUpSignInWithEmail(sender: AnyObject) {
        if self.validateTextFields() == true {
            SVProgressHUD.show()
            guard let lEmail = emailTextField.text, lPassword = passwordTextField.text, lFirstName = firstNameTextField.text, lLastName = lastNameTextField.text else {return}
            let params = ["email":lEmail, "password":lPassword, "password_confirmation":lPassword,"first_name":lFirstName, "last_name": lLastName]
            
            self.view.endEditing(true)
            AuthorizationAPIManager.defaultAuthorization.signUpWithEmail(params, success: { (response) -> Void in
                SVProgressHUD.dismiss()
                ShowOKAlert("Successfully logged in", onViewController: self)
            }) { (task, error) -> Void in
                SVProgressHUD.dismiss()
                ShowOKAlert("Something went wrong", onViewController: self)
            }
        }
    }
    
    func validateTextFields() -> Bool {
        var validationState = true
        self.firstNameValidationErrorLabel.hidden = true
        self.lastNameValidationErrorLabel.hidden = true
        self.emailValidationErrorLabel.hidden = true
        self.passwordValidationErrorLabel.hidden = true
        self.passwordConfiramtionValidationErrorLabel.hidden = true
        
        if self.firstNameTextField.text?.isEmpty == true {
            self.firstNameValidationErrorLabel.hidden = false
            self.firstNameValidationErrorLabel.text = "Please enter your First Name"
            validationState = false
        }
        if self.lastNameTextField.text?.isEmpty == true {
            self.lastNameValidationErrorLabel.hidden = false
            self.lastNameValidationErrorLabel.text = "Please enter your Last Name"
            validationState = false
        }
        
        if self.passwordTextField.text?.isEmpty == true {
            self.passwordValidationErrorLabel.hidden = false
            self.passwordValidationErrorLabel.text = "Password is empty"
            validationState = false
        }
        if self.passwordTextField.text != self.passwordConfiramtionTextField.text {
            self.passwordConfiramtionValidationErrorLabel.hidden = false
            self.passwordConfiramtionValidationErrorLabel.text = "Passwords must be equal"
            validationState = false
        }
        if self.emailTextField.text?.fs_emailValidate() == false{
            self.emailValidationErrorLabel.hidden = false
            self.emailValidationErrorLabel.text = "Email is incorrect"
            validationState = false
        }
        if validationState == false {
            self.scrollView.setContentOffset(CGPointMake(0, 0), animated: true)
        }
        
        return validationState
    }
    
    @IBAction func signUpWithFacebook(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func signUpWithGoogle(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func showSignIn(sender: AnyObject) {
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("SignIn") as! SignUpViewController
        vc.mode = .SignIn
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
}

extension SignUpWithEmailViewController {
    
    
    func fs_keyboardScrollSupportKeyboardWillShow (notif: NSNotification) {
        
        guard let scrollView = self.fs_keyboardScrollSupportScrollView else {return}
        
        guard let info = notif.userInfo else {return}
        guard let value = info[UIKeyboardFrameEndUserInfoKey] as? NSValue else {return}
        
        let keyboardFrame = value.CGRectValue()
        let contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardFrame.height, 0.0)
        
        scrollView.contentInset             = contentInsets
        scrollView.scrollIndicatorInsets    = contentInsets
        
        // If active text field is hidden by keyboard, scroll it so it's visible
        // Your app might not need or want this behavior.
        guard let activeField = self.fs_keyboardScrollSupportActiveField else {return}
        
        // By default activeField must be subview of the scrollView
        guard let superview = activeField.superview else {return}
        guard superview == scrollView else {return}
        
        var viewRect = self.view.frame
        viewRect.size.height -= keyboardFrame.height
        
        let convertedRect = superview.convertRect(activeField.frame, toView: self.view)
        
        if !CGRectContainsPoint(viewRect, convertedRect.origin)  {
            scrollView.scrollRectToVisible(activeField.frame, animated: true)
        }
    }
    
    func fs_keyboardScrollSupportKeyboardWillHide (notif: NSNotification) {
        
        guard let scrollView = self.fs_keyboardScrollSupportScrollView else {return}
        
        let contentInsets = UIEdgeInsetsZero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
}

