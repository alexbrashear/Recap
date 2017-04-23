//
//  DisclaimerController.swift
//  Recap
//
//  Created by Alex Brashear on 4/22/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit

typealias DisclaimerAction = () -> Void

typealias TermsAndConditionsAction = () -> Void

protocol DisclaimerViewModelProtocol: class {
    var disclaimerAction: DisclaimerAction { get }
    
    var termsAndConditionsAction: TermsAndConditionsAction { get }
}

class DisclaimerViewModel: DisclaimerViewModelProtocol {
    var disclaimerAction: DisclaimerAction
    
    var termsAndConditionsAction: TermsAndConditionsAction
    
    init(disclaimerAction: @escaping DisclaimerAction, termsAndConditionsAction: @escaping TermsAndConditionsAction) {
        self.disclaimerAction = disclaimerAction
        self.termsAndConditionsAction = termsAndConditionsAction
    }
}

class DisclaimerController: UIViewController {

    @IBOutlet var heading: UILabel!
    @IBOutlet var body: UILabel!
    @IBOutlet var nextButton: UIButton!
    @IBOutlet var termsAndConditions: UIButton!
    
    var viewModel: DisclaimerViewModelProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        heading.font = UIFont.openSansSemiBoldFont(ofSize: 28)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let attributedBody = NSMutableAttributedString(string: "Your Recaps will come in the mail bare (AKA not in an envelope).\n\nThis means your Recaps will be visible to your local post person and roommates.\n\nSo please keep it clean (no nudity, drugs, illegal street fighting, etc.).",
                                                attributes: [NSFontAttributeName: UIFont.openSansSemiBoldFont(ofSize: 16),
                                                             NSForegroundColorAttributeName: UIColor.white,
                                                             NSParagraphStyleAttributeName: paragraphStyle])
        let range = (attributedBody.string as NSString).range(of: "your Recaps will be visible to your local post person and roommates.")
        attributedBody.addAttribute(NSFontAttributeName, value: UIFont.openSansBoldFont(ofSize: 16), range: range)
        attributedBody.addAttribute(NSForegroundColorAttributeName, value: UIColor.butterscotch, range: range)
        
        body.attributedText = attributedBody
        
        nextButton.titleLabel?.font = UIFont.openSansBoldFont(ofSize: 20)
        nextButton.layer.cornerRadius = 5.0
        nextButton.clipsToBounds = true
        nextButton.on(.touchUpInside) { [weak self] _ in
            self?.viewModel?.disclaimerAction()
        }
        
        termsAndConditions.titleLabel?.font = UIFont.openSansFont(ofSize: 12)
        termsAndConditions.on(.touchUpInside) { [weak self] _ in
            self?.viewModel?.termsAndConditionsAction()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
