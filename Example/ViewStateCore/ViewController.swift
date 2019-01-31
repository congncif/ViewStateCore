//
//  ViewController.swift
//  ViewStateCore
//
//  Created by congncif on 01/17/2018.
//  Copyright (c) 2018 congncif. All rights reserved.
//

import UIKit
import ViewStateCore

@objc enum TestEnum: Int {
    case v1
    case v2
    case v3
    case v4
}

class TestState: ViewState {
    @objc dynamic var test: String = "Default value"
    @objc dynamic var xx: String = ""
    @objc dynamic var testEnum: TestEnum = .v1
    
    override var ignoreKeys: [String] {
        var keys = super.ignoreKeys
        let xxkey = #keyPath(TestState.xx)
        keys.append(xxkey)
        return keys
    }
}

class ViewController: UIViewController, ViewStateSubscriber {
    
    func viewStateDidChange(newState: ViewState) {
        render()
    }
    
    @IBOutlet var valueLabel: UILabel!
    
//    var state: TestState {
//        return (UIApplication.shared.delegate as! AppDelegate).state
//    }
    
    var state: TestState = TestState()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subscribeStateChange(state)
        
        render()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        state.subscribe(for: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        state.unsubscribe(for: self)
    }
    
    deinit {
        state.unregister(subscriber: self)
        print("XXX")
    }
    
    func render() {
        valueLabel.text = state.test
    }
    
//    func viewStateDidChange(newState: ViewState) {
//        render()
//    }
//
//    func viewStateDidSubscribed(state: ViewState) {
//        print("Refresh")
//    }
//
//    func viewStateWillUnsubscribed(state: ViewState) {
//        print("Unsub...")
//    }
    
    @IBAction func buttonDidTap(_ sender: Any) {
        state.testEnum = .v4
    }
}
