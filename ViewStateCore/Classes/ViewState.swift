//
//  ViewState.swift
//  ViewStateCore
//
//  Created by NGUYEN CHI CONG on 1/17/18.
//  Copyright © 2018 NGUYEN CHI CONG. All rights reserved.
//

import Foundation

public protocol ViewStateSubcriber: NSObjectProtocol {
    func viewStateDidChange(newState: ViewState)
    func viewStateDidChange(newState: ViewState, keyPath: String, oldValue: Any?, newValue: Any?)
}

public extension ViewStateSubcriber {
    public func viewStateDidChange(newState: ViewState, keyPath: String, oldValue: Any?, newValue: Any?) {
        // default
    }
}

fileprivate let kSubscribers = "subscribers"
fileprivate let kDelegate = "delegate"

open class ViewState: NSObject, ViewStateSubcriber {
    
    public private(set) var subscribers: [ViewStateSubcriber] = []
    public weak var delegate: ViewStateSubcriber?
    
    public var keys: [String] {
        var results = [String]()
        let otherSelf = Mirror(reflecting: self)
        
        for child in otherSelf.children {
            if let key = child.label {
                results.append(key)
            }
        }
        
        var mirror: Mirror = otherSelf
        
        while let superMirror = mirror.superclassMirror {
            for child in superMirror.children {
                if let key = child.label {
                    results.append(key)
                }
            }
            mirror = superMirror
        }
        
        return results
    }
    
    open var ignoreKeys: [String] {
        return [kSubscribers, kDelegate]
    }
    
    public override init() {
        super.init()
        addObservers()
    }
    
    open func addObservers() {
        for key in keys {
            guard !ignoreKeys.contains(key) else { continue }
            self.addObserver(self, forKeyPath: key, options: [.old, .new], context: nil)
            
            if let subState = self.value(forKey: key) as? ViewState {
                subState.delegate = self
            }
        }
    }
    
    open func removeObservers() {
        for key in keys {
            guard !ignoreKeys.contains(key) else { continue }
            self.removeObserver(self, forKeyPath: key)
        }
    }
    
    public func subscribe(for object: ViewStateSubcriber) {
        if !subscribers.contains(where: { (scrb) -> Bool in
            return scrb.isEqual(object)
        }) {
            subscribers.append(object)
        }
    }
    
    public func unsubscribe(for object: ViewStateSubcriber) {
        if let index = subscribers.index(where: { (scrb) -> Bool in
            return scrb.isEqual(object)
        }) {
            subscribers.remove(at: index)
        }
    }
    
    deinit {
        subscribers.removeAll()
        removeObservers()
    }
    
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let key = keyPath, !ignoreKeys.contains(key) else { return }
        
        notifyStateDidChange(newState: self)
        
        let oldValue = change?[NSKeyValueChangeKey.oldKey]
        let newValue = change?[NSKeyValueChangeKey.newKey]
        if let value = newValue as? ViewState {
            value.delegate = self
        }
        notifyStateDidChange(newState: self, keyPath: key, oldValue: oldValue, newValue: newValue)
        
    }
    
    public func notifyStateDidChange(newState: ViewState? = nil) {
        let state = newState ?? self
        delegate?.viewStateDidChange(newState: state)
        
        for scrb in subscribers {
            scrb.viewStateDidChange(newState: state)
        }
    }
    
    public func notifyStateDidChange(newState: ViewState? = nil, keyPath: String, oldValue: Any?, newValue: Any?) {
        let state = newState ?? self
        
        delegate?.viewStateDidChange(newState: state, keyPath: keyPath, oldValue: oldValue, newValue: newValue)
        
        for scrb in subscribers {
            scrb.viewStateDidChange(newState: state, keyPath: keyPath, oldValue: oldValue, newValue: newValue)
        }
    }
    
    public func viewStateDidChange(newState: ViewState) {
        notifyStateDidChange(newState: newState)
    }
    
    public func viewStateDidChange(newState: ViewState, keyPath: String, oldValue: Any?, newValue: Any?) {
        notifyStateDidChange(newState: newState, keyPath: keyPath, oldValue: oldValue, newValue: newValue)
    }
    
    fileprivate func key(for value: ViewState) -> String? {
        for aKey in keys {
            if let val = self.value(forKeyPath: aKey) as? ViewState, val == value {
                return aKey
            }
        }
        return nil
    }
    
    
}
