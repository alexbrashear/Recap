//
//  EnterAddressController.swift
//  Recap
//
//  Created by Alex Brashear on 4/19/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit

typealias NextAction = (_ address: Address) -> Void

protocol EnterAddressViewModelProtocol: class {
    var heading: NSAttributedString { get }
    var subheading: NSAttributedString { get }
    var buttonText: NSAttributedString { get }
    var backAction: () -> Void { get }
    var nextAction: NextAction { get }
}

class EnterAddressController: UIViewController {

    @IBOutlet var back: UIButton!
    @IBOutlet var heading: UILabel!
    @IBOutlet var subHeading: UILabel!
    @IBOutlet var mainContainer: UIView!
    @IBOutlet var nextButton: UIButton!
    @IBOutlet var scrollView: UIScrollView!
    
    fileprivate let inputAddressView = InputAddressView.loadFromNib()
    
    var viewModel: EnterAddressViewModelProtocol?
    fileprivate var tap: UIGestureRecognizer?
    fileprivate let defaultKeyboardDelta: CGFloat = 20
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unregisterKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainContainer.addSubview(inputAddressView)
        inputAddressView.constrainToSuperview()
        
        mainContainer.layer.cornerRadius = 3.0
        mainContainer.clipsToBounds = true
        
        nextButton.layer.cornerRadius = 5.0
        nextButton.clipsToBounds = true
        
        back.on(.touchUpInside) { [weak self] _ in
            self?.viewModel?.backAction()
        }
        
        nextButton.on(.touchUpInside) { [weak self] _ in
            guard let address = self?.inputAddressView.getAddress() else { return }
            self?.viewModel?.nextAction(address)
        }
        
        heading.font = UIFont.openSansSemiBoldFont(ofSize: 20)
        subHeading.font = UIFont.openSansSemiBoldFont(ofSize: 16)
        nextButton.setAttributedTitle(viewModel?.buttonText, for: .normal)
        
        tap = UITapGestureRecognizer(target: self, action: .dismissKeyboard)
        inputAddressView.setKeyboardToolbar(toolbar: keyboardToolbar())
        let topBar = UIView(frame: UIApplication.shared.statusBarFrame)
        topBar.backgroundColor = UIColor.rcpClearBlueTwo
        view.addSubview(topBar)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension EnterAddressController {
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: .keyboardWillShow, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: .keyboardWillHide, name: .UIKeyboardWillHide, object: nil)
    }
    
    func unregisterKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let tap = self.tap else { return }
        view.addGestureRecognizer(tap)
        guard let keyboardTopPosition = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.minY else {
            return scrollView.contentOffset.y = defaultKeyboardDelta
        }
        let delta = keyboardTopPosition - mainContainer.frame.maxY
        let calculatedPosition = delta > defaultKeyboardDelta ? 0.0 : defaultKeyboardDelta - delta
        scrollView.contentOffset.y = calculatedPosition//min(calculatedPosition, mainContent.lowestPossibleTopPositionWithKeyboard)
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        guard let tap = self.tap else { return }
        view.removeGestureRecognizer(tap)
        scrollView.contentOffset.y = 0.0
    }
    
    @objc func dismissKeyboard() {
        _ = inputAddressView.resignFirstResponder()
    }
    
    @objc func nextField() {
        inputAddressView.goToNextResponder()
    }
    
    @objc func previousField() {
        inputAddressView.goToPreviousResponder()
    }
    
    func keyboardToolbar() -> UIToolbar {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        toolbar.barStyle = UIBarStyle.default
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(EnterAddressController.dismissKeyboard))
        let previous = UIBarButtonItem(title: "Previous", style: UIBarButtonItemStyle.done, target: self, action: #selector(EnterAddressController.previousField))
        let next = UIBarButtonItem(title: "Next", style: UIBarButtonItemStyle.done, target: self, action: #selector(EnterAddressController.nextField))
        
        var items = [UIBarButtonItem]()
        items.append(previous)
        items.append(next)
        items.append(flexSpace)
        items.append(done)
        
        toolbar.items = items
        toolbar.sizeToFit()
        return toolbar
    }
}

private extension Selector {
    static let dismissKeyboard = #selector(EnterAddressController.dismissKeyboard)
    
    static let keyboardWillShow = #selector(EnterAddressController.keyboardWillShow(_:))
    static let keyboardWillHide = #selector(EnterAddressController.keyboardWillHide(_:))
}
