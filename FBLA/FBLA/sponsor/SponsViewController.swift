//
//  SponsViewController.swift
//  FBLA
//
//  Created by Aryan Kaul on 2/07/19.
//  Copyright © 2019 Aryan Kaul. All rights reserved.
//

import UIKit
import GameKit
import Social
class SponsViewController: UIViewController {
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    let questionsPerRound = 20
    var questionsAsked = 0
    var correctQuestions = 0
    var indexOfSelectedQuestion: Int = 0
    
    private var titleValueArray: NSArray!
    private var subTitleArray: NSArray!
    private var questionsValueArray: NSArray!
    private var isTrueValueArray: NSArray!



    
    
    @IBOutlet weak var questionField: UILabel!
    @IBOutlet weak var trueButton: UIButton!
    @IBOutlet weak var falseButton: UIButton!
    @IBOutlet weak var playAgainButton: UIButton!
    
   

    var trivia: [[String : String]] = [

    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        var nsDictionary: NSDictionary!
        if let path = Bundle.main.path(forResource: "Questions", ofType: "plist") {
            nsDictionary = NSDictionary(contentsOfFile: path)
        }
        if let array = nsDictionary[0] as? [String] {
            print(array[0])
        }*/
        let dicRoot = NSDictionary.init(contentsOfFile: Bundle.main.path(forResource: "Questions", ofType: "plist")!)
        let nextDict = dicRoot?.object(forKey: "SponsorQuestions")
        let titleArrayFromDic: NSArray = NSArray.init(object: (nextDict as! NSDictionary).object(forKey: "Questions") as Any)
        titleValueArray = titleArrayFromDic.object(at: 0) as! NSArray
        
        let subTitleArrayFromDic: NSArray = NSArray.init(object:(nextDict as! NSDictionary).object(forKey: "IsTrue") as Any)
        subTitleArray = subTitleArrayFromDic.object(at: 0) as! NSArray
        for count in 0..<titleValueArray.count {
            trivia.append(["Question" : titleValueArray![count] as! String, "Answer": BoolToString(b: subTitleArray![count] as! Bool)])
            
        }
        
        displayQuestion()
    }
    func BoolToString(b: Bool?)->String { return b?.description ?? "<None>"}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    var prevIndex = 0
    func displayQuestion() {
        indexOfSelectedQuestion = GKRandomSource.sharedRandom().nextInt(upperBound: trivia.count)
        while(indexOfSelectedQuestion == prevIndex){
            indexOfSelectedQuestion = GKRandomSource.sharedRandom().nextInt(upperBound: trivia.count)
        }
        prevIndex = indexOfSelectedQuestion
        let questionDictionary = trivia[indexOfSelectedQuestion]
        questionField.text = questionDictionary["Question"]
        playAgainButton.isHidden = true
    }
    
    func displayScore() {
        trueButton.isHidden = true
        falseButton.isHidden = true
        playAgainButton.isHidden = false
        
        let alert = SCLAlertView()
        alert.addButton("Share on Twitter!") {
            if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter)
            {
                let post = SLComposeViewController(forServiceType: SLServiceTypeTwitter)!
                
                post.setInitialText("My score on Quizio was \(self.correctQuestions) out of \(self.questionsPerRound)!")
                self.present(post, animated: true, completion: nil)
                
            } else {self.showAlert(service: "Twitter")}
        }
        
        alert.addButton("Share on Facebook!") {
            if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter)
            {
                let post = SLComposeViewController(forServiceType: SLServiceTypeTwitter)!
                
                post.setInitialText("My score on Quizio was \(self.correctQuestions) out of \(self.questionsPerRound)!")
                self.present(post, animated: true, completion: nil)
                
            } else {self.showAlert(service: "Facebook")}
        }
        
        alert.showSuccess("Great Job!", subTitle: "You got \(correctQuestions) out of \(questionsPerRound) correct!")
        
        
    }
    func showAlert(service:String)
    {
        SCLAlertView().showError("Error", subTitle:"You are not connected to \(service)" )
    }
    
    
    @IBAction func checkAnswer(_ sender: UIButton) {
        questionsAsked += 1
        
        let selectedQuestionDict = trivia[indexOfSelectedQuestion]
        let correctAnswer = selectedQuestionDict["Answer"]
        
        if (sender === trueButton &&  correctAnswer == "true") || (sender === falseButton && correctAnswer == "false") {
            correctQuestions += 1
            questionField.text = "Correct!"
        } else {
            questionField.text = "Uh Oh, Incorrect!"
        }
        
        loadNextRoundWithDelay(seconds: 1)
    }
    
    func nextRound() {
        if questionsAsked == questionsPerRound {
            displayScore()
        } else {
            // rishabh test 1
            displayQuestion()
        }
    }
    
    @IBAction func playAgain() {
        // rishabh test 2
        trueButton.isHidden = false
        falseButton.isHidden = false
        
        questionsAsked = 0
        correctQuestions = 0
        nextRound()
    }
    
    
    
    func loadNextRoundWithDelay(seconds: Int) {
        let delay = Int64(NSEC_PER_SEC * UInt64(seconds))
        let dispatchTime = DispatchTime.now() + Double(delay) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
            self.nextRound()
        }
    }
    
}


