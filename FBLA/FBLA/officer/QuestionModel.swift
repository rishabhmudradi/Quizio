//
//  QuestionModel.swift
//  FBLA
//
//  Created by Rishabh Mudradi on 1/12/19.
//  Copyright © 2019 Rishabh Mudradi. All rights reserved.
//
import GameKit

struct QuestionModel {
    
    let questions = [
        Question(interrogative: "Who is the national president?", answers: ["Eu Ro Wang", "Keerti Soundappan", "Woodrow Wilson", "Andrew Jackson"], correctAnswerIndex: 0),
         Question(interrogative: "Who is the national secretary?", answers: ["Eu Ro Wang", "Keerti Soundappan", "Galadriel Coury", "Garett Koch"], correctAnswerIndex: 2),
         Question(interrogative: "Who is the FBLA Southern Regional Vice President?", answers: ["Keerti Soundappan", "Ty Rickard", "Andrew Jackson", "Woodrow Wilson"], correctAnswerIndex: 1),
         Question(interrogative: "Who is the FBLA North Central Region Vice President?", answers: ["Keerti Soundappan", "Ty Rickard", "Eli Amyx", "Woodrow Wilson"], correctAnswerIndex: 2),
         Question(interrogative: "Who is the FBLA Treasurer?", answers: ["Galadriel Coury", "Eli Amyx", "Keerti Soundappan" , "Ty Rickard"], correctAnswerIndex: 0),
         Question(interrogative: "Who is the FBLA Mountain Plains Region VP?", answers: ["Madelyn Remington", "Eli Amyx", "Ty Rickard", "Steve Manickan"], correctAnswerIndex: 0),
        Question(interrogative: "Who is the FBLA Western Region VP?", answers: ["Steve Rack", "Bill Axe", "Ty Rickard", "Trentyn Tennant"], correctAnswerIndex: 3),
        Question(interrogative: "Who is the FBLA National Parliamentarian?", answers: ["Steve Rack", "Bill Axe", "Michael Zhao ", "Trentyn Tennant"], correctAnswerIndex: 2),
        Question(interrogative: "Who is the FBLA PBL Southern Region Vice President?", answers: ["Abigail Sheen", "Amber Raub", "Joel Beckwith", "Allyssa Covert"], correctAnswerIndex:3),
        Question(interrogative: "Who is the FBLA PBL Eastern Region Vice President?", answers: ["Abigail Sheen", "Garett Koch", "Allyssa Covert", "Joel Beckwith"], correctAnswerIndex:1),
        Question(interrogative: "Who is the FBLA Bay Section President?", answers: ["  Venugopal Chillal", "Jessie Cheng", "Amish Gupta", "Rishabh Mudradi"], correctAnswerIndex:1),
        Question(interrogative: "Who is the FBLA Bay Section President of Outreach?", answers: ["Venugopal Chillal", "Jessie Cheng", "Amish Gupta", "Rishabh Mudradi"], correctAnswerIndex:0),
        Question(interrogative: "Who is the FBLA Bay Secretary/Treasurer?", answers: ["Venugopal Chillal", "Jessie Cheng", "Teressa Yang","Ashwin Pasupathy"], correctAnswerIndex:3),
        Question(interrogative: "Who is the FBLA Bay Section President of Activities?", answers: ["Venugopal Chillal", "Ritu Channagiri", "Lorna Louie", "Teressa Yang"], correctAnswerIndex:1),
        Question(interrogative: "Who is the CA FBLA State Public Relation Officer?", answers: ["Venugopal Chillal", "Ritu Channagiri", "Lorna Louie", "Teressa Yang"], correctAnswerIndex:2),
        Question(interrogative: "Who is the FBLA Bay Section President of Activities?", answers: ["Venugopal Chillal", "Anusha Fatehpuria", "Lorna Louie", "Teressa Yang"], correctAnswerIndex:1),
        Question(interrogative: "Who is the FBLA State Secretary?", answers: ["Laeticia Yang", "Anusha Fatehpuria", "Lorna Louie", "Teressa Yang"], correctAnswerIndex:1),
    
        Question(interrogative: "Who is the FBLA Bay Section Parliamentarian?", answers: ["Venugopal Chillal", "Ritu Channagiri", "Lorna Louie", "Teressa Yang"], correctAnswerIndex:3),
        Question(interrogative: "Who is the FBLA Bay Section Director?", answers: ["Venugopal Chillal", "Mr. Graeme Logiei", "Lorna Louie", "Teressa Yang"], correctAnswerIndex:3),
        Question(interrogative: "Who founded FBLA?", answers: ["Hamden L. Forkner", "Mr. Graeme Logiei", "Bill Trustworth", "Steve Matt"], correctAnswerIndex:0),
        Question(interrogative: "Who is the CEO of FBLA?", answers: ["Jean Buckley", "Mr. Graeme Logiei", "Bill Trustworth", "Steve Matt"], correctAnswerIndex:0),
        Question(interrogative: "Who is the PBL President of FBLA?", answers: ["Jean Buckley", "Corbin Robinson", "Blucker Jacey", "Steve Matt"], correctAnswerIndex:0)
    ]
    
    var previouslyUsedNumbers: [Int] = []
    
    mutating func getRandomQuestion() -> Question {
        
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

class Question {
    
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
