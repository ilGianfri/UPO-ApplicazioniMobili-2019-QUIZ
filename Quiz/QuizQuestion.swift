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
    var correctAnswerIndex : [Int]
    var textAnswer : String?
    var type : QuestionType
    
    init(questionText : String, possibleAnswers : [String], correctAnswerIndex : [Int], textAnswer : String?, type : QuestionType)
    {
        self.questionText = questionText
        self.possibleAnswers = possibleAnswers
        self.correctAnswerIndex = correctAnswerIndex
        self.type = type
        self.textAnswer = textAnswer
    }
}

enum QuestionType
{
    case Single
    case Multiple
    case Text
}
