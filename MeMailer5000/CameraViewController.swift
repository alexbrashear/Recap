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
    
    @IBOutlet private var captureView: UIView!
    
    private var takePhoto = UIButton()
    
    var session = AVCaptureSession()
    var stillImageOutput: AVCapturePhotoOutput?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
            videoPreviewLayer!.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
            captureView.layer.addSublayer(videoPreviewLayer!)
            session.startRunning()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        videoPreviewLayer!.frame = captureView.frame
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
