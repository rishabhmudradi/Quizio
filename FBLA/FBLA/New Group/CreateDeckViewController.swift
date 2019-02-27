//
//  CreateDeckViewController.swift
//  FBLA
//
//  Created by Rishabh Mudradi on 1/10/19.
//  Copyright © 2019 Rishabh Mudradi. All rights reserved.
//

import UIKit

class CreateDeckViewController: UIViewController, UIScrollViewDelegate {
    override var prefersStatusBarHidden: Bool {
        return true
    }
    var titleTextField:UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Create a new Deck!"
        view.backgroundColor = UIColor.white
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(CreateDeckViewController.cancel))
        navigationItem.leftBarButtonItem?.tintColor = UIColor(red:0.30, green:0.18, blue:0.86, alpha:1.0)
        
        let scrollView = UIScrollView(frame: view.bounds)
        scrollView.alwaysBounceVertical = true
        scrollView.delegate = self
        scrollView.delaysContentTouches = false
        view.addSubview(scrollView)
        
        titleTextField = UITextField(frame: CGRect(x: 16, y: 16, width: view.frame.width-16, height: 40))
        titleTextField.placeholder = "Title"
        scrollView.addSubview(titleTextField)
        titleTextField.becomeFirstResponder()
        
        let line = UIView(frame: CGRect(x: 16, y: titleTextField.frame.maxY+4, width: view.frame.width-16, height: 1))
        line.backgroundColor = UIColor(white: 0.9, alpha: 1)
        scrollView.addSubview(line)
        
        let createButton = UIButton(type: UIButton.ButtonType.system)
        createButton.frame = CGRect(x: 16, y: line.frame.maxY+8, width: view.frame.width-32, height: 40)
        createButton.setTitle("Create Deck", for: UIControl.State())
        createButton.addTarget(self, action: #selector(CreateDeckViewController.createDeck), for: UIControl.Event.touchUpInside)
        createButton.setTitleColor(UIColor(red:0.51, green:0.22, blue:1.00, alpha:1.0), for: .normal)
        createButton.titleLabel?.font =  UIFont(name: "AvenirNext-DemiBold", size: 20)
        scrollView.addSubview(createButton)
        
    }
    
    @objc func createDeck() {
        var title = titleTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces)
        if title == "" {
            title = "Untitled"
        }
        var array:[AnyObject]! = []
        if UserDefaults.standard.object(forKey: "flashcardArray") != nil {
        array = UserDefaults.standard.object(forKey: "flashcardArray") as! [AnyObject]
        }
        
        let dict:[String:AnyObject] = ["title":title! as AnyObject]
        
        array.append(dict as AnyObject)
        UserDefaults.standard.set(array, forKey: "flashcardArray")
        NotificationCenter.default.post(name: Notification.Name(rawValue: "refreshLibrary"), object: nil)
        cancel()
        let alert  = SCLAlertView().showSuccess("Deck Created!", subTitle: "Click on your deck to study and add cards!" )
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
    @objc func cancel() {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
}
