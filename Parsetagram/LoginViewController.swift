//
//  LoginViewController.swift
//  Parsetagram
//
//  Created by cory on 2/29/20.
//  Copyright © 2020 royalty. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onLogin(_ sender: Any) {
        let username = usernameField.text!
        let password = passwordField.text!
        
        PFUser.logInWithUsername(inBackground: username, password: password) { (user, error) in
            if user != nil {//If PFUser "user" is equal/is successful, then do something (like login)
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
                
            } else {
                print("An error has occurred: \(error?.localizedDescription)")
            }
        }
        
    }
    
    @IBAction func onSignUp(_ sender: Any) {
        let user = PFUser()//Part of "Parse" import
        user.username = usernameField.text
        user.password = passwordField.text
        /*
        // other fields can be set just like with PFObject
        user["phone"] = "415-392-0202"
         */
        user.signUpInBackground { (success, error) in//Success and error are a bool and exception respectively that are used to show if sign up was correct or if it failed
            if success {
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            } else {
                print("An error has occurred: \(error?.localizedDescription)")
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
/*
 Note: If verification is required, conntect the login view controller to the next controller rather than connecting the login button to the next controller
 */
