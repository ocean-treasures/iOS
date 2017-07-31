//
//  ViewController.swift
//  OceanTreasures
//
//  Created by Zahari on 7/27/17.
//  Copyright © 2017 OceanTreasures. All rights reserved.
//

import UIKit
import SDWebImage

class ViewController: UIViewController {
    @IBOutlet weak var word: UILabel!
    
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    @IBOutlet weak var image4: UIImageView!
    
    @IBOutlet weak var progressBar: UIProgressView!
    
    var nextWord: NextWordResponse?
    var selectedPicture: Picture?
    
    @IBAction func checkAnswer(_ sender: UITapGestureRecognizer) {
        self.selectedPicture = nextWord?.pictures?.filter({ (pic) -> Bool in
            return pic.id == sender.view?.tag
        }).first
        
        self.performSegue(withIdentifier: "toAnswerScreen", sender: self)
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return .landscape
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NextWordResponse.getData { (nextWord) in
            self.setupValues(from: nextWord)
            self.nextWord = nextWord
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.word.font = UIFont(name: "DKCoolCrayon", size: 70)
        
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    func setupValues(from data: NextWordResponse) {
        var urls: [URL] = []
        
        guard let pictures = data.pictures else { return }
        guard let progress = data.progress else { return }
        guard let word = data.word else { return }
        
        urls.append(URL(string: pictures[0].url!)!)
        urls.append(URL(string: pictures[1].url!)!)
        urls.append(URL(string: pictures[2].url!)!)
        urls.append(URL(string: pictures[3].url!)!)
        
        DispatchQueue.main.async {
            let STEP = 1.0 / Double(progress.max!)
            self.word.text = word.word
            self.progressBar.progress = Float(STEP * Double(progress.current!))
            
            self.image1.sd_setImage(with: urls[0])
            self.image1.tag = pictures[0].id!
            
            self.image2.sd_setImage(with: urls[1])
            self.image2.tag = pictures[1].id!
            
            self.image3.sd_setImage(with: urls[2])
            self.image3.tag = pictures[2].id!
            
            self.image4.sd_setImage(with: urls[3])
            self.image4.tag = pictures[3].id!
        }
    }
    
    private func readJson() {
        do {
            if let file = Bundle.main.url(forResource: "next_word_response1", withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let object = json as? [String: AnyObject] {
                    print("DICTIONARY")
//                    setupValues(from: object)
                    print(object)
                } else if let object = json as? [Any] {
                    print("ARRAY")
                    print(object)
                } else {
                    print("JSON is invalid")
                }
            } else {
                print("no file")
            }
        } catch {
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAnswerScreen" {
            if let destination = segue.destination as? AnswerViewController {
                destination.nextWord = self.nextWord
                destination.picture = self.selectedPicture
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

