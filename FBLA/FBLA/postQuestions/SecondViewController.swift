//
//  SecondViewController.swift
//  FBLA
//
//  Created by Rishabh Mudradi on 2/12/19.
//  Copyright © 2019 Rishabh Mudradi. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func help(_ sender: Any) {
        SCLAlertView().showNotice("Type a Question", subTitle: "Need some help from your amazing FBLA community, type a question and you will receive answers from your peers. Theres no shame in asking question so we made this easy and have full anonymity. Ask away!")
    }
    @IBOutlet weak var input: UITextField!
    
    @IBAction func addItem(_ sender: AnyObject)
    {
        if (input.text != "")
        {
            list.append(input.text!)
            input.text = ""
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

