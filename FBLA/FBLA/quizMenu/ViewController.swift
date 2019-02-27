//
//  ViewController.swift
//  FBLA
//
//  Created by Rishabh Mudradi on 12/24/18.
//  Copyright © 2018 Rishabh Mudradi. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    fileprivate var items = [Character]()
    
    fileprivate var currentPage: Int = 0 {
        didSet {
            let character = self.items[self.currentPage]
            self.infoLabel.text = character.name.uppercased()
            self.detailLabel.text = character.type.uppercased()
        }
    }
    
    fileprivate var pageSize: CGSize {
        let layout = self.collectionView.collectionViewLayout as! UPCarouselFlowLayout
        var pageSize = layout.itemSize
        if layout.scrollDirection == .horizontal {
            pageSize.width += layout.minimumLineSpacing
        } else {
            pageSize.height += layout.minimumLineSpacing
        }
        return pageSize
    }
    
    fileprivate var orientation: UIDeviceOrientation {
        return UIDevice.current.orientation
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupLayout()
        self.items = self.createItems()
        
        self.currentPage = 0
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.rotationDidChange), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    
    @IBAction func notice(_ sender: Any) {
        let alert  = SCLAlertView().showNotice("Need Help?", subTitle: "Click the quiz card to get a detailed explanation before you click start!")

    }
    
    
    fileprivate func setupLayout() {
        let layout = self.collectionView.collectionViewLayout as! UPCarouselFlowLayout
        layout.spacingMode = UPCarouselFlowLayoutSpacingMode.overlap(visibleOffset: 30)
    }
    
    fileprivate func createItems() -> [Character] {
        let characters = [
            Character(imageName: "natOff", name: "Quiz yourself on knowledge regarding your FBLA national officers!", type: "comp1"),
            Character(imageName: "busSK", name: "Looking for a quick refresher on business ethics? Take this quick true and false quiz to brush up!", type: "comp2"),
            Character(imageName: "compEv", name: "FBLA offers a wide range of competitive events, take this quiz to browse through events and gather more information on them!", type: "comp3"),
            Character(imageName: "natSp", name: "Use our true and false quiz to learn about all of the sponsors who are helping FBLA function with ease!", type: "comp5"),
            Character(imageName: "ncI", name: "Not a punctual person? Disorganized? This quiz is perfect for you, as it tests you on the dates and locations of national confrences!", type: "comp6"),
            
            Character(imageName: "fcards", name: "It's your turn to create your own study materials! Use our flashcard feature to study definitions and terms for your competition!", type: "comp7")
        ]
        return characters
    }
    @IBAction func didPressStart(_ sender: Any) {
        if(detailLabel.text == "COMP2"){
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "skill") as! SkillsViewController
            self.present(vc, animated: true, completion: nil)
            
        }else if(detailLabel.text == "COMP7"){
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "flash")
            self.present(vc!, animated: true, completion: nil)
            
        }else if(detailLabel.text == "COMP1"){
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "officer")
            self.present(vc!, animated: true, completion: nil)
        }else if(detailLabel.text == "COMP6"){
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "nat")
            self.present(vc!, animated: true, completion: nil)
            
        }else if(detailLabel.text == "COMP3"){
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "comp")
            self.present(vc!, animated: true, completion: nil)
            
        }else if(detailLabel.text == "COMP5"){
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "spons")
            self.present(vc!, animated: true, completion: nil)
            
        }
        
        
    }
    
    
    @objc fileprivate func rotationDidChange() {
        guard !orientation.isFlat else { return }
        let layout = self.collectionView.collectionViewLayout as! UPCarouselFlowLayout
        let direction: UICollectionView.ScrollDirection = orientation.isPortrait ? .horizontal : .vertical
        layout.scrollDirection = direction
        if currentPage > 0 {
            let indexPath = IndexPath(item: currentPage, section: 0)
            let scrollPosition: UICollectionView.ScrollPosition = orientation.isPortrait ? .centeredHorizontally : .centeredVertically
            self.collectionView.scrollToItem(at: indexPath, at: scrollPosition, animated: false)
        }
    }
    
    // MARK: - Card Collection Delegate & DataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarouselCollectionViewCell.identifier, for: indexPath) as! CarouselCollectionViewCell
        let character = items[(indexPath as NSIndexPath).row]
        cell.image.image = UIImage(named: character.imageName)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let character = items[(indexPath as NSIndexPath).row]
        _ = SCLAlertView().showInfo("Quiz Info", subTitle: character.name)
        
    }
    
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let layout = self.collectionView.collectionViewLayout as! UPCarouselFlowLayout
        let pageSide = (layout.scrollDirection == .horizontal) ? self.pageSize.width : self.pageSize.height
        let offset = (layout.scrollDirection == .horizontal) ? scrollView.contentOffset.x : scrollView.contentOffset.y
        currentPage = Int(floor((offset - pageSide / 2) / pageSide) + 1)
    }
    
}
