//
//  MOMonoManager.swift
//  Mono
//
//  Created by Martí Serra Vivancos on 31/01/15.
//  Copyright (c) 2015 Tomorrow Dev. All rights reserved.
//

import UIKit
import Realm

class MOMonoDB: RLMObject
{
    // Levels
    dynamic var happiness = 80.0
    dynamic var health = 80.0
    dynamic var energy = 80.0
    
    // String
    dynamic var lastAction = ""

    // Dates
    dynamic var lastActionDate: AnyObject = NSDate.distantPast()
    dynamic var lastAteDate: AnyObject = NSDate.distantPast()
    dynamic var birthDate = NSDate()
    dynamic var lastUpdatedDate = NSDate()
}

class MOMonoManager: NSObject
{
    // Constants
    let sleepDuration = 180.0
    let eatDuration = 20.0
    let playDuration = 30.0
    let showerDuration = 15.0
    
    // Create Singleton
    class var sharedInstance: MOMonoManager {
        struct Static {
            static var instance: MOMonoManager?
            static var token: dispatch_once_t = 0
        }
        dispatch_once(&Static.token) {
            Static.instance = MOMonoManager()
        }
        return Static.instance!
    }
    
    // Get MonoDB Object //
    func monoObject () -> MOMonoDB! {
        let allMonos = MOMonoDB.allObjects()
        if allMonos.count >= 1 {
            return allMonos.firstObject() as! MOMonoDB
        }
        else {
            // Create Mono object
            let realm = RLMRealm.defaultRealm()
            let newMono = MOMonoDB()
            
            newMono.birthDate = NSDate()
            realm.beginWriteTransaction()
            realm.addObject(newMono)
            realm.commitWriteTransaction()
            
            return newMono
        }
    }
    
    // Mono Activities //
    func monoPerformActivity (action: String) {
        if (monoActivity() == nil) {
            let mono = monoObject()
            let realm = RLMRealm.defaultRealm()
            
            // Save action data
            realm.beginWriteTransaction()
            mono.lastActionDate = NSDate()
            mono.lastAction = action
            
            // Change levels
            switch action {
            case "eat":
                // If mono ate 3 hours ago -> OK
                if (abs(mono.lastAteDate.timeIntervalSinceNow/60) > 180) {
                    mono.health += 10
                    mono.happiness += 5
                }
                    // If not -> Bad
                else {
                    mono.health -= 10
                    mono.happiness -= 5
                }
                mono.energy += 10
                mono.lastAteDate = NSDate()
            case "sleep":
                mono.energy += 20
                mono.happiness += 10
            case "play":
                mono.energy -= 15
                mono.happiness += 20
                mono.health += 10
            case "shower":
                mono.health += 10
                mono.happiness += 5
            default:
                println("Action doesn't exists")
            }
            realm.commitWriteTransaction()
            
            // Adjust levels if above limits
            limitMonoLevels()
        }
    }

    // Check if action is in progress
    func monoActivity () -> String? {
        let action = monoObject().lastAction
        var currentActionDuration: Double = 0
        
        switch action {
        case "eat":
            currentActionDuration = eatDuration
        case "sleep":
            currentActionDuration = sleepDuration
        case "play":
            currentActionDuration = playDuration
        case "shower":
            currentActionDuration = showerDuration
        default:
            currentActionDuration = 0
        }
        
        if (abs(monoObject().lastActionDate.timeIntervalSinceNow/60) > currentActionDuration) {
            println("No action in progress")
            return nil
        } else {
            println("Mono current action: \(action). Time left: \(currentActionDuration - abs(monoObject().lastActionDate.timeIntervalSinceNow/60))")
            return action
        }
    }
    
    // Mono Satisfaction Levels //
    func monoLevels () -> Dictionary<String, Double> {
        let mono = monoObject()
        let levelsDictionary = ["health" : mono.health, "energy" : mono.energy, "happiness" : mono.happiness];
        return levelsDictionary
    }
    
    func updateMonoLevels () -> Dictionary<String, Double> {
        let mono = monoObject()
        let timeSinceLastUpdate = mono.lastUpdatedDate.timeIntervalSinceNow/86400
        let realm = RLMRealm.defaultRealm()
        
        // Update mono levels according to last update
        realm.beginWriteTransaction()
        mono.health -= 40 * (timeSinceLastUpdate/24)
        mono.happiness -= 30 * (timeSinceLastUpdate/24)
        mono.energy -= 70 * (timeSinceLastUpdate/24)
        realm.commitWriteTransaction()
        
        // Adjust levels if above limits
        limitMonoLevels()
        
        // Return updated and adjusted levels
        return monoLevels()
    }
    
    // Mono Mood //
    func monoMood () -> String {
        let mono = monoObject()
        let totalLevel = mono.health + mono.happiness + mono.energy
        
        if (totalLevel>=250.0 && eachLevelAbove(75, mono: mono)) {
            // retun happy images
            return "happy"
        }
        else if (totalLevel>=150 && eachLevelAbove(50, mono: mono)) {
            // retun OK images
            return "happy" // WHen ok images are available return OK     
        }
        else if (totalLevel>=50 && eachLevelAbove(25, mono: mono)) {
            // retun sad images
            return "sad"
        }
        else {
            // retun critical images
            return "critical"
        }
    }
    
    // Check each if levels are above threshold
    func eachLevelAbove(threshold: Double, mono: MOMonoDB) -> Bool {
        if (mono.health>threshold && mono.happiness>threshold && mono.energy>threshold) {
            return true
        } else {
            return false
        }
    }
    
    // Limit level value under 0 and above 100
    func limitMonoLevels () {
        let mono = monoObject()
        let realm = RLMRealm.defaultRealm()
        
        realm.beginWriteTransaction()
  
        if (mono.energy > 100) {
            mono.energy = 100
        } else if (mono.energy < 0) {
            mono.energy = 0
        }
        
        if (mono.health > 100) {
            mono.health = 100
        } else if (mono.health < 0) {
            mono.health = 0
        }
        
        if (mono.happiness > 100) {
            mono.happiness = 100
        } else if (mono.happiness < 0) {
            mono.happiness = 0
        }
        realm.commitWriteTransaction()
    }
    
    // Mono State //
    func monoState () -> String {
        let activity = monoActivity()
        if monoAge() > 30 {
            return "dead"
        }
        else if (activity != nil) {
            return activity!
        }
        else {
            return monoMood()
        }
    }
    
    // Mono Age //
    func monoAge () -> Double {
        return abs(monoObject().birthDate.timeIntervalSinceNow/86400)
    }
    
    // Reborn mono //
    func rebornMono () {
        let realm = RLMRealm.defaultRealm()
        let newMono = MOMonoDB()
        
        // Delete current Mono object
        realm.beginWriteTransaction()
        realm.deleteObjects(MOMonoDB.allObjects())
        realm.commitWriteTransaction()
    }
}
