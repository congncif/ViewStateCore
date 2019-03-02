//
//  ViewSubscriberHolderProtocol.swift
//  ViewStateCore
//
//  Created by NGUYEN CHI CONG on 2/28/19.
//

import Foundation
import UIKit

// Convinience to connect ViewStateSubscriber via Interface Builder
@objc
public protocol ViewSubscriberHolderProtocol: class {}

extension ViewSubscriberHolderProtocol where Self: ViewStateSubscriber {
    public var subscriber: ViewStateSubscriber {
        return self
    }
}

extension ViewState {
    public func registerSubscriber<Holder>(holder: Holder) where Holder: ViewSubscriberHolderProtocol, Holder: ViewStateSubscriber {
        register(subscriber: holder.subscriber)
    }

    public func unregisterSubscriber<Holder>(holder: Holder) where Holder: ViewSubscriberHolderProtocol, Holder: ViewStateSubscriber {
        unregister(subscriber: holder.subscriber)
    }
}
