//
//  InterfaceController.swift
//  Mono WatchKit Extension
//
//  Created by Martí Serra Vivancos on 01/02/15.
//  Copyright (c) 2015 Tomorrow Dev. All rights reserved.
//

import WatchKit
import Foundation

class MOMainIC: WKInterfaceController {
    
    var image: String? = String()

    @IBOutlet weak var mono: WKInterfaceImage!
    @IBOutlet weak var button: WKInterfaceButton!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
    }
    
    // Call activities to manager
    @IBAction func playActivity() {
        MOMonoManager.sharedInstance.monoPerformActivity("play")
        updateMonoImage()
    }
    @IBAction func sleepActivity() {
        MOMonoManager.sharedInstance.monoPerformActivity("sleep")
        updateMonoImage()
    }
    @IBAction func eatActivity() {
        MOMonoManager.sharedInstance.monoPerformActivity("eat")
        updateMonoImage()
    }
    @IBAction func showerActivity() {
        MOMonoManager.sharedInstance.monoPerformActivity("shower")
        updateMonoImage()
    }
    
    @IBAction func buttonAction() {
        if (image! == "dead") {
            MOMonoManager.sharedInstance.rebornMono()
            updateMonoImage()
        }
        else
        {
            self.pushControllerWithName("levels", context: nil);
        }
    }
    
    func updateMonoImage () {
        let savedImage = MOMonoManager.sharedInstance.monoState()
        if (image! != savedImage) {
            println("Loading new image")
            image = savedImage
            mono.setImageNamed("mono_\(savedImage)-")
            mono.startAnimatingWithImagesInRange(NSMakeRange(0, 20), duration: 1, repeatCount: -1)
        }
        if (savedImage == "dead") {
            button.setTitle("Reborn")
        }
    }

    override func willActivate() {
        updateMonoImage()
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
