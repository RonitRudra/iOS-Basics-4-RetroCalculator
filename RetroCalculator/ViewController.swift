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
    
    // Enumeration (KVP) for operations
    enum Operation : String {
        case Divide = "/"
        case Multiply = "*"
        case Subtract = "-"
        case Add = "+"
        case Empty = "Empty"
    }
    
    // create running number for display
    var runningNumber = ""
    
    // Variable for storing current operation
    var currentOperation = Operation.Empty
    
    var leftVal = ""
    var rightVal = ""
    var result = ""

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
        // Tags>=0 are digits, tag=-1 is decimal
        if(sender.tag>=0){
            runningNumber += "\(sender.tag)"
            outputLabel.text = runningNumber
        }
        else if(sender.tag == -1){
            runningNumber += "."
            outputLabel.text = runningNumber
        }
    }
    
    @IBAction func changeSignPressed(sender : UIButton){
        playSound()
        // Add negative sign to number if not present
        if(runningNumber[runningNumber.startIndex] != "-"){
            runningNumber = "-" + runningNumber
            outputLabel.text = runningNumber
        } else {
            // replace runningNumber with substring after starting index to end index
            // ..< from left operand to less than right operand
            // string.endIndex gives index after last character which will throw an error if used unless stopped before it
            // NOTE TO SELF: String operations are a pain in swift
            runningNumber = String(runningNumber[runningNumber.index(after: runningNumber.startIndex)..<runningNumber.endIndex])
            print(runningNumber)
            outputLabel.text = runningNumber
        }
    }
    
    @IBAction func clearPressed(sender : UIButton){
        playSound()
        // clear all variables
        runningNumber = ""
        leftVal = ""
        rightVal = ""
        currentOperation = Operation.Empty
        outputLabel.text = "0"
    }
    
    @IBAction func reciprocalPressed(sender : UIButton){
        playSound()
        // perform reciprocal on non empty number
        if(runningNumber != ""){
            print()
            runningNumber = "\(1/Double(runningNumber)!)"
            outputLabel.text = runningNumber
        }
    }
    
    @IBAction func dividePressed(sender : Any){
        processOperation(operation: Operation.Divide)
    }
    @IBAction func multiplyPressed(sender : Any){
        processOperation(operation: Operation.Multiply)
    }
    @IBAction func subtractPressed(sender : Any){
        processOperation(operation: Operation.Subtract)
    }
    @IBAction func addPressed(sender : Any){
        processOperation(operation: Operation.Add)
    }
    @IBAction func equalPressed(sender : Any){
        processOperation(operation: currentOperation)
    }
    
    func playSound(){
        if (buttonSound.isPlaying){
            buttonSound.stop()
        }
        buttonSound.play()
    }
    
    func processOperation(operation : Operation){
        playSound()
        // We have both left and right operands and the operator
        if(currentOperation != Operation.Empty){
            if runningNumber != "" {
                rightVal = runningNumber
                runningNumber = ""
                
                // perform operation
                // be sure to unwrap explicitly to avoid errors
                if(currentOperation == Operation.Divide){
                    result = "\(Double(leftVal)!/Double(rightVal)!)"
                } else if(currentOperation == Operation.Multiply){
                    result = "\(Double(leftVal)!*Double(rightVal)!)"
                } else if(currentOperation == Operation.Subtract){
                    result = "\(Double(leftVal)!-Double(rightVal)!)"
                } else if(currentOperation == Operation.Add){
                    result = "\(Double(leftVal)!+Double(rightVal)!)"
                }
                
                leftVal = result
                outputLabel.text = result
            }
            
            currentOperation = operation
        } else{
            // no right operand present
            leftVal = runningNumber
            runningNumber = ""
            currentOperation = operation
        }
    }

}

