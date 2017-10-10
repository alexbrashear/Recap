//
//  UIColor+Images.swift
//  Recap
//
//  Created by Alex Brashear on 10/10/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit

/// An extension to simplify creating images from colors
extension UIColor {
    /// Creates a single pixel image from the color
    ///
    /// - Returns: A single pixel `UIImage` of the color
    func singlePixelImage() -> UIImage? {
        let size = CGSize(width: 1, height: 1)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        set()
        UIRectFill(CGRect(origin: .zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
