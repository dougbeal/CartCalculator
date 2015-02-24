//
//  ViewController.swift
//  CartCalculator
//
//  Created by Douglas Beal on 2/18/15.
//  Copyright (c) 2015 Murder Of Crows Software. All rights reserved.
//

import UIKit
import Cartography


class ViewController: UIViewController {

    var excludeStatusBarView: UIView?
    var layoutElements = Dictionary<String, UIView>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 1, alpha: 1.0)        
        createViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Allow any orinetation.
    // How to set the orientation. The return value is not what we expect, Int not UInt so we cast.
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.All.rawValue)
    }

    // status bar may disappear when rotation happens, so update excludeStatusBarView size 
    override func viewWillLayoutSubviews() {
        excludeStatusBarView!.frame = UIScreen.mainScreen().applicationFrame
    }

    func createViews() {
        excludeStatusBarView = UIView(frame: UIScreen.mainScreen().applicationFrame)
        excludeStatusBarView!.accessibilityIdentifier = "exclude status bar view"
        excludeStatusBarView!.backgroundColor = UIColor.grayColor()
        view.addSubview(excludeStatusBarView!)        
        layoutElements["view"] = view
        layoutElements["excludeStatusBarView"] = excludeStatusBarView
        
        var display = UILabel()
        layoutElements["display"] = display
        display.text = "0"
        display.textAlignment = NSTextAlignment.Right
        display.accessibilityIdentifier = "display"

        
        var history = UILabel()
        layoutElements["history"] = history
        history.text = "history"
        history.textAlignment = NSTextAlignment.Right
        history.accessibilityIdentifier = "history"
        
        
        excludeStatusBarView!.addSubview(display)
        excludeStatusBarView!.addSubview(history)
        
        var keypadView = UIView()
        layoutElements["keypadView"] = keypadView
        keypadView.accessibilityIdentifier = "keypadView"
        keypadView.backgroundColor = UIColor.blueColor()
        excludeStatusBarView!.addSubview(keypadView)

        let grid = [ 
        ["<bks>", "cos", "sin", "/"],
        ["7", "8", "9", "x"],
        ["4", "5", "6", "-"],
        ["1", "2", "3", "+"],
        ["\u{03C0}" , "0", ".", "<ent>"]
        ]
        // ([Int](0...9)).map { String($0) } + [ ".", "π", "+", "-", "x", "/", "cos", "sin", "\u{03C0}" ] 
        let symbols = grid.reduce([], +)
        for symbol in symbols {
            var button = UIButton()            
            layoutElements["button_\(symbol)"] = button 
            button.setTitle("\(symbol)", forState:UIControlState.Normal)
            button.titleLabel!.textAlignment=NSTextAlignment.Center
            button.addTarget(self, action: "buttonPressed:", forControlEvents: .TouchUpInside)
            keypadView.addSubview(button)
            
        }
        
        
        var enter = UIButton()
        layoutElements["button_<ent>"] = enter
        enter.setTitle("\u{23CE}", forState: UIControlState.Normal)
        enter.addTarget(self, action: "buttonPressed:", forControlEvents: .TouchUpInside)
        var backspace = UIButton()
        layoutElements["button_<bks>"] = backspace
        backspace.setTitle("\u{232B}", forState: UIControlState.Normal)
        backspace.addTarget(self, action: "buttonPressed:", forControlEvents: .TouchUpInside)


        keypadView.addSubview(enter)
        
        keypadView.addSubview(backspace)


        

        layout(layoutElements) { le in
            let display = le["display"]!
            let history = le["history"]!            
            let noStatusBar = le["excludeStatusBarView"]!
            let keypadView = le["keypadView"]!
            let buttonGrid = grid.map { $0.map { le["button_\($0)"]! } }
                                 let buttonSpacing = 4.0
                                 
            history.top == noStatusBar.top
            display.top == history.bottom
            keypadView.top == display.bottom
            keypadView.bottom == noStatusBar.bottomMargin 
            keypadView.bottom >= buttonGrid.last!.last!.bottom + 8 ~ 500


            for thing in [history, display, keypadView] {
                thing.left == noStatusBar.leftMargin
                thing.right == noStatusBar.rightMargin
            }


            for button in buttonGrid.first! {
                button.top == keypadView.topMargin
            }
            var prev = buttonGrid.first!.first!
            for row in buttonGrid[1..<buttonGrid.count] {
                for button in row {
                    button.top == prev.bottom + buttonSpacing
                }
                prev = row.first!
            }
            
            for row in buttonGrid {
                align(top: row)
                row.first!.left >= noStatusBar.leftMargin
                row.last!.right <= noStatusBar.rightMargin
                var prev = row.first!
                for button in row[1..<row.count-1] {
                    prev.right == button.left + buttonSpacing
                    prev = button
                }
                prev.right == row.last!.left + buttonSpacing
            }

                    
        }
    }

    func buttonPressed(send: UIButton) {
        println("button pressed = \(send.currentTitle!)")
    }

}

