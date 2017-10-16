//
//  CameraOverlayView.swift
//  Recap
//
//  Created by Alex Brashear on 4/23/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit
import Reusable
import AVFoundation

typealias RotateCamera = () -> Void

typealias TakePhoto = (_ flashMode: AVCaptureFlashMode) -> Void

typealias CountAction = () -> Void

protocol CameraOverlayViewModelProtocol: class {
    var rotateCamera: RotateCamera? { get set }
    var takePhoto: TakePhoto? { get set }
    var sentPostcardsTapHandler: SentPostcardsTapHandler { get }
    var showSettings: () -> Void { get }
    var countAction: CountAction { get }
    var count: Int { get }
}

class CameraOverlayView: UIView, NibLoadable {

    @IBOutlet private var settings: UIButton!
    @IBOutlet private var flash: UIButton!
    @IBOutlet private var rotateCamera: UIButton!
    @IBOutlet private var takePhoto: UIButton!
    @IBOutlet private var sentPostcards: UIButton!
    @IBOutlet private var count: UIButton!
    @IBOutlet private var refill: UIButton!
    
    var flashMode: AVCaptureFlashMode = .auto
    
    var viewModel: CameraOverlayViewModelProtocol? {
        didSet {
            settings.on(.touchUpInside) { [unowned self] _ in
                self.viewModel?.showSettings()
            }
            
            rotateCamera.on(.touchUpInside) { [unowned self] _ in
                self.viewModel?.rotateCamera?()
            }
            
            takePhoto.on(.touchUpInside) { [unowned self] _ in
                self.viewModel?.takePhoto?(self.flashMode)
            }
            
            flash.on(.touchUpInside) { [unowned self] _ in
                self.toggleFlash()
            }
            
            sentPostcards.on(.touchUpInside) { [unowned self] _ in
                self.viewModel?.sentPostcardsTapHandler()
            }
            
            refill.on(.touchUpInside) { [unowned self] _ in
                self.viewModel?.countAction()
            }
            
            count.on(.touchUpInside) { [unowned self] _ in
                self.viewModel?.countAction()
            }
            
            updateCount()
        }
    }
    
    private func updateCount() {
        guard let viewModel = viewModel else { return }
        let newCount = viewModel.count
        count.setTitle("\(newCount)", for: .normal)
        refill.isHidden = newCount > 0
        takePhoto.isEnabled = newCount > 0
        count.backgroundColor = newCount > 0 ? .white : .rcpGoldenYellow
    }
    
    func toggleFlash() {
        switch flashMode {
        case .auto, .on:
            flashMode = .off
        case .off:
            flashMode = .on
        }
        flash.setImage(flashMode.image, for: .normal)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        count.titleLabel?.font = UIFont.openSansBoldFont(ofSize: 20)
        count.layer.cornerRadius = 17.5
        count.clipsToBounds = true
        
        refill.titleLabel?.font = UIFont.openSansBoldFont(ofSize: 12)
        refill.setTitleColor(.rcpGoldenYellow, for: .normal)
        
        NotificationCenter.default.addObserver(forName: UserNotification.userDidUpdate, object: nil, queue: .main) { [weak self] _ in
            self?.updateCount()
        }
    }
}

extension AVCaptureFlashMode {
    var image: UIImage? {
        switch self {
        case .auto:
            return UIImage(named: "iconFlash")
        case .off:
            return UIImage(named: "iconNoFlash")
        case .on:
            return UIImage(named: "iconFlash")
        }
    }
}
