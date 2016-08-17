//
//  LoginViewController.swift
//  DayPhoto
//
//  Created by Nikita Asabin on 17.12.15.
//  Copyright © 2015 Flatstack. All rights reserved.
//

import UIKit
import TwitterKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let vkSdk = VKSdk.initializeWithAppId("5191828")
        vkSdk.registerDelegate(self)
        vkSdk.uiDelegate = self
       
        let blurEffect = UIBlurEffect(style: .Light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = self.view.bounds
        self.view.insertSubview(blurView, atIndex: 0)
        self.createLoginButtons()
        // Do any additional setup after loading the view.
    }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createLoginButtons() {
        let fbLoginButton = FBSDKLoginButton.init()
        fbLoginButton.center = CGPoint.init(x: 120, y: 50)
        self.view.addSubview(fbLoginButton)
        
        let twitterLogInButton = TWTRLogInButton { (session, error) in
            if let unwrappedSession = session {
                let alert = UIAlertController(title: "Logged In",
                    message: "User \(unwrappedSession.userName) has logged in",
                    preferredStyle: UIAlertControllerStyle.Alert
                )
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            } else {
                NSLog("Login error: %@", error!.localizedDescription);
            }
        }
        
        // TODO: Change where the log in button is positioned in your view
        twitterLogInButton.center = CGPointMake(120, 100)
        self.view.addSubview(twitterLogInButton)
        
        let vkLoginButton = UIButton.init(frame: CGRectMake(60, 130, 120, 30))
        vkLoginButton.addTarget(self, action: "loginToVK", forControlEvents: UIControlEvents.TouchUpInside)
        vkLoginButton.backgroundColor = UIColor.blueColor()
        vkLoginButton.setTitle("Login to VK", forState: UIControlState.Normal)
        vkLoginButton.layer.cornerRadius = 10
        vkLoginButton.clipsToBounds = true
        self.view.addSubview(vkLoginButton)
    }

    func loginToVK() {
        VKSdk.authorize(["photo"])
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension LoginViewController: VKSdkDelegate, VKSdkUIDelegate {
    func vkSdkAccessAuthorizationFinishedWithResult(result: VKAuthorizationResult!) {
        
    }
    
    func vkSdkUserAuthorizationFailed() {
        
    }
    
    func vkSdkShouldPresentViewController(controller: UIViewController!) {
        self.showDetailViewController(controller, sender: self)
    }
    func vkSdkNeedCaptchaEnter(captchaError: VKError!) {
        
    }

}
