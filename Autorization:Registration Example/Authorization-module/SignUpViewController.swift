//
//  SignUpViewController.swift
//  swift-base
//
//  Created by Nikita Asabin on 01.02.16.
//  Copyright © 2016 Flatstack. All rights reserved.
//

import UIKit
import FBSDKLoginKit

enum AutorizationMode {
    case SignUp
    case SignIn
}

class SignUpViewController: UIViewController, FSKeyboardScrollSupport {
    
    @IBOutlet weak var fbLoginButton: UIButton!
    @IBOutlet weak var googleLoginButton: UIButton!
    @IBOutlet weak var linkedinLoginButton: UIButton!
    @IBOutlet weak var emailLoginButton: UIButton!
    
    //sign in
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var emailValidationErrorLabel: UILabel!
    
    var mode: AutorizationMode?
    var fs_keyboardScrollSupportScrollView: UIScrollView? {
        return self.scrollView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().clientID = "626403655533-qqdnnmtmassteereilt1acqc6d8ii20m.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        self.setupButtons()
        if self.mode == .SignIn {
            var h =  self.view.fs_height - 580
            if h<10 {
                h = 10
            }
            self.heightConstraint.constant = h + self.heightConstraint.constant
            self.emailValidationErrorLabel.hidden = true
        }
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
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
    
    func setupButtons() {
        if self.mode == .SignUp {
            self.emailLoginButton.setTitle("Sign up with email", forState: .Normal)
        } else {
            self.emailLoginButton.setTitle("Login with email", forState: .Normal)
        }
    }
    
    
    var linkedInClient: LIALinkedInHttpClient {
        let application = LIALinkedInApplication(redirectURL: "https://github.com/fs/ios-base-swift", clientId: "77fkkjhfvmg7wj", clientSecret: "BrsCWErZCp7gm45t", state: "DCEEFWF45453sdffef424", grantedAccess: ["r_emailaddress","r_basicprofile"])
        
        return LIALinkedInHttpClient(forApplication: application, presentingViewController: self)
    }
    
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func switchToViewController(viewController:UIViewController){
        guard let window = (UIApplication.sharedApplication().delegate as? AppDelegate)?.window else {fatalError("Can't get current app delegate window")}
        
        window.rootViewController = viewController
        
        UIView.transitionWithView(window, duration: 0.5, options: UIViewAnimationOptions.TransitionFlipFromTop, animations: {
            window.rootViewController = viewController
        }) { (finished) in
            self.dismissViewControllerAnimated(false, completion: nil)
        }
        
    }
    
    @IBAction func signUpSignInWithLinkedIn(sender: AnyObject) {
        self.linkedInClient.getAuthorizationCode({ (code: String!) -> Void in
            self.linkedInClient.getAccessToken(code, success: { (accessTokenData: [NSObject: AnyObject]!) -> Void in
                let accessToken = accessTokenData["access_token"] as! String
                SVProgressHUD.show()
                AuthorizationAPIManager.defaultAuthorization.signUpWithProvider("linkedin", token: accessToken, success: { (response) -> Void in
                    FSDLog("Logged In")
                    SVProgressHUD.dismiss()
                    ShowOKAlert("Successfully logged in", onViewController: self)
                    }, failure: { (task, error) -> Void in
                        SVProgressHUD.dismiss()
                        ShowOKAlert("Something went wrong", onViewController: self)
                })
                }, failure: { (error) -> Void in
                    NSLog("error getting linked in access token: \(error)")
            })
            }, cancel: { () -> Void in
                NSLog("LinkedIn authorization canceled")
        }) { (error) -> Void in
            NSLog("Error getting linkedin auth code: \(error)")
        }
    }
    
    @IBAction func signUpSignInWithGoogle(sender: AnyObject) {
        
        GIDSignIn.sharedInstance().signOut()
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func signUpSignInWithFacebook(sender: AnyObject) {
        
        FBSDKLoginManager().logOut()
        FBSDKLoginManager().logInWithReadPermissions(["public_profile", "email"], fromViewController: self) { (result, error) -> Void in
            if error != nil {
                ShowOKAlert(error.description, onViewController: self)
                FSDLog(error.description)
            } else if result.isCancelled == true {
                FSDLog("Canceled")
            } else {
                SVProgressHUD.show()
                AuthorizationAPIManager.defaultAuthorization.signUpWithProvider("facebook", token: result.token.tokenString, success: { (response) -> Void in
                    FSDLog("Logged In")
                    SVProgressHUD.dismiss()
                    ShowOKAlert("Successfully logged in", onViewController: self)
                    
                    }, failure: { (task, error) -> Void in
                        FSDLog("Logged In")
                        SVProgressHUD.dismiss()
                        ShowOKAlert("Something went wrong", onViewController: self)
                })
                
            }
            
        }
    }
    
    @IBAction func signUpSignInWithEmail(sender: AnyObject) {
        
        if self.mode == .SignIn {
            if self.emailTextField.text?.fs_emailValidate() == false{
                self.emailValidationErrorLabel.hidden = false
                self.emailValidationErrorLabel.text = "Email is incorrect!"
            } else {
                self.emailValidationErrorLabel.hidden = true
                self.view.endEditing(true)
                SVProgressHUD.show()
                AuthorizationAPIManager.defaultAuthorization.signInWithEmail(emailTextField.text!, password: passwordTextField.text!, success: { (response) -> Void in
                    SVProgressHUD.dismiss()
                    ShowOKAlert("Successfully logged in", onViewController: self)
                }) { (task, error) -> Void in
                    SVProgressHUD.dismiss()
                    self.emailValidationErrorLabel.text = "Email or password is incorrect!"
                    self.emailValidationErrorLabel.hidden = false
                }
                
            }
            
        } else {
            guard let vc = self.storyboard?.instantiateViewControllerWithIdentifier("SignUpSignInEmail") as? SignUpWithEmailViewController else {return}
            vc.mode = self.mode
            self.presentViewController(vc, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func showSignIn(sender: AnyObject) {
        guard let vc = self.storyboard?.instantiateViewControllerWithIdentifier("SignIn") as? SignUpViewController else {return}
        vc.mode = .SignIn
        self.switchToViewController(vc)
        
    }
    
    @IBAction func showSignUp(sender: AnyObject) {
        guard let vc = self.storyboard?.instantiateViewControllerWithIdentifier("SignUp") as? SignUpViewController else {return}
        vc.mode = .SignUp
        self.switchToViewController(vc)
    }
    
    @IBAction func showFargotPassword(sender: AnyObject) {
        guard let vc = self.storyboard?.instantiateViewControllerWithIdentifier("ForgotPassword") as? ForgotPasswordViewController else {return}
        vc.delegate = self
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
}


extension SignUpViewController: GIDSignInUIDelegate{
    
    func signInWillDispatch(signIn: GIDSignIn!, error: NSError!) {
        
    }
    
    func signIn(signIn: GIDSignIn!, presentViewController viewController: UIViewController!) {
        self.presentViewController(viewController, animated: true, completion: nil)
    }
    
    func signIn(signIn: GIDSignIn!, dismissViewController viewController: UIViewController!) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}

extension SignUpViewController: GIDSignInDelegate{
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError!) {
        if (error == nil) {
            SVProgressHUD.show()
            AuthorizationAPIManager.defaultAuthorization.signUpWithProvider("google", token: user.authentication.accessToken, success: { (response) -> Void in
                FSDLog("Logged In google")
                SVProgressHUD.dismiss()
                ShowOKAlert("Successfully logged in", onViewController: self)
                }, failure: { (task, error) -> Void in
                    SVProgressHUD.dismiss()
                    ShowOKAlert("Something went wrong", onViewController: self)
            })
            
        } else {
            FSDLog("\(error.localizedDescription)")
        }
    }
}


extension SignUpViewController {
    
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

extension SignUpViewController: ForgotPasswordViewControllerDelegate {
    func resetPasswordInstructionWasSended() {
        let alertView = UIAlertController(title: nil, message: "Reset password instructions was sent to email", preferredStyle: UIAlertControllerStyle.Alert)
        let alertButton = UIAlertAction(title: "OK", style: .Default) { (alertAction: UIAlertAction) -> Void in
            alertView.dismissViewControllerAnimated(true, completion: nil)
        }
        
        alertView.addAction(alertButton)
        
        self.presentViewController(alertView, animated: true, completion: nil)
    }
}



