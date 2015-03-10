//
//  ViewController.swift
//  Mono
//
//  Created by Martí Serra Vivancos on 31/01/15.
//  Copyright (c) 2015 Tomorrow Dev. All rights reserved.
//

import UIKit


class MOMainVC: UIViewController {
    
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var healthBar: UIProgressView!
    @IBOutlet weak var happyBar: UIProgressView!
    @IBOutlet weak var energyBar: UIProgressView!
    @IBOutlet weak var healthValue: UILabel!
    @IBOutlet weak var happyValue: UILabel!
    @IBOutlet weak var energyValue: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Update top label
        stateLabel.text = stateLabel.text! + " \(MOMonoManager.sharedInstance.monoState())"
        
        // Update bars
        let monoLevels = MOMonoManager.sharedInstance.monoLevels()
        print(monoLevels)
        healthBar.progress = Float(monoLevels["health"]!)
        happyBar.progress = Float(monoLevels["happiness"]!)
        energyBar.progress = Float(monoLevels["energy"]!)
        
        // Upadate labels
        healthValue.text = String(format:"%.1f", monoLevels["health"]!)
        happyValue.text = String(format:"%.1f", monoLevels["happiness"]!)
        energyValue.text = String(format:"%.1f", monoLevels["energy"]!)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

