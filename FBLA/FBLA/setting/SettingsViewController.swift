//
//  SettingsViewController.swift
//  FBLA
//
//  Created by Aryan Kaul on 2/12/19.
//  Copyright © 2019 Aryan Kaul. All rights reserved.
//

import UIKit
import Firebase
class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func contact(_ sender: Any) {
        SCLAlertView().showNotice("Contact Us.", subTitle: "Want more information on Quizio, or have concerns? Contact one of our developers via email (rishabh.mudradi@gmail.com) or via phone (+669-214-0379). Don't forget to like our facebook page!")
    }
    
    @IBAction func bug(_ sender: Any) {
        SCLAlertView().showNotice("Bug Reporting.", subTitle: "We take issues seriously on Quizio, if you ever find a bug or have suggestions on improvment contact us via phone (+669-214-0379). Your help can aid other users as well!")
    }
    
    @IBAction func logout(_ sender: Any) {
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "Start")
                self.present(vc!, animated: true, completion: nil)
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
    
    @IBAction func terms(_ sender: Any) {
        SCLAlertView().showNotice("Terms & Conditions.", subTitle: "Quizio is an IOS application built to aid users for competitions. We take privacy seriously here, and have a secure database to ensure information is not leaked. Additionally we dont want our user to feel shame in asking questions so we purposley developed our Q&A section in full anonymity. If you have further questions, feel free to reach out to us.")
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
