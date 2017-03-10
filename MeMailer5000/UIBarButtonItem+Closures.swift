//
//  UIBarButtonItem+Closures.swift
//  MeMailer5000
//
//  Created by Alex Brashear on 3/10/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit

/**
 A closure that takes a `UIBarButtonItem`. To be used with the convenience
 initializers in the following extension.
 
 - parameter sender: the `UIBarButtonItem` tapped.
 */
public typealias BarButtonItemTapHandlerTarget = (_ sender: UIBarButtonItem) -> Void

public extension UIBarButtonItem {
    
    /**
     Create a new instance of `UIBarButtonItem`.
     
     - parameter title: The title of the bar button item.
     - parameter style: the style of the bar button item.
     - parameter block: a block to run when the bar button item is tapped.
     */
    public convenience init(title: String?, style: UIBarButtonItemStyle, block: @escaping BarButtonItemTapHandlerTarget) {
        let target = BarButtonItemBlockTarget(block: block)
        self.init(title: title, style: style, target: target, action: #selector(BarButtonItemBlockTarget.action))
        objc_setAssociatedObject(self, &AssociatedKeys.TargetBlock, target, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    /**
     Create a new instance of `UIBarButtonItem`.
     
     - parameter barButtonSystemItem: the `UIBarButtonSystemItem` to use.
     - parameter block: a block to run when the bar button item is tapped.
     */
    public convenience init(barButtonSystemItem systemItem: UIBarButtonSystemItem, block: @escaping BarButtonItemTapHandlerTarget) {
        let target = BarButtonItemBlockTarget(block: block)
        self.init(barButtonSystemItem: systemItem, target: target, action: #selector(BarButtonItemBlockTarget.action))
        objc_setAssociatedObject(self, &AssociatedKeys.TargetBlock, target, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }

    
    private struct AssociatedKeys {
        static var TargetBlock: String = "BarButtonItemTargetWithBlock.TargetBlock"
    }
    
}

final private class BarButtonItemBlockTarget: NSObject {
    
    let block: BarButtonItemTapHandlerTarget
    
    init(block: @escaping BarButtonItemTapHandlerTarget) {
        self.block = block
    }
    
    @objc func action(_ sender: UIBarButtonItem) {
        self.block(sender)
    }
}
