//
//  ScoreModel.swift
//  FBLA
//
//  Created by Rishabh Mudradi on 1/15/19.
//  Copyright © 2019 Rishabh Mudradi. All rights reserved.
//

import Foundation

class ScoreModel {
    
    fileprivate var correctAnswers: Int = 0
    fileprivate var incorrectAnswers: Int = 0
    
    func reset() {
        correctAnswers = 0
        incorrectAnswers = 0
    }

    func incrementCorrectAnswers() {
        correctAnswers += 1
    }
    
    func incrementIncorrectAnswers() {
        incorrectAnswers += 1
    }
    
    func getQuestionsAsked() -> Int {
        return correctAnswers + incorrectAnswers
    }
    
    func getScore() -> String {
        let percentaile = Double(correctAnswers) / Double(getQuestionsAsked())
        
            return "Way to go!\n You got \(correctAnswers) out of \(getQuestionsAsked()) Try again with new questions!"
     
    }
}
