//
//  ViewController.swift
//  MeMailer5000
//
//  Created by Alex Brashear on 1/28/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit
import AVFoundation

protocol CameraViewModelProtocol {
    var keepPhoto: KeepPhotoTapHandler { get }
    
    var sentPostcardsTapHandler: SentPostcardsTapHandler { get }
}

class CameraViewController: UIViewController {
    
    enum State {
        case takePicture
        case viewPicture
    }
    
    fileprivate(set) var state: State = .takePicture {
        didSet {
            if oldValue == .viewPicture {
                captureView.layer.replaceSublayer(imageView.layer, with: videoPreviewLayer!)
                imageView.image = nil
            } else {
                captureView.layer.replaceSublayer(videoPreviewLayer!, with: imageView.layer)
            }
            displayButtons(forState: state)
        }
    }
    
    var viewModel: CameraViewModelProtocol?

    // MARK: - IBOutlets

    @IBOutlet fileprivate var flash: UIButton!
    @IBOutlet fileprivate var captureView: UIView!
    @IBOutlet fileprivate var takePhoto: UIButton!
    @IBOutlet fileprivate var deletePhoto: UIButton!
    @IBOutlet fileprivate var keepPhoto: UIButton!
    @IBOutlet fileprivate var postcards: UIButton!
    @IBOutlet fileprivate var switchCamera: UIButton!
    
    fileprivate var flashMode: AVCaptureFlashMode = .auto
    fileprivate var cameraPosition: AVCaptureDevicePosition = .back
    
    var imageView = UIImageView()
    
    var session = AVCaptureSession()
    var stillImageOutput: AVCapturePhotoOutput?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
                
        loadCamera(atPosition: .back)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureCameraView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
        super.viewWillDisappear(animated)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    fileprivate var capturePhotoSettings: AVCapturePhotoSettings {
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecJPEG])
        settings.flashMode = stillImageOutput?.supportedFlashModes.contains(NSNumber(value: flashMode.rawValue)) ?? false ? flashMode : .off
        return settings
    }
    
    fileprivate func configureCameraView() {
        videoPreviewLayer?.frame = captureView.frame
        view.layer.insertSublayer(takePhoto.layer, above: captureView.layer)
        view.layer.insertSublayer(keepPhoto.layer, above: captureView.layer)
        view.layer.insertSublayer(deletePhoto.layer, above: captureView.layer)
        view.layer.insertSublayer(postcards.layer, above: captureView.layer)
        view.layer.insertSublayer(flash.layer, above: captureView.layer)
        view.layer.insertSublayer(switchCamera.layer, above: captureView.layer)
        
        displayButtons(forState: state)
    }
    
    private func displayButtons(forState state: State) {
        switch state {
        case .takePicture:
            takePhoto.isHidden = false
            keepPhoto.isHidden = true
            deletePhoto.isHidden = true
            postcards.isHidden = false
            flash.isHidden = false
            switchCamera.isHidden = false
        case .viewPicture:
            takePhoto.isHidden = true
            keepPhoto.isHidden = false
            deletePhoto.isHidden = false
            postcards.isHidden = true
            flash.isHidden = true
            switchCamera.isHidden = true
        }
    }
    
    fileprivate func loadCamera(atPosition position: AVCaptureDevicePosition) {
        let camera = AVCaptureDevice.defaultDevice(withDeviceType: .builtInWideAngleCamera, mediaType: AVMediaTypeVideo, position: position)
        
        if camera == nil {
            print("turds")
        }
        
        if session.isRunning {
            session.stopRunning()
            videoPreviewLayer?.removeFromSuperlayer()
            session = AVCaptureSession()
        }
        
        var input: AVCaptureDeviceInput!
        do {
            input = try AVCaptureDeviceInput(device: camera)
        } catch let error as NSError {
            assertionFailure(error.localizedDescription)
        }
        
        if session.canAddInput(input) {
            session.addInput(input)
            // ...
            stillImageOutput = AVCapturePhotoOutput()
        }
        
        if session.canAddOutput(stillImageOutput) {
            session.addOutput(stillImageOutput)
            // ...
            // Configure the Live Preview here...
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
            videoPreviewLayer!.videoGravity = AVLayerVideoGravityResizeAspectFill
            captureView.layer.addSublayer(videoPreviewLayer!)
            session.startRunning()
        } else if !session.outputs.isEmpty && state == .takePicture {
            captureView.layer.addSublayer(videoPreviewLayer!)
        }
        cameraPosition = position
    }
}

// MARK: - IBAction's

extension CameraViewController {
    @IBAction func didTakePhoto(_ sender: UIButton) {
        stillImageOutput?.capturePhoto(with: capturePhotoSettings, delegate: self)
    }
    
    @IBAction func didKeepPhoto(_ sender: UIButton) {
        viewModel?.keepPhoto(imageView.image)
    }
    
    @IBAction func didDeletePhoto(_ sender: UIButton) {
        state = .takePicture
    }
    
    @IBAction func didRequestPostcards(_ sender: UIButton) {
        viewModel?.sentPostcardsTapHandler()
    }
    
    @IBAction func didToggleFlash( _ sender: UIButton) {
        switch flashMode {
        case .auto, .off:
            flashMode = .on
        case .on:
            flashMode = .off
        }
        flash.setTitle(flashMode.buttonText, for: .normal)
    }
    
    @IBAction func didSwitchCamera(_ sender: UIButton) {
        if cameraPosition == .back { loadCamera(atPosition: .front) }
        else { loadCamera(atPosition: .back) }
        configureCameraView()
    }
}

// MARK: - AVCapturePhotoCaptureDelegate

extension CameraViewController: AVCapturePhotoCaptureDelegate {
    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        guard let buffer = photoSampleBuffer else {
            return assertionFailure("unable to unwrap photo buffer")
        }
        guard let imageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: buffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer),
            var image = UIImage(data: imageData) else { return }
        
        imageView.frame = captureView.frame
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        if let cgImage = image.cgImage, cameraPosition == .front {
            image = UIImage(cgImage: cgImage, scale: image.scale, orientation:.leftMirrored)
        }
        imageView.image = image
        
        state = .viewPicture
    }
}

extension AVCaptureFlashMode {
    var buttonText: String {
        switch self {
        case .auto:
            return "auto"
        case .off:
            return "off"
        case .on:
            return "on"
        }
    }
}
