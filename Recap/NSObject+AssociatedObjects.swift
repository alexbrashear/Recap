//
//  NSObject+AssociatedObjects.swift
//  Recap
//
//  Created by Alex Brashear on 9/30/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import Foundation

/**
 Wrapper for Associated Objects that allows us to use Swift value types.
 */
public final class AssociatedObjectWrapper<T>: NSObject, NSCopying {
    public let value: T
    
    public init(_ value: T) {
        self.value = value
    }
    
    public func copy(with zone: NSZone?) -> Any {
        if let copyingValue = value as? NSCopying {
            // swiftlint:disable:next force_cast
            return AssociatedObjectWrapper(copyingValue.copy(with: zone) as! T)
        }
        
        return AssociatedObjectWrapper(value)
    }
}

extension NSObject {
    
    /// Association policy for properties, we only support a subset from `objc_AssociationPolicy`.
    public enum AssociationPolicy {
        /// Retain, nonatomic
        case retain
        
        /// Copy, nonatomic
        case copy
        
        func asAssociationPolicy() -> objc_AssociationPolicy {
            switch self {
            case .copy:
                return .OBJC_ASSOCIATION_COPY_NONATOMIC
            case .retain:
                return .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            }
        }
    }
    
    /**
     Sets associated object for specified `key`.
     
     - parameter object:         Object to set.
     - parameter key:            Key to use.
     - parameter policy:         Policy to follow.
     */
    public func setAssociatedObject<T>(_ object: T, forKey key: UnsafeRawPointer, policy: AssociationPolicy) {
        if let object = object as? AnyClass {
            objc_setAssociatedObject(self, key, object, policy.asAssociationPolicy())
        } else {
            objc_setAssociatedObject(self, key, AssociatedObjectWrapper(object), policy.asAssociationPolicy())
        }
    }
    
    /**
     Returns associated object for `key`.
     
     - parameter key: Key to use.
     
     - returns: Currently associated object.
     */
    public func getAssociatedObject<T>(forKey key: UnsafeRawPointer) -> T? {
        let current = objc_getAssociatedObject(self, key)
        
        //! for type inferrence with complicated cases it's better to have explicitly expressed all cases
        if let v = current as? T {
            return v
        } else if let v = current as? T? {
            return v
        } else if let v = current as? AssociatedObjectWrapper<T> {
            return v.value
        } else if let v = current as? AssociatedObjectWrapper<T?> {
            return v.value
        } else {
            return nil
        }
    }
}
