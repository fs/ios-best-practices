//
//  StartViewController.swift
//  Fuhwe
//
//  Created by Nikita Asabin on 08.02.16.
//  Copyright © 2016 Flatstack. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signUp(sender: AnyObject) {
        guard let vc = self.storyboard?.instantiateViewControllerWithIdentifier("SignUp") as? SignUpViewController else {return}
        vc.mode = .SignUp
        self.presentViewController(vc, animated: true, completion: nil)
    }

    @IBAction func signIn(sender: AnyObject) {
        guard let vc = self.storyboard?.instantiateViewControllerWithIdentifier("SignIn") as? SignUpViewController else {return}
        vc.mode = .SignIn
        self.presentViewController(vc, animated: true, completion: nil)
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
