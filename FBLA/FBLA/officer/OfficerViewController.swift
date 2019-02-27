//
//  OfficerViewController.swift
//  FBLA
//
//  Created by Rishabh Mudradi on 1/12/19.
//  Copyright © 2019 Rishabh Mudradi. All rights reserved.
//

import UIKit
import GameKit
import Social
class OfficerViewController: UIViewController {
    override var prefersStatusBarHidden: Bool {
        return true
    }
    @IBOutlet weak var questionField: UILabel!
    @IBOutlet weak var feedbackField: UILabel!
    @IBOutlet weak var firstChoiceButton: UIButton!
    @IBOutlet weak var secondChoiceButton: UIButton!
    @IBOutlet weak var thirdChoiceButton: UIButton!
    @IBOutlet weak var fourthChoiceButton: UIButton!
    @IBOutlet weak var nextQuestionButton: UIButton!
    @IBOutlet weak var answerImage: UIImageView!
    
    var questions = QuestionModel()
    let score = ScoreModel()
    
    let numberOfQuestionPerRound = 5
    var currentQuestion: Question? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        displayQuestion()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func isGameOver() -> Bool {
        return score.getQuestionsAsked() >= numberOfQuestionPerRound
    }
    
    func displayQuestion() {
        currentQuestion = questions.getRandomQuestion()
        
        if let question = currentQuestion {
            let choices = question.getChoices()
            
            questionField.text = question.getInterrogative()
            firstChoiceButton.setTitle(choices[0], for: .normal)
            secondChoiceButton.setTitle(choices[1], for: .normal)
            thirdChoiceButton.setTitle(choices[2], for: .normal)
            fourthChoiceButton.setTitle(choices[3], for: .normal)
            
            if (score.getQuestionsAsked() == numberOfQuestionPerRound - 1) {
                nextQuestionButton.setTitle("END QUIZ", for: .normal)
            } else {
                nextQuestionButton.setTitle("NEXT QUESTION", for: .normal)
            }
        }
        
        firstChoiceButton.isEnabled = true
        secondChoiceButton.isEnabled = true
        thirdChoiceButton.isEnabled = true
        fourthChoiceButton.isEnabled = true
        
        firstChoiceButton.isHidden = false
        secondChoiceButton.isHidden = false
        thirdChoiceButton.isHidden = false
        fourthChoiceButton.isHidden = false
        feedbackField.isHidden = true
        answerImage.isHidden = true
        nextQuestionButton.isEnabled = false
    }
    
    @IBAction func checkAnswer(_ sender: UIButton) {
        if let question = currentQuestion, let answer = sender.titleLabel?.text {
            
            if (question.validateAnswer(to: answer)) {
                score.incrementCorrectAnswers()
                answerImage.image  = UIImage(named: "right")
                //feedbackField.textColor = UIColor(red:0.15, green:0.61, blue:0.61, alpha:1.0)
                //feedbackField.text = "Correct!"
            } else {
                score.incrementIncorrectAnswers()
                feedbackField.textColor = UIColor(red:0.82, green:0.40, blue:0.26, alpha:1.0)
                answerImage.image  = UIImage(named: "wrong")
               // feedbackField.text = "Sorry, that's not it."
            }
            firstChoiceButton.isEnabled = false
            secondChoiceButton.isEnabled = false
            thirdChoiceButton.isEnabled = false
            fourthChoiceButton.isEnabled = false
            nextQuestionButton.isEnabled = true
            
            feedbackField.isHidden = false
            answerImage.isHidden = false
        }
    }
    
    @IBAction func nextQuestionTapped(_ sender: Any) {
        if (isGameOver()) {
            displayScore()
        } else {
            displayQuestion()
        }
    }
    func showAlert(service:String)
    {
        SCLAlertView().showError("Error", subTitle:"You are not connected to \(service)" )
    }
    func displayScore() {
        questionField.text = score.getScore()
        score.reset()
        nextQuestionButton.setTitle("PLAY AGAIN", for: .normal)
        
        feedbackField.isHidden = true
        answerImage.isHidden = true
        firstChoiceButton.isHidden = true
        secondChoiceButton.isHidden = true
        thirdChoiceButton.isHidden = true
        fourthChoiceButton.isHidden = true
        
        let alert = SCLAlertView()
        alert.addButton("Share your score on Twitter!") {
            if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter){
                let post = SLComposeViewController(forServiceType: SLServiceTypeTwitter)!
                post.setInitialText("My score on Quizio was \(self.score.getScore())!")
                self.present(post, animated: true, completion: nil)
                
            } else {self.showAlert(service: "Twitter")}
        }
        
        alert.addButton("Share your score on Facebook!") {
            if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter){
                let post = SLComposeViewController(forServiceType: SLServiceTypeTwitter)!
    
                post.setInitialText("My score on Quizio was \(self.score.getScore())!")
                self.present(post, animated: true, completion: nil)
                
            } else {self.showAlert(service: "Facebook")}
        }
        alert.showSuccess("Great Job!")

        
    }
    
    
    
}
