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

extension FillableKey {
    static let custom = "custom"
}

class AAA: NSObject, NSCopying, NSCoding {
    var abc = "abc"
    
    func copy(with zone: NSZone? = nil) -> Any {
        let newAAA = AAA()
        newAAA.abc = abc
        return newAAA
    }
    
    override init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        super.init()
        abc = coder.decodeObject(forKey: "abc") as? String ?? ""
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(abc, forKey: "abc")
    }
}

class TestState: ViewState {
    @objc dynamic var test: String = "Default Title"
    @objc dynamic var xx: String = "XX2XX"
    @objc dynamic var number: Int = 2018
    @objc dynamic var testEnum: TestEnum = .v4
    @objc dynamic var aaa: AAA = AAA()
    
    override var ignoreKeys: [String] {
        var keys = super.ignoreKeys
        let xxkey = #keyPath(TestState.xx)
        keys.append(xxkey)
        return keys
    }
}

class ViewController: UIViewController, ViewStateFillable, ViewStateMutiSubscribing {
    private var abc: String?
    
    struct InternalSubscriber: DedicatedViewStateRenderable {
        weak var vc: ViewController?
        
        init(vc: ViewController?) {
            self.vc = vc
        }
        
        func dedicatedRender(state: TestState) {
            vc?.abc = "XXX"
        }
    }
    
    struct InternalSub2: DedicatedViewStateSubscriber {
        weak var vc: ViewController?
        
        init(vc: ViewController?) {
            self.vc = vc
        }
        
        func dedicatedViewStateDidChange(newState: TestState) {
            vc?.abc = "did change"
        }
        
        func dedicatedViewStateDidSubscribe(_ state: TestState) {
            vc?.abc = "did sub"
        }
    }
    
    func fillingOptions(_ state: ViewState) -> [FillingOption] {
        return [
            O2O(#keyPath(TestState.test), valueLabel, #keyPath(UITextField.text))
        ]
    }
    
    func effectSubscribers(forState viewState: ViewState) -> [ViewStateSubscriber] {
        return [internalVS1, internalVS2]
    }
    
    var internalVS1: InternalSubscriber {
        return InternalSubscriber(vc: self)
    }
    
    var internalVS2: InternalSub2 {
        return InternalSub2(vc: self)
    }
    
    @IBOutlet var valueLabel: UILabel!
    
//    var state: TestState {
//        return (UIApplication.shared.delegate as! AppDelegate).state
//    }
    
    var state: TestState = TestState()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        state.register(subscriberObject: self)
//        state.register(subscriber: internalVS1)
//        state.register(subscriber: internalVS2)
        
        let data = state.toData()
        
        if let newState = TestState.fromData(data) {
            let state3 = TestState()
            state3.restoreFromState(newState)
        }
        
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
//        state.testEnum = .v4
        state.test = "XXX"
    }
}
