//
//  ViewController.swift
//  Quiz
//
//  Created by Alessandro Spisso on 20/05/2020.
//  Copyright © 2020 Alessandro Spisso. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    @IBOutlet weak var quizQuestion: UILabel!
    @IBOutlet weak var quizAnswer1: UIButton!
    @IBOutlet weak var quizAnswer2: UIButton!
    @IBOutlet weak var quizAnswer3: UIButton!
    @IBOutlet weak var quizAnswer4: UIButton!
    @IBOutlet weak var quizTextAnswer: UITextField!
    @IBOutlet weak var startGameButton: UIButton!
    @IBOutlet weak var quizTitle: UILabel!
    @IBOutlet weak var confirmTextButton: UIButton!
    
    var player: AVAudioPlayer?
    
    var questions = [Question]()
    var current : Int = 0
    var score : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        quizTextAnswer.isHidden = true
        quizQuestion.isHidden = true
        
        hideButtons(disp: true)
        confirmTextButton.isHidden = true
    }
    
    func hideButtons(disp : Bool)
    {
        quizAnswer1.isHidden = disp
        quizAnswer2.isHidden = disp
        quizAnswer3.isHidden = disp
        quizAnswer4.isHidden = disp
    }

    @IBAction func startClick(_ sender: Any) {
        startGameButton.isHidden = true
        quizTitle.isHidden = true
        startQuiz()
    }
    
    func startQuiz()
    {
        let que1 = Question(questionText: "What's Batman real identity?", possibleAnswers: ["Bruce Wayine", "Tom Jones", "David Hasselhoff", "Tony Stark"], correctAnswerIndex: 0, isTextAnswer: false, textAnswer: nil)
        
        let que2 = Question(questionText: "Which actor has never played Spiderman?", possibleAnswers: ["Tom Holland", "George Clooney", "Andrew Garfield", "Tobey Maguire"], correctAnswerIndex: 1, isTextAnswer: false, textAnswer: nil)
        
        let que3 = Question(questionText: "Which of these is not a real Apple product?", possibleAnswers: ["iMac", "Apple Watch", "iGlasses", "iPod"], correctAnswerIndex: 2, isTextAnswer: false, textAnswer: nil)
        
        let que4 = Question(questionText: "What's 4+4*4?", possibleAnswers: [], correctAnswerIndex: -1, isTextAnswer: true, textAnswer: "20")
        
        questions = [que1, que2, que3, que4]
        current = 0
        
        displayQuestion(quest: que1)
    }
    
    func displayQuestion(quest : Question)
    {
        quizTextAnswer.text = ""
        quizQuestion.text = quest.questionText
        if (quest.possibleAnswers != nil && !quest.isTextAnswer)
        {
            let txt1 = quest.possibleAnswers?[0]
            let txt2 = quest.possibleAnswers?[1]
            let txt3 = quest.possibleAnswers?[2]
            let txt4 = quest.possibleAnswers?[3]
            quizAnswer1.setTitle(txt1, for: .normal)
            quizAnswer2.setTitle(txt2, for: .normal)
            quizAnswer3.setTitle(txt3, for: .normal)
            quizAnswer4.setTitle(txt4, for: .normal)
            
            quizTextAnswer.isHidden = true
            confirmTextButton.isHidden = true

            hideButtons(disp : false)
        }
        else
        {
            hideButtons(disp : true)
            quizTextAnswer.isHidden = false
            confirmTextButton.isHidden = false
        }
        quizQuestion.isHidden = false
    }
    
    func verifyAnswer(answerIndex : Int?)
    {
        if (!questions[current].isTextAnswer)
        {
            if (questions[current].correctAnswerIndex == answerIndex)
            {
                //Correct answer
                displayAnswerResult(answerCorrect: true)
                score += 5
                playSound(correctAnswer: true)
            }
            else
            {
                //Wrong answer
                displayAnswerResult(answerCorrect: false)
                playSound(correctAnswer: false)
            }
        }
        else
        {
            let textAnswerCorrect = ((quizTextAnswer.text?.lowercased().contains(String(questions[current].textAnswer!)))!)
            displayAnswerResult(answerCorrect: textAnswerCorrect)
            playSound(correctAnswer: textAnswerCorrect)
            score += 5
        }
    }
    
    func displayAnswerResult(answerCorrect : Bool)
    {
        var correct : String = ""
        
        if (!questions[current].isTextAnswer)
        {
            correct = (questions[current].possibleAnswers?[questions[current].correctAnswerIndex])! + " is the correct answer"
        }
        else
        {
            correct = (questions[current].textAnswer)! + " is the correct answer"
        }
        
        let alert = UIAlertController(title: answerCorrect ? "Correct" : "Aw, that's wrong", message: correct, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { action in
              switch action.style{
              case .default:
                self.current += 1;
                if (self.current < self.questions.count)
                {
                    self.displayQuestion(quest: self.questions[self.current])
                }
                else
                {
                    //Game end
                    
                    let alert = UIAlertController(title: "The end" , message: "Congrats! Your score is " + String(self.score) , preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Yay!", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                    self.quizTextAnswer.isHidden = true
                    self.quizQuestion.isHidden = true
                    
                    self.hideButtons(disp: true)
                    self.confirmTextButton.isHidden = true
                    
                    self.quizTitle.isHidden = false
                    self.startGameButton.isHidden = false
                }
              case .cancel:
                    print("cancel")

              case .destructive:
                    print("destructive")
              @unknown default:
                    print("bo")
            }}))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func confirmTextAnswerClicked(_ sender: Any)
    {
        verifyAnswer(answerIndex: nil)
    }
    @IBAction func answer1Clicked(_ sender: Any) {
        verifyAnswer(answerIndex: 0)
    }
    
    @IBAction func answer2Clicked(_ sender: Any) {
        verifyAnswer(answerIndex: 1)
    }
    
    @IBAction func answer3Clicked(_ sender: Any) {
        verifyAnswer(answerIndex: 2)
    }
    
    @IBAction func answer4Clicked(_ sender: Any) {
        verifyAnswer(answerIndex: 3)
    }
    
    func playSound(correctAnswer : Bool)
    {
        guard let url = Bundle.main.url(forResource: correctAnswer ? "correct_answer" : "wrong_answer", withExtension: "mp3") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            guard let player = player else { return }

            player.play()

        } catch let error {
            print(error.localizedDescription)
        }
    }
}

