//
//  ViewController.swift
//  RetroCalculator
//
//  Created by Ronit Rudra on 7/29/17.
//  Copyright © 2017 Ronit Rudra. All rights reserved.
//

import UIKit
// For Audio
import AVFoundation

class ViewController: UIViewController {
    
    // create variable of type AVAudioPlayer
    var buttonSound : AVAudioPlayer!
    
    // create running number for display
    var runningNumber = ""

    @IBOutlet weak var outputLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // get path of btn of type wav
        let path = Bundle.main.path(forResource: "btn", ofType: "wav")
        // save it as URL and ! means that path must have value
        let soundURL = URL(fileURLWithPath : path!)
        
        
        // Do this with URL
        do{
            try buttonSound = AVAudioPlayer(contentsOf : soundURL)
            buttonSound.prepareToPlay()
        }
        // if it fails do this otherwis app might crash if URL empty
        catch let err as NSError{
            print(err.debugDescription )
        }
    
    }
    @IBAction func numberPressed(sender : UIButton ){
        // play buttong sfx
        playSound()
        // append pressed number
        // Tags>0 are digits, tag=0 is decimal
        if(sender.tag>0){
            runningNumber += "\(sender.tag)"
            outputLabel.text = runningNumber
        }
        else if(sender.tag == -1){
            runningNumber += "."
            outputLabel.text = runningNumber
        }
    }
    
    func playSound(){
        if (buttonSound.isPlaying){
            buttonSound.stop()
        }
        buttonSound.play()
    }

}

