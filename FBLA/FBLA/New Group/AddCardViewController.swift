//
//  AddCardViewController.swift
//  FBLA
//
//  Created by Rishabh Mudradi on 1/10/19.
//  Copyright © 2019 Rishabh Mudradi. All rights reserved.
//

import UIKit

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class AddCardViewController: UIViewController, UIScrollViewDelegate,UITextViewDelegate {
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    var dict:[AnyHashable: Any]!
    var index:Int!
    var scrollView:UIScrollView!
    var questionTextField:UITextField!
    var answerTextView:UITextView!
    var answerTextViewPlaceholder:UILabel!
    var createButton:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add Card"
        view.backgroundColor = UIColor.white
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(AddCardViewController.cancel))
        
        navigationItem.leftBarButtonItem?.tintColor = UIColor(red:0.30, green:0.18, blue:0.86, alpha:1.0)
        
        scrollView = UIScrollView(frame: view.bounds)
        scrollView.alwaysBounceVertical = true
        scrollView.delegate = self
        scrollView.delaysContentTouches = false
        view.addSubview(scrollView)
        
        questionTextField = UITextField(frame: CGRect(x: 16, y: 16, width: view.frame.width-16, height: 40))
        questionTextField.placeholder = "Question"
        questionTextField.font = UIFont(name:"AvenirNext-Bold", size:16)
        questionTextField.addTarget(self, action: #selector(AddCardViewController.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        scrollView.addSubview(questionTextField)
        questionTextField.becomeFirstResponder()
        
        let line = UIView(frame: CGRect(x: 16, y: questionTextField.frame.maxY+4, width: view.frame.width-16, height: 1))
        line.backgroundColor = UIColor(white: 0.9, alpha: 1)
        scrollView.addSubview(line)
        
        answerTextView = UITextView(frame: CGRect(x: 12, y: line.frame.maxY+8, width: view.frame.width-24, height: 40))
        answerTextView.font = UIFont(name:"AvenirNext-Medium", size:16)
        answerTextView.delegate = self
        scrollView.addSubview(answerTextView)
        
        answerTextViewPlaceholder = UILabel(frame: CGRect(x: 16, y: line.frame.maxY+8, width: view.frame.width-32, height: 36))
        answerTextViewPlaceholder.text = "Answer"
        answerTextViewPlaceholder.textColor = UIColor(white: 0.8, alpha: 1)
        scrollView.addSubview(answerTextViewPlaceholder)
        
        createButton = UIButton(type: UIButton.ButtonType.system)
        createButton.frame = CGRect(x: 16, y: answerTextView.frame.maxY+8, width: view.frame.width-32, height: 40)
        createButton.setTitle("Add Card", for: UIControl.State())
        createButton.setTitleColor(UIColor(red:0.51, green:0.22, blue:1.00, alpha:1.0), for: .normal)
        createButton.titleLabel?.font =  UIFont(name: "AvenirNext-Bold", size: 20)
        createButton.addTarget(self, action: #selector(AddCardViewController.addCard), for: UIControl.Event.touchUpInside)
        createButton.isEnabled = false
        scrollView.addSubview(createButton)
        
    }
    
    @objc func cancel() {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if answerTextView.text.characters.count > 0 && questionTextField.text?.characters.count > 0 {
            createButton.isEnabled = true
        }else{
            createButton.isEnabled = false
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        if textView.text.characters.count > 0 && questionTextField.text?.characters.count > 0 {
            createButton.isEnabled = true
        }else{
            createButton.isEnabled = false
        }
        
        if textView.text.characters.count > 0 {
            self.answerTextViewPlaceholder.alpha = 0
        }else{
            self.answerTextViewPlaceholder.alpha = 1
        }
        
        let size = textView.sizeThatFits(CGSize(width: textView.frame.width, height: .greatestFiniteMagnitude))
        UIView.animate(withDuration: 0.5, animations: {
            textView.frame.size.height = size.height
            self.createButton.frame.origin.y = textView.frame.maxY+8
        }) 
        
        scrollView.contentSize.height = view.frame.height+size.height-120
        
    }
    
    @objc func addCard() {
        
        createButton.isEnabled = false
        
        var cards:[[String:String]]! = []
        let question = questionTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces)
        let answer = answerTextView.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if dict["cards"] != nil {
            cards = dict["cards"] as! [[String:String]]!
        }
        
        cards.append(["question":question!,"answer":answer!])
        
        dict["cards"] = cards
        
        var array = UserDefaults.standard.object(forKey: "flashcardArray") as! [AnyObject]
        array.remove(at: index)
        array.insert(dict as AnyObject, at: index)
        UserDefaults.standard.set(array, forKey: "flashcardArray")
        NotificationCenter.default.post(name: Notification.Name(rawValue: "refreshDeck"), object: nil)
        
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
        SCLAlertView().showSuccess("Card Added!", subTitle: "Your card has now been added to the deck." )

        
    }
    
}
