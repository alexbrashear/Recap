//
//  ViewController.swift
//  MeMailer5000
//
//  Created by Alex Brashear on 1/28/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit
import AVFoundation

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
    
    // MARK: - IBOutlets
    
    @IBOutlet fileprivate var captureView: UIView!
    @IBOutlet fileprivate var takePhoto: UIButton!
    @IBOutlet fileprivate var deletePhoto: UIButton!
    @IBOutlet fileprivate var keepPhoto: UIButton!
    
    var imageView = UIImageView()
    
    var session = AVCaptureSession()
    var stillImageOutput: AVCapturePhotoOutput?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        session.sessionPreset = AVCaptureSessionPresetPhoto
        
        let backCamera = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        var input: AVCaptureDeviceInput!
        do {
            input = try AVCaptureDeviceInput(device: backCamera)
        } catch let error as NSError {
            assertionFailure(error.localizedDescription)
        }
        
        if session.canAddInput(input) {
            session.addInput(input)
            // ...
            // The remainder of the session setup will go here...
            stillImageOutput = AVCapturePhotoOutput()
//            stillImageOutput?.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
        }
        
        if session.canAddOutput(stillImageOutput) {
            session.addOutput(stillImageOutput)
            // ...
            // Configure the Live Preview here...
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
            videoPreviewLayer!.videoGravity = AVLayerVideoGravityResizeAspectFill
            captureView.layer.addSublayer(videoPreviewLayer!)
            session.startRunning()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        videoPreviewLayer?.frame = captureView.frame
        view.layer.insertSublayer(takePhoto.layer, above: captureView.layer)
        view.layer.insertSublayer(keepPhoto.layer, above: captureView.layer)
        view.layer.insertSublayer(deletePhoto.layer, above: captureView.layer)
        
        displayButtons(forState: state)
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
    
    // MARK: - AVCapturePhotoSettings
    
    fileprivate var capturePhotoSettings: AVCapturePhotoSettings {
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecJPEG])
        return settings
    }
    
    private func displayButtons(forState state: State) {
        switch state {
        case .takePicture:
            takePhoto.isHidden = false
            keepPhoto.isHidden = true
            deletePhoto.isHidden = true
        case .viewPicture:
            takePhoto.isHidden = true
            keepPhoto.isHidden = false
            deletePhoto.isHidden = false
        }
    }
}

// MARK: - IBAction's

extension CameraViewController {
    @IBAction func didTakePhoto(_ sender: UIButton) {
        stillImageOutput?.capturePhoto(with: capturePhotoSettings, delegate: self)
    }
    
    @IBAction func didKeepPhoto(_ sender: UIButton) {
        let storyBoard = UIStoryboard(name: "AddressList", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "AddressListController")
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func didDeletePhoto(_ sender: UIButton) {
        state = .takePicture
    }
}

// MARK: - AVCapturePhotoCaptureDelegate

extension CameraViewController: AVCapturePhotoCaptureDelegate {
    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        guard let buffer = photoSampleBuffer else {
            return assertionFailure("unable to unwrap photo buffer")
        }
        let imageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: buffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer)
        let image = UIImage(data: imageData!)
        imageView.frame = captureView.frame
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = image
        
        state = .viewPicture
    }
}
