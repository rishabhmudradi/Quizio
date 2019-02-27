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
    
    
    let trivia: [[String : String]] = [
        ["Question": " Arizona State is a sponsor for FBLA on a national level", "Answer": "True"],
        ["Question": " Walmart is a sponsor for FBLA on a national level", "Answer": "True"],
        ["Question": " Stanford is a sponsor for FBLA on a national level", "Answer": "False"],
        ["Question": " Instagram is a sponsor for FBLA on a national level", "Answer": "False"],
        ["Question": " Brave Software is a sponsor for FBLA on a national level", "Answer": "True"],
        ["Question": " Cengage is a sponsor for FBLA on a national level", "Answer": "True"],
        ["Question": " Test Out is a sponsor for FBLA on a national level", "Answer": "True"],
        ["Question": " Tesla is a sponsor for FBLA on a national level", "Answer": "False"],
        ["Question": " PDC Productions is a sponsor for FBLA on a national level", "Answer": "True"],
        ["Question": " Google is a sponsor for FBLA on a national level", "Answer": "False"],
        ["Question": " Reach and Teach is a sponsor for FBLA on a national level", "Answer": "True"],
        ["Question": " FutureHack is a sponsor for FBLA on a national level", "Answer": "False"],
        ["Question": " Verizon is a sponsor for FBLA on a national level", "Answer": "True"],
        ["Question": " Alamo is a sponsor for FBLA on a national level", "Answer": "True"],
        ["Question": " is a sponsor for FBLA on a national level", "Answer": "True"],
        ["Question": " My Path is a sponsor for FBLA on a national level", "Answer": "True"],
        ["Question": " Pitsco is a sponsor for FBLA on a national level", "Answer": "True"],
        ["Question": " Stock Market Game is a sponsor for FBLA on a national level", "Answer": "True"],
        ["Question": " At&t is a sponsor for FBLA on a national level", "Answer": "False"],
        ["Question": " Facebook is a sponsor for FBLA on a national level", "Answer": "False"],
        ["Question": " Alamo is a sponsor for FBLA on a national level", "Answer": "True"],
        ["Question": " Visa is a sponsor for FBLA on a national level", "Answer": "True"],
        ["Question": " Wells Fargo is a sponsor for FBLA on a national level", "Answer": "False"],
        ["Question": " Snapchat is a sponsor for FBLA on a national level", "Answer": "False"],
        ["Question": " Amazon is a sponsor for FBLA on a national level", "Answer": "True"],
        ["Question": " :The Drip Drop is a sponsor for FBLA on a national level", "Answer": "False"]

        
        
        
        
    ]
    
    @IBOutlet weak var questionField: UILabel!
    @IBOutlet weak var trueButton: UIButton!
    @IBOutlet weak var falseButton: UIButton!
    @IBOutlet weak var playAgainButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayQuestion()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func displayQuestion() {
        indexOfSelectedQuestion = GKRandomSource.sharedRandom().nextInt(upperBound: trivia.count)
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
        
        if (sender === trueButton &&  correctAnswer == "True") || (sender === falseButton && correctAnswer == "False") {
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


