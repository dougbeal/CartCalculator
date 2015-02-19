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
    var layoutElements: [String: View]
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
        
        view.addSubview(excludeStatusBarView!)
        layout(layoutElements) { (le: [String: View]) in
                                 println("\(le)")
        }
    }

}

