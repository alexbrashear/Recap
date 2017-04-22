//
//  UIButton+Closures.swift
//  Recap
//
//  Created by Alex Brashear on 4/21/17.
//  Copyright © 2017 memailer. All rights reserved.
//
//

import UIKit

public typealias ButtonTapHandler = (UIButton) -> Void

public extension UIButton {
    
    private struct AssociatedKeys {
        static var TargetBlock: String = "TargetBlock"
    }
    
    public func on(_ controlEvents: UIControlEvents, perform block: @escaping ButtonTapHandler) {
        let target = ButtonBlockTarget(buttonTapHandler: block)
        self.addTarget(target, action: #selector(target.action), for: controlEvents)
        objc_setAssociatedObject(self, &AssociatedKeys.TargetBlock, target, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}

final private class ButtonBlockTarget {
    let buttonTapHandler: ButtonTapHandler
    
    init(buttonTapHandler: @escaping ButtonTapHandler) {
        self.buttonTapHandler = buttonTapHandler
    }
    
    @objc func action(_ sender: UIButton) {
        buttonTapHandler(sender)
    }
}
