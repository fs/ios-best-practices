//
//  ForgotPasswordViewController.swift
//  Fuhwe
//
//  Created by Nikita Asabin on 12.02.16.
//  Copyright © 2016 Flatstack. All rights reserved.
//

import UIKit

protocol ForgotPasswordViewControllerDelegate {
    func resetPasswordInstructionWasSended()
}

class ForgotPasswordViewController: UIViewController, FSKeyboardScrollSupport {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var delegate: ForgotPasswordViewControllerDelegate?
    
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

    @IBAction func sendResetLink(sender: AnyObject) {
        
        if self.emailTextField.text?.fs_emailValidate() == false{
            ShowOKAlert("Email must be correct", onViewController: self)
        } else {
        SVProgressHUD.show()
        AuthorizationAPIManager.defaultAuthorization.resetPassword(self.emailTextField.text!, success: { (response) -> Void in
            
            self.emailTextField.resignFirstResponder()
            self.dismissViewControllerAnimated(false, completion:{
                SVProgressHUD.dismiss()
                self.delegate?.resetPasswordInstructionWasSended()
            })
            
            }) { (task, error) -> Void in
                SVProgressHUD.dismiss()
                self.emailTextField.resignFirstResponder()
                ShowOKAlert("Something went wrong", onViewController: self)
                
            }
            
        }
    }

    @IBAction func backToSignIn(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
extension ForgotPasswordViewController {
    
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


