//
//  PurchaseViewController.swift
//  Recap
//
//  Created by Alex Brashear on 5/31/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit

typealias BuyFilmAction = (_ capacity: Int) -> Void
typealias PaymentInformationAction = () -> Void

protocol PurchaseViewModelProtocol: class {
    var buyFilm: BuyFilmAction { get }
    var paymentInformation: PaymentInformationAction { get }
}

class PurchaseViewController: UIViewController {

    @IBOutlet private var message: UILabel!
    @IBOutlet private var productDescription: UILabel!
    @IBOutlet private var decrement: UIButton!
    @IBOutlet private var increment: UIButton!
    @IBOutlet private var filmCount: UILabel!
    @IBOutlet private var individualPrice: UILabel!
    @IBOutlet private var totalPrice: UILabel!
    @IBOutlet private var buyFilm: UIButton!
    @IBOutlet private var paymentInformation: UIButton!
    @IBOutlet private var paymentIcon: UIView!
    
    var customPaymentIcon: UIView?
    
    var viewModel: PurchaseViewModelProtocol?
    
    private var currentFilmCount: Int = 1
    private var filmPrice: Int = 8
    private let capacity = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filmCount.text = "\(1)"
        totalPrice.text = "$\(filmPrice)"
        message.text = "Get photos of your everyday adventures - all for less than a burrito 🌯."
        
        message.font = UIFont.openSansFont(ofSize: 16)
        productDescription.font = UIFont.openSansSemiBoldFont(ofSize: 16)
        individualPrice.font = UIFont.openSansBoldFont(ofSize: 12)
        totalPrice.font = UIFont.openSansFont(ofSize: 20)
        filmCount.font = UIFont.openSansBoldFont(ofSize: 20)
        
        buyFilm.titleLabel?.font = UIFont.openSansBoldFont(ofSize: 20)
        buyFilm.on(.touchUpInside) { [unowned self] _ in
            self.viewModel?.buyFilm(self.capacity)
        }
        
        increment.on(.touchUpInside) { [unowned self] _ in
            self.syncSetCurrentFilmCount(increment: true)
        }
        decrement.on(.touchUpInside) { [unowned self] _ in
            self.syncSetCurrentFilmCount(increment: false)
        }
        
        paymentInformation.on(.touchUpInside) { [unowned self] _ in
            self.viewModel?.paymentInformation()
        }
        
        NotificationCenter.default.addObserver(forName: PaymentsNotification.methodSelected, object: nil, queue: .main) { [weak self] notification in
            guard let iconView = notification.userInfo?[PaymentsNotification.paymentIconKey] as? UIView,
                  let description = notification.userInfo?[PaymentsNotification.paymentDescriptionKey] as? String else { return }
            self?.customPaymentIcon = PaymentIconView(icon: iconView, description: description)
            self?.didReceivePaymentIcon()
        }
        
        setBuyFilmEnabled(false)
    }
    
    private func didReceivePaymentIcon() {
        customPaymentIcon?.removeFromSuperview()
        
        if let customIcon = customPaymentIcon {
            paymentIcon.isHidden = false
            paymentIcon.addSubview(customIcon)
            customIcon.constrainToSuperview()
            setBuyFilmEnabled(true)
        } else {
            paymentIcon.isHidden = true
            setBuyFilmEnabled(false)
        }
    }
    
    private func setBuyFilmEnabled(_ enabled: Bool) {
        buyFilm.isEnabled = enabled
        let color = enabled ? UIColor.butterscotch : UIColor.rcpBlueyGrey
        buyFilm.setBackgroundImage(color.singlePixelImage(), for: .normal)
    }
    
    func syncSetCurrentFilmCount(increment: Bool) {
        synced(self) {
            let count = increment ? self.currentFilmCount + 1 : self.currentFilmCount - 1
            guard count > 0 else { return }
            filmCount.text = "\(count)"
            totalPrice.text = "$\(count * filmPrice)"
            self.currentFilmCount = count
        }
    }
}

func synced(_ lock: Any, closure: () -> ()) {
    objc_sync_enter(lock)
    closure()
    objc_sync_exit(lock)
}
