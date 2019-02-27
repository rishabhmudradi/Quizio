//
//  QuestionModel2.swift
//  FBLA
//
//  Created by Rishabh Mudradi on 1/12/19.
//  Copyright © 2019 Rishabh Mudradi. All rights reserved.
//
import GameKit

struct QuestionModel2 {
    
    let questions = [
        Question2(interrogative: "Which FBLA Competitive event requires members who demonstrate the knowledge and skills needed to establish and manage a business.", answers: ["Entrepreneurship", "Future Business Leader", "Economics", "Sports and entertainment management"], correctAnswerIndex: 0),
            
            Question2(interrogative: "Which FBLA Competitive event requires members who demonstrate the knowledge and skills needed to establish and manage a business.", answers: ["Entrepreneurship", "Future Business Leader", "Economics", "Sports and entertainment management"], correctAnswerIndex: 0),
            Question2(interrogative: "This type of network topology involves a central hub and a spider-like layout", answers: ["bus", "ring", "star", "mesh"], correctAnswerIndex: 2),
            
            Question2(interrogative: "A USB host adapter can support up to ___ devices", answers: ["8", "64", "127", "255"], correctAnswerIndex: 2),
            
            Question2(interrogative: " A(n) ______ is used in pre-486DX CPU’s to perform floating point math operations for the CPU.", answers: ["a math coprocessor", "ALU", "calculator", "CP"], correctAnswerIndex: 0),
            
            Question2(interrogative: " A________is a plastic or metal component that separates the system board from the case and holds the system board in place.", answers: ["footer", "locknut", "standoff", "faceplate"], correctAnswerIndex: 3),
            
            
            Question2(interrogative: "An infrared port connects devices to notebooks without ______.", answers: ["configuring", "IRQs", "cabling", "I/O addresses"], correctAnswerIndex: 2),
            
            Question2(interrogative: "During the laser printer’s conditioning phase a uniform charge of _______ is placed on the photosensitive drum", answers: ["+1000v", "+600v", "-600v", "-1000v"], correctAnswerIndex: 2),
            
            
            Question2(interrogative: "If the LED light does not work after installing a new hard drive, what is the most likely solution", answers: ["Remove the drive and reinstall", "Reverse the LED wires on the system or controller board pins", "The data cable in installed incorrectly; reverse it", "The power cable is not completely connected"], correctAnswerIndex: 1),
            
            Question2(interrogative: "If your company does not have an established preventative maintenance plan, you should ______", answers: ["not be concerned, as management knows best", "work around problems", "develop one", "focus on repairing down systems "], correctAnswerIndex: 2),
            
            Question2(interrogative: "In the ______ step of the laser print cycle, heat and pressure bond the toner to the paper", answers: ["developing", "fusing", "conditioning", "transferring"], correctAnswerIndex: 1),
            
            Question2(interrogative: "The first step in the consumer decision-making process is called", answers: ["alternative evaluation", "problem recognition", "purchase/no purchase decision", "information search"], correctAnswerIndex: 1),
            
            Question2(interrogative: "___________ marketing involves developing a unique mix of goods and services for each individual customer", answers: ["One-to-one", "B2B", "Usage", "volume"], correctAnswerIndex: 0),
            
            Question2(interrogative: "Limited liability for business debts is granted to", answers: ["general partners", "strategic alliances", "sole proprietors", "shareholders in S corporations"], correctAnswerIndex: 3),
            
            Question2(interrogative: "Groups of people such as workers who pool their money together for savings and to make loans is called a ", answers: ["union bank", "credit union", "state of the union", "labor union"], correctAnswerIndex: 1),
            
            Question2(interrogative: "Spending a few hours observing someone in your chosen occupation is called", answers: ["job mentoring", "job training", "job orientation", "job shadowing"], correctAnswerIndex: 3),
            
            Question2(interrogative: "When compared to a traditional savings account, a certificate of deposit is", answers: ["equally liquid", "less liquid", "more dynamic", "more liquid"], correctAnswerIndex: 1),
            
            Question2(interrogative: "_____ are rules about how businesses and their employees should behave", answers: ["mission statements", "standards", "values", "business ethics"], correctAnswerIndex: 3),
            
            Question2(interrogative: "A parliamentary procedure team can have ____ repeat members from a previous National Leadership Conference team", answers: ["one", "two", "three", "none"], correctAnswerIndex: 1),
            
            Question2(interrogative: "A Chapter Management Handbook updates are revised and distributed" , answers: ["as needed", "once a year", "twice a year", "every two years"], correctAnswerIndex: 1),
            
            Question2(interrogative: "The National Fall Leadership Conferences are held in", answers: ["September", "October", "November", "December"], correctAnswerIndex: 2),
            
            Question2(interrogative: "FBLA-PBL week is the second week in", answers: ["January", "February", "March", "April"], correctAnswerIndex: 1),
            
            Question2(interrogative: "In the last paragraph of the  FBLA Creed, the following statement is made", answers: ["I promise to use my abilities", "I agree to do my utmost", "Every person should actively", "Every person should prepare"], correctAnswerIndex: 0),
            
            Question2(interrogative: "In the performance event presentations", answers: ["Each team member has five minutes to speak", "the leader of the group presents all information”", "all the team members actively participate", "One member is designated to answer the judges questions"], correctAnswerIndex: 2),
            
            Question2(interrogative: "Key words found in the FBLA goals include", answers: ["confidence, understanding, efficient, scholarship", "seek, sincere, abide, initiative", "promise, aims, qualities, active", "manner, directors, regulations, cooperations"], correctAnswerIndex: 0)
            

    ]
    
    var previouslyUsedNumbers: [Int] = []
    
    mutating func getRandomQuestion2() -> Question2 {
        if (previouslyUsedNumbers.count == questions.count) {
            previouslyUsedNumbers = []
        }
        var randomNumber = GKRandomSource.sharedRandom().nextInt(upperBound: questions.count)
        
        // Picks a new random number if the previous one has been used
        while (previouslyUsedNumbers.contains(randomNumber)) {
            randomNumber = GKRandomSource.sharedRandom().nextInt(upperBound: questions.count)
        }
        previouslyUsedNumbers.append(randomNumber)
        
        return questions[randomNumber]
    }
}

class Question2 {
    
    fileprivate let interrogative: String
    fileprivate let answers: [String]
    fileprivate let correctAnswerIndex: Int
    
    init(interrogative: String, answers: [String], correctAnswerIndex: Int) {
        self.interrogative = interrogative
        self.answers = answers
        self.correctAnswerIndex = correctAnswerIndex
    }
    
    func validateAnswer(to givenAnswer: String) -> Bool {
        return (givenAnswer == answers[correctAnswerIndex])
    }
    
    func getInterrogative() -> String {
        return interrogative
    }
    
    func getAnswer() -> String {
        return answers[correctAnswerIndex]
    }
    
    func getChoices() -> [String] {
        return answers
    }
    
    func getAnswerAt(index: Int) -> String {
        return answers[index]
    }
}
