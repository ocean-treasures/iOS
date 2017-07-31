//
//  AnswerViewController.swift
//  OceanTreasures
//
//  Created by Zahari on 7/27/17.
//  Copyright © 2017 OceanTreasures. All rights reserved.
//

import UIKit

class AnswerViewController: UIViewController {
    
    var nextWord: NextWordResponse?
    var picture: Picture?
    var progress: MyProgress?

    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var indicator: UIImageView!
    
    @IBOutlet weak var answerMessage: UILabel!
    @IBOutlet weak var answerWord: UILabel!

    @IBOutlet weak var progressBar: UIProgressView!

    @IBAction func imageClicked(_ sender: UITapGestureRecognizer) {
        chooseNextScreen()
    }
    
    @IBAction func nextQuestion(_ sender: UIButton) {
        chooseNextScreen()
    }
    
    func chooseNextScreen() {
        guard let progress = progress else { return }
        
        if progress.current != progress.max {
            //get next question { pop }
            navigationController?.popViewController(animated: true)
        }
        else {
            //go to end screen
            performSegue(withIdentifier: "toEndScreen", sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.answerWord.font = UIFont(name: "DKCoolCrayon", size: 75)
        self.answerMessage.font = UIFont(name: "DKCoolCrayon", size: 90)
        self.nextButton.titleLabel?.font = UIFont(name: "DKCoolCrayon", size: 40)
        self.nextButton.layer.cornerRadius = 6
        self.indicator.contentMode = .scaleAspectFit
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let nextWord = nextWord, let picture = picture else { return }
        
        CheckAnswerResponse.checkAnswer(word: nextWord, pic: picture) { answer in
            self.setupValues(from: answer)
        }
    }
    
    func setupValues(from data: CheckAnswerResponse) {
        guard let correct = data.correct else { return }
        guard let progress = data.progress else { return }
        
        self.progress = progress
        
        DispatchQueue.main.async {
            if correct {
                self.answerMessage.text = "CORRECT"
                self.indicator.image = UIImage(named: "seahorse")
            }
            else {
                self.answerMessage.text = "WRONG"
                self.indicator.image = UIImage(named: "sea_urchin")
            }
            
            let STEP = 1.0 / Double(progress.max!)
            self.progressBar.progress = Float(STEP * Double(progress.current!))
            self.image.sd_setImage(with: URL(string: self.picture!.url!))
            self.answerWord.text = data.word
        }
    }
}
