//
//  NatViewController
//  FBLA
//
//  Created by Amish Gupta on 2/04/19.
//  Copyright © 2019 Amish Gupta. All rights reserved.
//

import UIKit
import GameKit
import Social
class NatViewController: UIViewController {

    override var prefersStatusBarHidden: Bool {
        return true
    }
    let questionsPerRound = 20
    var questionsAsked = 0
    var correctQuestions = 0
    var indexOfSelectedQuestion: Int = 0
    
    
    let trivia: [[String : String]] = [
        ["Question": "The national conference 2019 is being held at New York ", "Answer": "False"],
        ["Question": "The early bird registration rate ends on May 17th for  NLC", "Answer": "True"],
        ["Question": "The national conference 2020 is being held at Anaheim ", "Answer": "False"],
        ["Question": "The regular registration deadline for NLC is June 10 ", "Answer": "True"],
        ["Question": "The National Leadership Conference starts on June 22", "Answer": "False"],
        ["Question": "The National Leadership Conference starts on June 12", "Answer": "False"],
        ["Question": "The National Leadership Conference starts on June 29", "Answer": "True"],
        ["Question": "It is possible to register on site for the National Leadership Conference", "Answer": "True"],
        ["Question": "The National Leadership Conference takes place on June 22", "Answer": "False"],
        ["Question": "One of the 2019 National Fall Leadership conferences is taking place at Boston, Massachusetts", "Answer": "False"],
        ["Question": "One of the 2019 National Fall Leadership conferences is taking place at Denver, Colorado", "Answer": "True"],
        ["Question": "One of the 2019 National Fall Leadership conferences is taking place at Washington DC, Massachusetts", "Answer": "True"],
        ["Question": "One of the 2019 National Fall Leadership conferences is taking place at Cupertino, California", "Answer": "False"],
        ["Question": "One of the 2019 National Fall Leadership conferences is taking place at Salt Lake City, Utah", "Answer": "False"],
        ["Question": "One of the 2019 National Fall Leadership conferences is taking place at Miami, Florida", "Answer": "False"],
        ["Question": "One of the 2019 National Fall Leadership conferences is taking place at Birmingham, Alabama", "Answer": "True"],
        ["Question": "The 2019 NFLC at Birmingham, Alabama is taking place from November 9 to 10", "Answer": "False"],
        ["Question": "The 2019 NFLC at Birmingham, Alabama is taking place from November 8 to 9", "Answer": "True"],
        ["Question": "The 2019 NFLC at Denver, Colorado is taking place from November 10 to 11", "Answer": "False"],
        ["Question": "The 2019 NFLC at Denver, Colorado is taking place from November 15 to 16", "Answer": "True"],
        ["Question": "The 2019 NFLC at Washington DC is taking place from November 1 to 4", "Answer": "False"],
        ["Question": "The 2019 NFLC at Washington DC is taking place from November 21 to 22", "Answer": "False"],
        ["Question": "The 2019 NFLC at Washington DC is taking place from November 1 to 2", "Answer": "True"],
        ["Question": "The 2019 NFLC Dates for all 3 cities are all at least 1 day long", "Answer": "True"],
        ["Question": "The 2019 NFLC Dates for all 3 cities all take place within 1 week of each other", "Answer": "True"]
        
        
        

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


