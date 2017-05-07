//
//  ErrorAlertViewModel.swift
//  Recap
//
//  Created by Alex Brashear on 5/6/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit

class ErrorAlertViewModel: SimpleImageLabelAlertViewModelProtocol {
    var title: NSAttributedString
    var subtitle: NSAttributedString?
    var accessory: UIImage?
    var background: UIColor = .rcpGoldenYellow
    var kind: SimpleImageLabelAlert.Kind = .twoLine
    
    init() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        title = NSAttributedString(string: "Sorry, we couldn’t send your Recap",
                                   attributes: [NSFontAttributeName: UIFont.openSansSemiBoldFont(ofSize: 16),
                                                NSForegroundColorAttributeName: UIColor.white])
        subtitle = NSAttributedString(string: "Check your history to resend",
                                   attributes: [NSFontAttributeName: UIFont.openSansSemiBoldFont(ofSize: 16),
                                                NSForegroundColorAttributeName: UIColor.white,
                                                NSParagraphStyleAttributeName: paragraphStyle])
    }
}
