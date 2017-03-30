//
//  JALoginViewController.swift
//  Timebox
//
//  Created by Никита Асабин on 08.12.16.
//  Copyright © 2016 Flatstack. All rights reserved.
//

import UIKit

class JALoginViewController: UIViewController, FSKeyboardScrollSupport {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButtonVerticalConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var fs_keyboardScrollSupportScrollView: UIScrollView? {
        return self.scrollView
    }
    var tbViewController: UIViewController? {
        return self
    }
    
    var isLoginButtonVerticalConstraintUpdated = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.fs_keyboardScrollSupportRemoveNotifications()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.fs_keyboardScrollSupportRegisterForNotifications()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.checkScrollViewContentSize()
    }
    
    func fs_keyboardScrollSupportRegisterForNotifications() {
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyBoardWillShowWrapper(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        center.addObserver(self, selector: #selector(keyBoardWillHideWrapper(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyBoardWillShowWrapper(_ notif:Notification)  {
        self.fs_keyboardScrollSupportKeyboardWillShow(notif)
    }
    func keyBoardWillHideWrapper(_ notif:Notification)  {
        self.fs_keyboardScrollSupportKeyboardWillHide(notif)
    }
    
    func checkScrollViewContentSize() {
        if !self.isLoginButtonVerticalConstraintUpdated {
            let screenHeight = UIScreen.main.bounds.height - 20
            if screenHeight<647 {
                self.loginButtonVerticalConstraint.constant = screenHeight - (647 - self.loginButtonVerticalConstraint.constant) > 40 ? screenHeight - (647 - self.loginButtonVerticalConstraint.constant) : 40
            }
            self.isLoginButtonVerticalConstraintUpdated = true
        }
    }
    
    @IBAction func didTapGesture(_ sender: Any) {
        self.view.endEditing(true)
    }
    @IBAction func login(_ sender: Any) {
        self.view.endEditing(true)
        
        let user = JAUserResourceForAuthorization()
        user.password = self.passwordTextField.text
        user.email = self.loginTextField.text
        self.activityIndicator.startAnimating()
        user.loginUser {[weak self] (resource) in
            self?.activityIndicator.stopAnimating()
            if resource != nil {
                debugPrint(resource?.authentication_token ?? "Token: nil")
                guard let lToken = resource?.authentication_token, let lEmail = resource?.email else {return}
                JASpineManager.shared.setAuthorizationHeader(token:lToken)
                JASpineManager.shared.setEmailHeader(email: lEmail)
                self?.showToDosViewController()
                
            } else {
                debugPrint("Failed")
                ShowOKAlert(message: "Check Your email and password", onViewController: self)
            }
        }
    }

    @IBAction func register(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    
    private func showToDosViewController() {
        let lStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
        guard let vc = lStoryboard.instantiateInitialViewController() else {return}
        self.show(vc, sender: self)
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

extension JALoginViewController {
    
    func fs_keyboardScrollSupportKeyboardWillShow (notif: NSNotification) {
        
        guard let scrollView = self.fs_keyboardScrollSupportScrollView else {return}
        
        guard let info = notif.userInfo else {return}
        guard let value = info[UIKeyboardFrameEndUserInfoKey] as? NSValue else {return}
        
        let keyboardFrame = value.cgRectValue
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
        
        let convertedRect = superview.convert(activeField.frame, to: self.view)
        
        if !viewRect.contains(convertedRect.origin)  {
            scrollView.scrollRectToVisible(activeField.frame, animated: true)
        }
    }
    
    func fs_keyboardScrollSupportKeyboardWillHide (notif: NSNotification) {
        
        guard let scrollView = self.fs_keyboardScrollSupportScrollView else {return}
        
        let contentInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
}

