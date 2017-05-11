//
//  RecapSentViewModel.swift
//  Recap
//
//  Created by Alex Brashear on 5/6/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit

class PositiveAlertViewModel: SimpleImageLabelAlertViewModelProtocol {
    var title: NSAttributedString
    var subtitle: NSAttributedString?
    var accessory: UIImage?
    var kind: SimpleImageLabelAlert.Kind = .oneLineImage
    var background: UIColor = .rcpClearBlueTwo
    
    init(title: String, image: UIImage?) {
        self.title = NSAttributedString(
                        string: title,
                        attributes: [NSFontAttributeName: UIFont.openSansSemiBoldFont(ofSize: 16),
                                     NSForegroundColorAttributeName: UIColor.white]
                    )
        
        accessory = image
    }
}
