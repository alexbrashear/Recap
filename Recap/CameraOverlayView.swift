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

protocol CameraOverlayViewModelProtocol: class {
    var rotateCamera: RotateCamera { get }
    
    var takePhoto: TakePhoto { get }
    
    var sentPostcardsTapHandler: SentPostcardsTapHandler { get }
    
    var showSettings: () -> Void { get }
}

class CameraOverlayView: UIView, NibLoadable {

    @IBOutlet private var settings: UIButton!
    @IBOutlet private var flash: UIButton!
    @IBOutlet private var rotateCamera: UIButton!
    @IBOutlet private var takePhoto: UIButton!
    @IBOutlet private var sentPostcards: UIButton!
    @IBOutlet private var count: UILabel!
    
    var flashMode: AVCaptureFlashMode = .auto
    
    var viewModel: CameraOverlayViewModelProtocol? {
        didSet {
            settings.on(.touchUpInside) { [unowned self] _ in
                self.viewModel?.showSettings()
            }
            
            rotateCamera.on(.touchUpInside) { [unowned self] _ in
                self.viewModel?.rotateCamera()
            }
            
            takePhoto.on(.touchUpInside) { [unowned self] _ in
                self.viewModel?.takePhoto(self.flashMode)
            }
            
            flash.on(.touchUpInside) { [unowned self] _ in
                self.toggleFlash()
            }
            
            sentPostcards.on(.touchUpInside) { [unowned self] _ in
                self.viewModel?.sentPostcardsTapHandler()
            }
        }
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
        count.font = UIFont.openSansBoldFont(ofSize: 20)
        count.layer.cornerRadius = 15.0
        count.clipsToBounds = true
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
