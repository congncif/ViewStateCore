//
//  NSObject+Properties.swift
//  ViewStateCore
//
//  Created by NGUYEN CHI CONG on 2/13/19.
//

import Foundation

extension NSObject {
    //
    // Retrieves an array of property names found on the current object
    // using Objective-C runtime functions for introspection:
    // https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtPropertyIntrospection.html
    //
    public func propertyNames() -> [String] {
        var results: [String] = []
        
        var count: UInt32 = 0
        let myClass: AnyClass = classForCoder
        let properties = class_copyPropertyList(myClass, &count)
        
        for i in 0..<count {
            if let property = properties?[Int(i)] {
                let cname = property_getName(property)
                let name = String(cString: cname)
                results.append(name)
            }
        }
        
        free(properties)
        
        return results
    }
}

extension ViewState: NSCopying {
    public func copy(with zone: NSZone? = nil) -> Any {
        return makeCopy(with: zone)
    }
    
    public func makeCopy(with zone: NSZone? = nil) -> Self {
        let properties = propertyNames()
        
        let newState = type(of: self).init()
        
        for property in properties {
            let value = self.value(forKey: property)
            
            if let copiedValue = value as? NSCopying {
                newState.setValue(copiedValue.copy(with: zone), forKey: property)
            } else {
                #if DEBUG
                if let someValue = value {
                    print("⚠️⚠️⚠️ \(String(describing: someValue)) do not conform NSCopying. This will perfrom a shallow copy 💗.")
                }
                #endif
                newState.setValue(value, forKey: property)
            }
        }
        
        return newState
    }
}
