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
    
    // MARK: - IBOutlets
    
    @IBOutlet fileprivate var captureView: UIView!
    @IBOutlet fileprivate var takePhoto: UIButton!
    
    @IBOutlet fileprivate var deletePhoto: UIButton!
    @IBOutlet fileprivate var keepPhoto: UIButton!
    let imageView = UIImageView()
    
    var session = AVCaptureSession()
    var stillImageOutput: AVCapturePhotoOutput?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        keepPhoto.isHidden = true
        deletePhoto.isHidden = true
        
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
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func didTakePhoto(_ sender: UIButton) {
        stillImageOutput?.capturePhoto(with: capturePhotoSettings, delegate: self)
    }
    
    @IBAction func didKeepPhoto(_ sender: UIButton) {
        
    }
    
    @IBAction func didDeletePhoto(_ sender: UIButton) {
        captureView.layer.replaceSublayer(imageView.layer, with: videoPreviewLayer!)
        imageView.image = nil
        takePhoto.isHidden = false
        keepPhoto.isHidden = true
        deletePhoto.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - AVCapturePhotoSettings
    
    private var capturePhotoSettings: AVCapturePhotoSettings {
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecJPEG])
        return settings
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
        imageView.image = image
        captureView.layer.replaceSublayer(videoPreviewLayer!, with: imageView.layer)
        
        // hide take photo button
        takePhoto.isHidden = true
        
        // show keep or delete buttons
        keepPhoto.isHidden = false
        deletePhoto.isHidden = false
    }
}
