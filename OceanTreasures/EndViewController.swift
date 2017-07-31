//
//  EndViewController.swift
//  OceanTreasures
//
//  Created by Zahari on 7/28/17.
//  Copyright © 2017 OceanTreasures. All rights reserved.
//

import UIKit

class EndViewController: UIViewController {
    
    @IBOutlet weak var playAgainButton: UIButton!
    
    @IBAction func playAgain(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.playAgainButton.titleLabel?.font = UIFont(name: "DKCoolCrayon", size: 40)
        self.playAgainButton.layer.cornerRadius = 6
    }
}
