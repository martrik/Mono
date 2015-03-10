//
//  MOLevelsIC.swift
//  Mono
//
//  Created by Martí Serra Vivancos on 07/02/15.
//  Copyright (c) 2015 Tomorrow Dev. All rights reserved.
//

import WatchKit
import Foundation

class MOLevelsIC: WKInterfaceController {
    
    @IBOutlet weak var healthLabel: WKInterfaceLabel!
    @IBOutlet weak var energyLabel: WKInterfaceLabel!
    @IBOutlet weak var happinessLabel: WKInterfaceLabel!
    @IBOutlet weak var actionLabel: WKInterfaceLabel!

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Update levels
        let monoLevels = MOMonoManager.sharedInstance.monoLevels()
        attributedLevel(healthLabel, key: "Health", value: monoLevels["health"]!)
        attributedLevel(energyLabel, key: "Energy", value: monoLevels["energy"]!)
        attributedLevel(happinessLabel, key: "Happiness", value: monoLevels["happiness"]!)
        
        actionLabel.setText("mono is \(MOMonoManager.sharedInstance.monoState())")
    }

    func attributedLevel(label: WKInterfaceLabel, key: String, value: Double) {
        var key = NSMutableAttributedString(string: "\(key): ", attributes: nil);
        
        var color = UIColor()
        switch value {
        case 75...100:
            color = UIColor.greenColor()
        case 50...74:
            color = UIColor.yellowColor()
        case 25...49:
            color = UIColor.orangeColor()
        default:
            color = UIColor.redColor()
        }
        
        let value = NSAttributedString(string: "\(value)", attributes: [NSForegroundColorAttributeName: color]);
        key.appendAttributedString(value)
        
        label.setAttributedText(key)
    }
    
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
}
