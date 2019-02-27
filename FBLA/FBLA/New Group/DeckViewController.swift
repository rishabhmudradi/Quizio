//
//  DeckViewController.swift
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


fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class DeckViewController: UIViewController, UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate {
    
    var titleTextField:UITextField!
    var dict:[AnyHashable: Any]!
    var index:Int!
    var tableView:UITableView!
    var isDeleted:Bool! = false
    var editDeckButton:UIBarButtonItem!
    var toolbar:UIToolbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red:0.92, green:0.92, blue:0.92, alpha:1.0)
        title = "Deck"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Study", style: UIBarButtonItem.Style.plain, target: self, action: #selector(DeckViewController.studyDeck))
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "AvenirNext-Medium", size: 20)!]
        navigationController?.navigationBar.tintColor = UIColor(red:0.30, green:0.18, blue:0.86, alpha:1.0)

        
        NotificationCenter.default.addObserver(self, selector: #selector(DeckViewController.refreshDeck), name: NSNotification.Name(rawValue: "refreshDeck"), object: nil)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(DeckViewController.hideKeyboard))
        view.addGestureRecognizer(tap)
        
        titleTextField = UITextField(frame: CGRect(x: 16, y: 72, width: view.frame.width-16, height: 40))
        titleTextField.placeholder = "Title"
        titleTextField.text = dict["title"] as? String
        titleTextField.font = UIFont(name:"AvenirNext-Bold", size:16)
        
        view.addSubview(titleTextField)
        
        let line = UIView(frame: CGRect(x: 16, y: titleTextField.frame.maxY+4, width: view.frame.width-16, height: 1))
        line.backgroundColor = UIColor(white: 0.9, alpha: 1)
        view.addSubview(line)
        
        tableView = UITableView(frame: CGRect(x: 0, y: line.frame.maxY, width: view.frame.width, height: view.frame.height-(line.frame.maxY+8)-45))
        tableView.dataSource = self
        tableView.delegate = self
        tableView.delaysContentTouches = false
        for view in tableView.subviews { // rishabh test case 2
            if view.isKind(of: UIScrollView.self) {
                (view as! UIScrollView).delaysContentTouches = false
            }
        }
        view.addSubview(tableView)
        
        toolbar = UIToolbar(frame: CGRect(x: 0, y: view.frame.height-45, width: view.frame.width, height: 45))
        view.addSubview(toolbar)
        editDeckButton = UIBarButtonItem(title: "Edit Deck", style: UIBarButtonItem.Style.plain, target: self, action: #selector(DeckViewController.editDeck))
        editDeckButton.tintColor = UIColor(red:0.30, green:0.18, blue:0.86, alpha:1.0)

        let addCard = UIBarButtonItem(title: "Add Card", style: UIBarButtonItem.Style.plain, target: self, action: #selector(DeckViewController.addCard))
        addCard.tintColor = UIColor(red:0.30, green:0.18, blue:0.86, alpha:1.0)
        
        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolbar.setItems( [addCard,space,editDeckButton], animated: false)
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        if isDeleted == false {
            let title = titleTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces)
            if title?.characters.count > 0 {
                dict["title"] = title
            }else{
                dict["title"] = "Untitled"
            }
            
            saveDeck()
            
        }
    }
    
    func saveDeck() {
        var array = UserDefaults.standard.object(forKey: "flashcardArray") as! [AnyObject]
        array.remove(at: index)
        array.insert(dict as AnyObject, at: index)
        UserDefaults.standard.set(array, forKey: "flashcardArray")
        NotificationCenter.default.post(name: Notification.Name(rawValue: "refreshLibrary"), object: nil)
    }
    
    @objc func refreshDeck() {
        var array = UserDefaults.standard.object(forKey: "flashcardArray") as! [AnyObject]
        dict = array[index] as! [AnyHashable: Any]
        tableView.reloadData()
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
        saveDeck()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        hideKeyboard()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dict["cards"] != nil {
            let cards = dict["cards"] as! [[AnyHashable: Any]]
            return cards.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var spacing:CGFloat! = 32
        if tableView.isEditing == true {
            spacing = 120
        }
        if dict["cards"] != nil {
            let cards = dict["cards"] as! [[AnyHashable: Any]]
            let card = cards[indexPath.row]
            let question = (card["question"] as! String).heightWithConstrainedWidth(view.frame.width-spacing, font: UIFont(name:"AvenirNext-DemiBold", size:16)!)
            var answer = (card["answer"] as! String).heightWithConstrainedWidth(view.frame.width-spacing, font: UIFont(name:"AvenirNext-DemiBold", size:14)!)
            if answer > 100 {
                answer = 100
            }
            return 16 + question + 8 + answer + 16
        }
        return 40
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        cell.selectionStyle = .none
        
        if tableView.isEditing == true {
            let edit = UIButton(frame: CGRect(x: view.frame.width-30, y: 0, width: 30, height: cell.frame.height))
            edit.setImage(UIImage(named: "edit"), for: UIControl.State())
            edit.imageView?.contentMode = .scaleAspectFit
            edit.addTarget(self, action: #selector(DeckViewController.deleteCard(_:event:)), for: UIControl.Event.touchUpInside)
            cell.editingAccessoryView = edit
        }else{
            cell.editingAccessoryView = nil
        }
        
        var spacing:CGFloat! = 32
        if tableView.isEditing == true {
            spacing = 120
        }
        
        if dict["cards"] != nil {
            let cards = dict["cards"] as! [[AnyHashable: Any]]
            let card = cards[indexPath.row]
            let question = (card["question"] as! String).heightWithConstrainedWidth(view.frame.width-spacing, font: UIFont(name:"AvenirNext-DemiBold", size:16)!)
            var answer = (card["answer"] as! String).heightWithConstrainedWidth(view.frame.width-spacing, font: UIFont(name:"AvenirNext-DemiBold", size:14)!)
            if answer > 100 {
                answer = 100
            }
            
            var questionLabel = cell.contentView.viewWithTag(1) as? UILabel
            if questionLabel == nil {
                questionLabel = UILabel(frame: CGRect(x: 16, y: 16, width: view.frame.width-spacing, height: question))
                questionLabel!.font = UIFont(name:"AvenirNext-DemiBold", size:16)
                questionLabel!.numberOfLines = 0
                questionLabel!.tag = 1
                questionLabel?.textColor = UIColor(white: 0.15, alpha: 1)
                cell.contentView.addSubview(questionLabel!)
            }
            questionLabel!.text = card["question"] as? String
            
            var answerLabel = cell.contentView.viewWithTag(2) as? UILabel
            if answerLabel == nil {
                answerLabel = UILabel(frame: CGRect(x: 16, y: questionLabel!.frame.maxY+8, width: view.frame.width-spacing, height: answer))
                answerLabel!.font = UIFont(name:"AvenirNext-DemiBold", size:14)
                answerLabel!.numberOfLines = 0
                answerLabel!.tag = 2
                answerLabel?.textColor = UIColor(white: 0.5, alpha: 1)
                cell.contentView.addSubview(answerLabel!)
            }
            answerLabel!.text = card["answer"] as? String
            
        }
        return cell
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if self.dict["cards"] != nil {
            var cards = self.dict["cards"] as! [[AnyHashable: Any]]
            let card = cards[indexPath.row]
            
            let alert = UIAlertController(title: "Warning!", message: "Are you sure you want to delete \"\(card["question"]!)\"", preferredStyle: UIAlertController.Style.alert)
            let cancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
            alert.addAction(cancel)
            let delete = UIAlertAction(title: "Delete", style: UIAlertAction.Style.destructive) { (UIAlertAction) in
                cards.remove(at: indexPath.row)
                self.dict["cards"] = cards
                tableView.reloadSections(IndexSet(integer:0), with: UITableView.RowAnimation.automatic)
                self.saveDeck()
            }
            alert.addAction(delete);            present(alert, animated: true, completion: nil)
        }
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if dict["cards"] != nil {
            var cards = dict["cards"] as! [[AnyHashable: Any]]
            let card = cards[sourceIndexPath.row]
            cards.remove(at: sourceIndexPath.row)
            cards.insert(card, at: destinationIndexPath.row)
            dict["cards"] = cards
            saveDeck()
        }
    }
    
    @objc func addCard() {
        let vc = AddCardViewController()
        vc.dict = dict! as [NSObject : AnyObject]
        vc.index = index
        present(UINavigationController(rootViewController:vc), animated: true, completion: nil)
    }
    
    @objc func editDeck() {
        
        if tableView.isEditing == true {
            tableView.setEditing(false, animated: true)
            editDeckButton.title = "Edit Deck"
            
            let addCard = UIBarButtonItem(title: "Add Card", style: UIBarButtonItem.Style.plain, target: self, action: #selector(DeckViewController.addCard))
            
            addCard.tintColor = UIColor(red:0.30, green:0.18, blue:0.86, alpha:1.0)
            
            let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
            toolbar.setItems( [addCard,space,editDeckButton], animated: true)
        }else{
            tableView.setEditing(true, animated: true)
            editDeckButton.title = "Done Editing"
            
            let delete = UIBarButtonItem(title: "Delete Deck", style: UIBarButtonItem.Style.plain, target: self, action: #selector(DeckViewController.deleteDeck))
            delete.tintColor = UIColor(red:0.30, green:0.18, blue:0.86, alpha:1.0)

            editDeckButton.tintColor = UIColor(red:0.30, green:0.18, blue:0.86, alpha:1.0)
            

            let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
            toolbar.setItems( [delete,space,editDeckButton], animated: true)
        }
        tableView.reloadSections(IndexSet(integer:0), with: UITableView.RowAnimation.automatic)
    }
    
    @objc func deleteCard(_ sender:UIButton, event:UIEvent) {
        
        let touch = event.touches(for: sender)?.first
        let row = tableView.indexPathForRow(at: (touch?.previousLocation(in: tableView))!)!.row
        
        var cards = dict["cards"] as! [[String:String]]
        let card = cards[row]
        
        let alert = UIAlertController(title: "Edit", message: "\"\(card["question"]!)\"", preferredStyle: UIAlertController.Style.actionSheet)
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(cancel)
        let edit = UIAlertAction(title: "Edit", style: UIAlertAction.Style.default) { (UIAlertAction) in
            let vc = EditCardViewController()
            vc.dict = self.dict! as [NSObject : AnyObject]
            vc.index = self.index
            vc.cardIndex = row
            self.present(UINavigationController(rootViewController:vc), animated: true, completion: nil)
        }
        alert.addAction(edit)
        let delete = UIAlertAction(title: "Delete", style: UIAlertAction.Style.destructive)
        { (UIAlertAction) in
            cards.remove(at: row)
            self.dict["cards"] = cards
            self.saveDeck()
            self.tableView.reloadSections(IndexSet(integer:0), with: UITableView.RowAnimation.automatic)
            SCLAlertView().showWarning("Card Deleted!")

        }
        alert.addAction(delete)
        present(alert, animated: true, completion: nil)

    }
    
    @objc func deleteDeck() {
        let alert = UIAlertController(title: "Delete this flash card deck?", message: "Are you sure you want to delete this flash card deck? You can't access it again.", preferredStyle: UIAlertController.Style.alert)
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(cancel)
        let delete = UIAlertAction(title: "Delete", style: UIAlertAction.Style.destructive) { (UIAlertAction) in
            self.isDeleted = true
            var array = UserDefaults.standard.object(forKey: "flashcardArray") as! [AnyObject]
            array.remove(at: self.index)
            UserDefaults.standard.set(array, forKey: "flashcardArray")
            NotificationCenter.default.post(name: Notification.Name(rawValue: "refreshLibrary"), object: nil)
            self.navigationController?.popViewController(animated: true)
            SCLAlertView().showWarning("This deck has been deleted!")

        }
        alert.addAction(delete)
        present(alert, animated: true, completion: nil)
    }
    
    @objc func studyDeck() {
        let vc = StudyViewController()
        vc.dict = dict! as [NSObject : AnyObject]
        present(UINavigationController(rootViewController:vc), animated: true, completion: nil)
    }
    
}

extension String {
    func heightWithConstrainedWidth(_ width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return boundingBox.height
    }
}
