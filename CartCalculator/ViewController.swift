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
        layoutElements["view"] = view
        layoutElements["excludeStatusBarView"] = excludeStatusBarView
        
        var display = layoutElements["display"] = UILabel()
        var history = layoutElements["history"] = UILabel()
        for digit in 0...9 {
            var button = layoutElements["button\(digit)"] = UIButton()
            button.accesibilityIdentifier = "\(digit)"
        }
        for symbol in [ 0...9, ".", "π", "+", "-", "x", "/", "cos", "sin" ] {
            var button = layoutElements["button\(symbol)"]
            button.text = button.accesibilityIdentifier = "\(symbol)"
           }
        
        var enter = layoutElements["button<ent>"] = UIButton()                
        var backspace = layoutElements["button<bks>"] = UIButton()                
        		            									
    
        view.addSubview(excludeStatusBarView!)
        layout(layoutElements) { (le: [String: UIView]) in
            println("\(le)")
            le["display"].top = le["excludeStatusBarView"].top
            
        }
    }

}

