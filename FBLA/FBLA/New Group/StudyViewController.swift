//
//  StudyViewController.swift
//  FBLA
//
//  Created by Rishabh Mudradi on 12/29/18.
//  Copyright © 2018 Rishabh Mudradi. All rights reserved.
//

import UIKit

class StudyViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate {
    
    //class is written for studying along with flashcards
    var collectionView:UICollectionView!
    var dict:[AnyHashable: Any]!
    var originalDict:[AnyHashable: Any]!
    var currentCardIndex:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Study"
        view.backgroundColor = UIColor.white
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(StudyViewController.cancel))
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "AvenirNext-Medium", size: 20)!]
        navigationController?.navigationBar.tintColor = UIColor(red:0.30, green:0.18, blue:0.86, alpha:1.0)
        if dict["cards"] != nil && (dict["cards"]  as! [[String:String]]).count > 0 {
            
            setupData()
            
            let flow = UICollectionViewFlowLayout()
            flow.itemSize = CGSize(width: view.frame.width, height: view.frame.height-(navigationController?.navigationBar.frame.height)!-64)
            flow.scrollDirection = .horizontal
            flow.minimumLineSpacing = 0
            flow.minimumInteritemSpacing = 0
            collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: flow)
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
            collectionView.backgroundColor = UIColor.white
            collectionView.isPagingEnabled = true
            collectionView.alwaysBounceHorizontal = true
            collectionView.showsHorizontalScrollIndicator = false
            view.addSubview(collectionView)
            collectionView.scrollToItem(at: IndexPath(row:1, section: 0), at: UICollectionView.ScrollPosition.centeredHorizontally, animated: false)
            
            if UserDefaults.standard.integer(forKey: "shuffleHint")  <= 5 {
                let shake = UILabel(frame: CGRect(x: 16, y: ((navigationController?.navigationBar.frame.height)!+32), width: view.frame.width-32, height: 16))
                shake.text = "Shake your device to shuffle the flashcards!"
                shake.textColor = UIColor(red:0.52, green:0.52, blue:0.52, alpha:1.0)
                shake.textAlignment = .center
                view.addSubview(shake)
                UIView.animate(withDuration: 1, delay: 20, options: UIView.AnimationOptions(), animations: {
                    shake.alpha = 0
                    }, completion: { (done) in
                        if done {
                            UserDefaults.standard.set(UserDefaults.standard.integer(forKey: "shuffleHint")+1, forKey: "shuffleHint")
                        }
                })
            }
            
            currentCardIndex = UILabel(frame: CGRect(x: 16, y: view.frame.height-24, width: view.frame.width-32, height: 16))
            currentCardIndex.textAlignment = .center
            let cards = dict["cards"] as! [[String:String]]
            currentCardIndex.text = "1 out of \(cards.count-2)"
            currentCardIndex.textColor = UIColor.lightGray
            view.addSubview(currentCardIndex)
            
        }else{
            
            let question = UILabel(frame: CGRect(x: 16, y: 16, width: view.frame.width-32, height: view.frame.height-32))
            question.textColor = UIColor(white: 0.5, alpha: 1)
            question.numberOfLines = 0
            question.textAlignment = .center
            question.font = UIFont(name: (question.font?.fontName)!, size: 25)
            question.tag = 2
            question.text = "You haven't added any cards to this deck."
            view.addSubview(question)
            
        }
        
    }
    
    @objc func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    func setupData() {
        originalDict = dict
        var cards = dict["cards"] as! [[String:String]]
        cards.append(cards.first!)
        cards.insert(cards[cards.count-2], at: 0)
        dict["cards"] = cards
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (dict["cards"] as! [[AnyHashable: Any]]).count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.contentView.backgroundColor = UIColor.white
        
        let cards = dict["cards"] as! [[String:String]]
        let card = cards[indexPath.row]
        
        var background = cell.contentView.viewWithTag(1)
        if background == nil {
            background = UIView(frame: cell.contentView.frame.insetBy(dx: 16, dy: 16))
            background!.tag = 1
            background!.backgroundColor = UIColor(red:0.75, green:0.50, blue:1.00, alpha:1.0)
            background?.layer.cornerRadius = 20
            cell.contentView.addSubview(background!)
        }
        
        var question = background!.viewWithTag(2) as? UILabel
        if question == nil {
            question = UILabel(frame: CGRect(x: 16, y: 16, width: background!.frame.width-32, height: background!.frame.height-32))
            question!.textColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.0)
            question!.numberOfLines = 0
            question!.textAlignment = .center
            question!.font = UIFont(name: (question?.font?.fontName)!, size: 25)
            question!.tag = 2
            question!.alpha = 1
            background?.addSubview(question!)
        }
        question?.alpha = 1
        question?.text = card["question"]
        
        var answer = background!.viewWithTag(3) as? UITextView
        if answer == nil {
            answer = UITextView(frame: CGRect(x: 32, y: 32, width: background!.frame.width-64, height: background!.frame.height-64))
            answer!.textColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.0)
            answer!.textAlignment = .center
            answer!.font = UIFont(name: "AvenirNext-DemiBold", size: 25)
            answer!.tag = 3
            answer!.isEditable = false
            answer!.backgroundColor = UIColor(red:0.75, green:0.50, blue:1.00, alpha:1.0)
            answer!.isSelectable = false
            answer!.alpha = 0
            answer!.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(StudyViewController.didTapTextView(_:))))
            background?.addSubview(answer!)
        }
        answer?.alpha = 0
        answer?.text = card["answer"]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        flipCell(indexPath)
    }
    
    @objc func didTapTextView(_ tap:UITapGestureRecognizer) {
        
        flipCell(collectionView.indexPathForItem(at: tap.location(in: collectionView))!)
        
        
    }
    
    func flipCell(_ indexPath:IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        let background = cell?.contentView.viewWithTag(1)
        let question = background?.viewWithTag(2) as! UILabel
        let answer = background?.viewWithTag(3) as! UITextView
        if question.alpha == 1 {
            question.alpha = 0
            answer.alpha = 1
        }else{
            question.alpha = 1
            answer.alpha = 0
        }
        UIView.transition(with: background!, duration: 0.3, options: [.allowUserInteraction, .transitionFlipFromTop] , animations: {
            
            }, completion: nil)
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let cards = dict!["cards"] as! [[String:String]]
        
        let contentOffsetWhenFullyScrolledRight = self.collectionView.frame.size.width*(CGFloat)(cards.count-1)
        
        if (scrollView.contentOffset.x == contentOffsetWhenFullyScrolledRight) {
            //wait rishabh is this if the user is scrolling cause u can storyboard this
            
            let newIndexPath = IndexPath(item: 1, section: 0)
            
            self.collectionView.scrollToItem(at: newIndexPath, at: UICollectionView.ScrollPosition.left, animated: false)
            
        } else if (scrollView.contentOffset.x == 0)  {
            
            //rishabh check this
            
            let newIndexPath = IndexPath(item: cards.count-2, section: 0)
            
            self.collectionView.scrollToItem(at: newIndexPath, at: UICollectionView.ScrollPosition.left, animated: false)
            
        }
        
        if collectionView.visibleCells.count > 0 {
            var index = collectionView.indexPath(for: collectionView.visibleCells.first!)?.item
            if index == 0 {
                index = cards.count-2
            }else if index == cards.count-1 {
                index = 1
            }
            currentCardIndex.font = UIFont(name:"AvenirNext-Heavy", size: 20.0)

            currentCardIndex.text = "\(index!) out of \(cards.count-2)"
        }
        
    }

    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            var cards = originalDict["cards"] as! [[String:String]]
            cards.shuffleInPlace()
            dict["cards"] = cards
            setupData()
            collectionView.reloadData()
        }
    }
    
}

extension Collection {
    func shuffle() -> [Iterator.Element] {
        var list = Array(self)
        list.shuffleInPlace()
        return list
        //just return a list rishabh
    }
}

//stack overflow said that MutableCollection should work so its fine
extension MutableCollection where Index == Int {
    mutating func shuffleInPlace() {
        if count < 2 { return }
        
        for i in startIndex ..< endIndex - 1 {
            let j = Int(arc4random_uniform(UInt32(endIndex - i))) + i
            if i != j {
                self.swapAt(i, j)
            }
        }
    }
}

