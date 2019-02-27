//
//  LoginViewController.swift
//  FBLA
//
//  Created by Rishabh Mudradi on 2/18/19.
//  Copyright © 2019 Rishabh Mudradi. All rights reserved.
//

import UIKit
import Firebase
class LoginViewController: UIViewController {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    //Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    //Login Action
    @IBAction func loginAction(_ sender: AnyObject) {
        
        if self.emailTextField.text == "" || self.passwordTextField.text == "" {
            //Alert to tell the user that there was an error because they didn't fill anything in the textfields because they didn't fill anything in
             let alert  = SCLAlertView().showError("Error", subTitle: "Please enter an email and password.")
            
        } else {
            
            Auth.auth().signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!) { (user, error) in
                if error == nil {
                    //Go to the HomeViewController if the login is sucessful
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home") as! HomeViewController
                    self.present(vc, animated: true, completion: nil)
                    
                } else {
                    
                    //Tells the user that there is an error and then gets firebase to tell them the error
                    let alert  = SCLAlertView().showError("Error", subTitle: error?.localizedDescription)
                }
            }
        }
    }
}
