//
//  StartViewController.swift
//  OceanTreasures
//
//  Created by Zahari on 7/28/17.
//  Copyright © 2017 OceanTreasures. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {
    
    @IBOutlet weak var startButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.startButton.layer.cornerRadius = 6
        self.startButton.titleLabel?.font = UIFont(name: "DKCoolCrayon", size: 50)
    }
}
