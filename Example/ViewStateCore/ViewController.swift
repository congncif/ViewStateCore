//
//  ViewController.swift
//  ViewStateCore
//
//  Created by congncif on 01/17/2018.
//  Copyright (c) 2018 congncif. All rights reserved.
//

import UIKit
import ViewStateCore

class TestState: ViewState {
    dynamic var test: String = "Default value"
}

class ViewController: UIViewController, ViewStateSubscriber {

    @IBOutlet var valueLabel: UILabel!
    
    var state = TestState()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        state.subscribe(for: self)
        
        render()
    }
    
    deinit {
        state.unsubscribe(for: self)
    }

    func render() {
        valueLabel.text = state.test
    }
    
    func viewStateDidChange(newState: ViewState) {
        render()
    }
    
    @IBAction func buttonDidTap(_ sender: Any) {
        state.test = "Value Changed"
    }

}

