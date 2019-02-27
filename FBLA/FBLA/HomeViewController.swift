//
//  HomeViewController.swift
//  FBLA
//
//  Created by Rishabh Mudradi on 2/20/19.
//  Copyright © 2019 Rishabh Mudradi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
class HomeViewController: UIViewController {

    @IBOutlet weak var setting: UIButton!
    @IBOutlet weak var map: UIButton!
    @IBOutlet weak var camera: UIButton!
    @IBOutlet weak var account: UIButton!
    @IBOutlet weak var more: UIButton!
    
    @IBOutlet weak var user: UILabel!
    
    var mapButtonCenter: CGPoint!
    var cameraButtonCenter: CGPoint!
    var accountButtonCenter: CGPoint!
    var settingButtonCenter: CGPoint!
    
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        user.text = Auth.auth().currentUser?.email
        
        mapButtonCenter = map.center
        cameraButtonCenter = camera.center
        accountButtonCenter = account.center
        settingButtonCenter = setting.center
        
        
        map.center = more.center
        setting.center = more.center
        camera.center = more.center
        account.center = more.center
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func help(_ sender: Any) {
        let alert = SCLAlertView()
        alert.addButton("Check out our Facebook page!") {
            if let url = URL(string: "https://www.facebook.com/chsquizio/") {
                UIApplication.shared.canOpenURL(url)
                UIApplication.shared.open(url, options: [:], completionHandler:nil)
                
            }
        }

        alert.showInfo("Need Help?", subTitle: "Click the Quizio icon on any screen to get info, on the home screen click the logo to logout!")
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
    @IBAction func moreClicked(_ sender: UIButton) {
        
        if more.currentImage == UIImage(named: "more1"){
            UIView.animate(withDuration: 0.3, animations: {
                self.map.alpha = 1
                self.camera.alpha = 1
                self.account.alpha = 1
                self.setting.alpha = 1
                
                self.map.center = self.mapButtonCenter
                self.setting.center = self.settingButtonCenter
                self.camera.center = self.cameraButtonCenter
                self.account.center = self.accountButtonCenter
                
            })
        }else{
            
            UIView.animate(withDuration: 0.3, animations: {
                self.map.alpha = 0
                self.camera.alpha = 0
                self.account.alpha = 0
                self.setting.alpha = 0
                
                self.setting.center = self.more.center
                self.map.center = self.more.center
                self.camera.center = self.more.center
                self.account.center = self.more.center
            })
            
            
        }
        toggleButton(button: sender, onImage: UIImage(named: "more1")!, offImage: UIImage(named: "more2")!)

        
    }
    
    func toggleButton(button: UIButton, onImage: UIImage, offImage: UIImage){
        if button.currentImage == offImage{
            button.setImage(onImage, for: .normal)
        }else{
            button.setImage(offImage, for: .normal)
        }
    }

}
