//
//  EditCardViewController.swift
//  FBLA
//
//  Created by Rishabh Mudradi on 12/29/18.
//  Copyright © 2018 Rishabh Mudradi. All rights reserved.
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

//amish fix and test working on 1/5
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class EditCardViewController: UIViewController, UIScrollViewDelegate,UITextViewDelegate {
    override var prefersStatusBarHidden: Bool {
        return true
    }
    var dict:[AnyHashable: Any]!
    var index:Int!
    var cardIndex:Int!
    var scrollView:UIScrollView!
    var questionTextField:UITextField!
    var answerTextView:UITextView!
    var answerTextViewPlaceholder:UILabel!
    var createButton:UIButton!
    var canAnimateScroll:Bool! = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Edit Card"
        view.backgroundColor = UIColor.white
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(EditCardViewController.cancel))
        navigationItem.leftBarButtonItem?.tintColor = UIColor(red:0.30, green:0.18, blue:0.86, alpha:1.0)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "AvenirNext-Medium", size: 20)!]
        navigationController?.navigationBar.tintColor = UIColor(red:0.30, green:0.18, blue:0.86, alpha:1.0)
        scrollView = UIScrollView(frame: view.bounds)
        scrollView.alwaysBounceVertical = true
        scrollView.delegate = self
        scrollView.delaysContentTouches = false
        view.addSubview(scrollView)
        
        let cards = dict["cards"] as! [[String:String]]
        let card = cards[cardIndex]
        let question = card["question"] 
        let answer = card["answer"]
        
        questionTextField = UITextField(frame: CGRect(x: 16, y: 16, width: view.frame.width-16, height: 40))
        questionTextField.placeholder = "Question"
        questionTextField.font = UIFont(name:"AvenirNext-Bold", size:16)
        questionTextField.addTarget(self, action: #selector(EditCardViewController.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        questionTextField.text = question
        scrollView.addSubview(questionTextField)
        
        let line = UIView(frame: CGRect(x: 16, y: questionTextField.frame.maxY+4, width: view.frame.width-16, height: 1))
        line.backgroundColor = UIColor(white: 0.9, alpha: 1)
        scrollView.addSubview(line)
        
        answerTextView = UITextView(frame: CGRect(x: 12, y: line.frame.maxY+8, width: view.frame.width-24, height: 40))
        answerTextView.font = UIFont(name:"AvenirNext-Medium", size:16)
        answerTextView.delegate = self
        answerTextView.text = answer
        answerTextView.isScrollEnabled = false
        scrollView.addSubview(answerTextView)
        
        answerTextViewPlaceholder = UILabel(frame: CGRect(x: 16, y: line.frame.maxY+8, width: view.frame.width-32, height: 36))
        answerTextViewPlaceholder.text = "Answer"
        answerTextViewPlaceholder.textColor = UIColor(white: 0.8, alpha: 1)
        scrollView.addSubview(answerTextViewPlaceholder)
        
        createButton = UIButton(type: UIButton.ButtonType.system)
        createButton.frame = CGRect(x: 16, y: answerTextView.frame.maxY+8, width: view.frame.width-32, height: 40)
        createButton.setTitle("Save Card", for: UIControl.State())
        createButton.setTitleColor(UIColor(red:0.51, green:0.22, blue:1.00, alpha:1.0), for: .normal)
        createButton.titleLabel?.font =  UIFont(name: "AvenirNext-DemiBold", size: 20)
        createButton.addTarget(self, action: #selector(EditCardViewController.saveCard), for: UIControl.Event.touchUpInside)
        createButton.isEnabled = false
        scrollView.addSubview(createButton)
        
         textViewDidChange(answerTextView)
        
    }
    
    @objc func cancel() {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
        SCLAlertView().showNotice("Notice", subTitle: "You didn't edit anything in this card!" )

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
    
    @objc func saveCard() {
        
        createButton.isEnabled = false
        
        var cards = dict["cards"] as! [[String:String]]!
        let question = questionTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces)
        let answer = answerTextView.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

        var card = cards?[cardIndex]
        card?["question"] = question
        card?["answer"] = answer
        
        cards?[cardIndex] = card!
        
        dict["cards"] = cards
        
        var array = UserDefaults.standard.object(forKey: "flashcardArray") as! [AnyObject]
        array.remove(at: index)
        array.insert(dict as AnyObject, at: index)
        UserDefaults.standard.set(array, forKey: "flashcardArray")
        NotificationCenter.default.post(name: Notification.Name(rawValue: "refreshDeck"), object: nil)
        
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
        SCLAlertView().showSuccess("Card Saved!", subTitle: "Your card has now been edited." )

        
    }

}

func delay(_ delay:Double, closure:@escaping ()->()) {
    DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}
