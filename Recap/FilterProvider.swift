//
//  FilterProvider.swift
//  Recap
//
//  Created by Alex Brashear on 7/3/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit

class FilterProvider {
    
    func applyFilter(toImage base: CIImage) -> CIImage {
        guard let colorFilter = CIFilter(name: "CIColorControls") else { return base }
        
        colorFilter.setValue(base, forKey: kCIInputImageKey)
        colorFilter.setValue(1.2, forKey: "inputSaturation")
//        colorFilter.setValue(0.2, forKey: "inputBrightness")
        
        return colorFilter.outputImage ?? base
    }
}


