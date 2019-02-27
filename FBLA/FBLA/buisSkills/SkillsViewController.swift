//
//  SkillsViewController.swift
//  FBLA
//
//  Created by Rishabh Mudradi on 1/13/19.
//  Copyright © 2019 Rishabh Mudradi. All rights reserved.
//

import UIKit
import GameKit
import Social
class SkillsViewController: UIViewController {
    override var prefersStatusBarHidden: Bool {
        return true
    }
        let questionsPerRound = 20
        var questionsAsked = 0
        var correctQuestions = 0
        var indexOfSelectedQuestion: Int = 0
        
    
        let trivia: [[String : String]] = [
            ["Question": "For employees who like their current work, moving into management means they can no longer do that work. ", "Answer": "True"],
            ["Question": "There are a number of activities that must be performed by all managers no matter what type or size of the company.", "Answer": "True"],
            ["Question": "Leaders can be effective without good human relation skills.", "Answer": "False"],
            ["Question": "The top managers in a business are involved in planning, but first-level managers such as a supervisors are not.", "Answer": "False"],
            ["Question": "Implementing involves carrying out plans and helping employees to work effectively.", "Answer": "True"],
            ["Question": "To implement successfully, managers must complete activities designed to channel employee efforts in the right direction to achieve the goals.", "Answer": "True"],
            ["Question": "A business plan helps entrepreneurs see the risk and responsibilities involved in starting a business.", "Answer": "True"],
            ["Question": "A business with a balance sheet showing assets valued at $100,000 and capital valued at $100,000 is in a weak financial position.", "Answer": "True"],
            ["Question": "Form utility usually applies to only services and not to goods.", "Answer": "False"],
            ["Question": "A business advances its own interests when it becomes involved socially.", "Answer": "True"],
            ["Question": "A business changing from coal to natural gas violates environmental goals but meets conservative ones.", "Answer": "False"],
            ["Question": "A system that provides the ability to analyze 'what if' scenarios is an executive information system.", "Answer": "False"],
            ["Question": "Installment credit customers are usually required to pay an interest charge for the privilege of making monthly payments that may run for several years or more.", "Answer": "True"],
            ["Question": "Business people and consumers have identical perceptions of a product.", "Answer": "False"],
            ["Question": "Economic utility is one of the four types of utility that satisfy wants.", "Answer": "True"]
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
                if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter){
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
    //if user is not connected to fb or twitter
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


