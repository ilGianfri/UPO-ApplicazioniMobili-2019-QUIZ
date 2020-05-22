//
//  QuizQuestion.swift
//  Quiz
//
//  Created by Alessandro Spisso on 20/05/2020.
//  Copyright © 2020 Alessandro Spisso. All rights reserved.
//

import Foundation

struct Question
{
    var questionText : String?
    var possibleAnswers : [String]?
    var correctAnswerIndex : Int
    var isTextAnswer : Bool
    var textAnswer : String?
    
    init(questionText : String, possibleAnswers : [String], correctAnswerIndex : Int, isTextAnswer : Bool, textAnswer : String?)
    {
        self.questionText = questionText
        self.possibleAnswers = possibleAnswers
        self.correctAnswerIndex = correctAnswerIndex
        self.isTextAnswer = isTextAnswer
        self.textAnswer = textAnswer
    }
}



