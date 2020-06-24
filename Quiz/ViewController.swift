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
    var currentAnswers : [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        quizTextAnswer.isHidden = true
        quizQuestion.isHidden = true
        
        hideButtons(disp: true)
        confirmTextButton.isHidden = true
    }
    
    /**
     Function to hide/show all buttons
     */
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
    
    /**
     Initializes the questions and starts the quiz
     */
    func startQuiz()
    {
        let que1 = Question(questionText: "What's Batman real identity?", possibleAnswers: ["Bruce Waine", "Tom Jones", "David Hasselhoff", "Tony Stark"], correctAnswerIndex: [0], textAnswer: nil, type: QuestionType.Single)
        let que2 = Question(questionText: "Which actor has never played Spiderman?", possibleAnswers: ["Tom Holland", "George Clooney", "Andrew Garfield", "Tobey Maguire"], correctAnswerIndex: [1], textAnswer: nil, type: QuestionType.Single)
        let que3 = Question(questionText: "Which of these is not a real Apple product?", possibleAnswers: ["iMac", "Apple Watch", "iGlasses", "iPod"], correctAnswerIndex: [2], textAnswer: nil, type: QuestionType.Single)
        let que4 = Question(questionText: "What's 4+4*4?", possibleAnswers: [], correctAnswerIndex: [-1], textAnswer: "20", type: QuestionType.Text)
        let que5 = Question(questionText: "What version of Windows does not exist?", possibleAnswers: ["Windows 7", "Windows ME", "Windows XP SP2", "Windows XP SP4"], correctAnswerIndex: [3], textAnswer: nil, type: QuestionType.Single)
        let que6 = Question(questionText: "What does the 'P' in Android P stand for?", possibleAnswers: [], correctAnswerIndex: [-1], textAnswer: "Pie", type: QuestionType.Text)
        let que7 = Question(questionText: "Which one is not a real Samsung product?", possibleAnswers: ["Samsung Welt", "Samsung Tank", "Samsung SmartCube", "Samsung WindFree"], correctAnswerIndex: [2], textAnswer: nil, type: QuestionType.Single)
        let que8 = Question(questionText: "What is Twitch?", possibleAnswers: ["Game streaming platform", "Text editor", "IDE", "A car brand"], correctAnswerIndex: [0], textAnswer: nil, type: QuestionType.Single)
        let que9 = Question(questionText: "Which of these brands does not exist?", possibleAnswers: ["Samsung", "F-link", "US Robotics", "Tronda"], correctAnswerIndex: [1,3], textAnswer: nil, type: QuestionType.Multiple)
        let que10 = Question(questionText: "Which of these is a game conference?", possibleAnswers: ["Microsoft Build", "Google I/O", "MVDC", "E3"], correctAnswerIndex: [3], textAnswer: nil, type: QuestionType.Single)
        
        questions = [que1, que2, que3, que4, que5, que6, que7, que8, que9, que10]
        //Orders the questions randomly
        questions.shuffle()
        
        current = 0
        score = 0
        
        displayQuestion(quest: questions[0])
    }
    
    /**
     Given a question, it populates the UI
     */
    func displayQuestion(quest : Question)
    {
        reenableButtons()
        quizTextAnswer.text = ""
        currentAnswers.removeAll()
        quizQuestion.text = quest.questionText
        
        if (quest.type == QuestionType.Single || quest.type == QuestionType.Multiple)
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
        else //Text answer
        {
            hideButtons(disp : true)
            quizTextAnswer.isHidden = false
            confirmTextButton.isHidden = false
        }
        quizQuestion.isHidden = false
        
        if (quest.type == QuestionType.Multiple)
        {
            confirmTextButton.isHidden = false
        }
    }
    
    /**
     Given the selected answer index, checks if the answer is correct.
     
     Points:
     - 1 point for single answer questions
     - 1 point for text answer questions
     - 1 point if all answers are correct in multiple answers questions
     */
    func verifyAnswer(answerIndex : Int?)
    {
        quizTextAnswer.isEnabled = false
        
        if (questions[current].type == QuestionType.Single)
        {
            if (questions[current].correctAnswerIndex.contains(answerIndex!))
            {
                if (questions[current].correctAnswerIndex.count > 1)
                {
                    currentAnswers.append(answerIndex!)
                }
                
                //Correct answer
                displayAnswerResult(answerCorrect: true, currentAnswerIndex: answerIndex!)
                score += 1
                playSound(correctAnswer: true)
            }
            else
            {
                //Wrong answer
                displayAnswerResult(answerCorrect: false, currentAnswerIndex: answerIndex!)
                playSound(correctAnswer: false)
            }
        }
        //Multiple answers
        else if (questions[current].type == QuestionType.Multiple)
        {
            switch answerIndex
            {
                case 0:
                    quizAnswer1.tintColor = currentAnswers.contains(answerIndex!) ? self.view.tintColor : UIColor.darkGray
                    break
                case 1:
                    quizAnswer2.tintColor = currentAnswers.contains(answerIndex!) ? self.view.tintColor : UIColor.darkGray
                    break
                case 2:
                    quizAnswer3.tintColor = currentAnswers.contains(answerIndex!) ? self.view.tintColor : UIColor.darkGray
                    break
                case 3:
                    quizAnswer4.tintColor = currentAnswers.contains(answerIndex!) ? self.view.tintColor : UIColor.darkGray
                    break
                default:
                    break
            }
            
            if (!currentAnswers.contains(answerIndex!))
            {
                currentAnswers.append(answerIndex!)
            }
            else
            {
                let toremove = currentAnswers.firstIndex{ $0 == answerIndex!}
                currentAnswers.remove(at: toremove!)
            }
        }
        //Text answer
        else if (questions[current].type == QuestionType.Text)
        {
            let textAnswerCorrect = ((quizTextAnswer.text?.lowercased().contains(String(questions[current].textAnswer!.lowercased())))!)
            displayAnswerResult(answerCorrect: textAnswerCorrect, currentAnswerIndex: -1)
            playSound(correctAnswer: textAnswerCorrect)
            score += 1
        }
        
        quizTextAnswer.isEnabled = true
    }
    
    /**
     Shows the dialog with the result of the answer (correct/incorrect)
     */
    func displayAnswerResult(answerCorrect : Bool, currentAnswerIndex : Int)
    {
        var description : String = ""
        
        if (questions[current].type == QuestionType.Text)
        {
            description = (questions[current].textAnswer)! + " is the correct answer"
        }
        else
        {
            description = answerCorrect ? "You're going great!" : "Don't give up!"
        }
        
        let alert = UIAlertController(title: answerCorrect ? "Correct" : "Aw, that's wrong", message: description, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { action in
              switch action.style{
              case .default:
                
                    //There's more questions
                    if (self.current < self.questions.count - 1)
                    {
                        self.nextQuestion()
                    }
                    else
                    {
                        self.gameEnd()
                    }
              case .cancel:
                    break
              case .destructive:
                    break
              @unknown default:
                    break
            }}))
        self.present(alert, animated: true, completion: nil)
    }
    
    /**
     Handles the end of the game
     */
    func gameEnd()
    {
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
    
    /**
     Goes to the next question
     */
    func nextQuestion()
    {
        self.current += 1;
        self.displayQuestion(quest: self.questions[self.current])
    }
    
    /**
     Re-enables all the answer buttons
     */
    func reenableButtons()
    {
        self.quizAnswer1.isEnabled = true
        self.quizAnswer2.isEnabled = true
        self.quizAnswer3.isEnabled = true
        self.quizAnswer4.isEnabled = true
        
        quizAnswer1.tintColor = self.view.tintColor
        quizAnswer2.tintColor = self.view.tintColor
        quizAnswer3.tintColor = self.view.tintColor
        quizAnswer4.tintColor = self.view.tintColor
    }
    
    @IBAction func confirmTextAnswerClicked(_ sender: Any)
    {
        if (questions[current].type == QuestionType.Text)
        {
            verifyAnswer(answerIndex: nil)
        }
        else
        {
            if (questions[current].correctAnswerIndex.count == currentAnswers.count)
            {
                if (questions[current].correctAnswerIndex.sorted() == currentAnswers.sorted())
                {
                    //Correct
                    displayAnswerResult(answerCorrect: true, currentAnswerIndex: current)
                    score += 1
                }
                else
                {
                    //Wrong answer
                    displayAnswerResult(answerCorrect: false, currentAnswerIndex: current)
                }
            }
            else //Too many/few answers
            {
                displayAnswerResult(answerCorrect: false, currentAnswerIndex: current)
            }
        }
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
    
    /**
     Plays a sound based on the answer correctness
     */
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

