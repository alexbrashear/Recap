//
//  ViewController.swift
//  MeMailer5000
//
//  Created by Alex Brashear on 1/28/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit
import AVFoundation
import PKHUD

protocol CameraViewModelProtocol {    
    var sentPostcardsTapHandler: SentPostcardsTapHandler { get }
    
    var showSettings: () -> Void { get }
    
    var sendPhoto: SendPhoto { get }
    
    var initialCount: Int { get }
    
    var countAction: CountAction { get }
}

class CameraViewController: UIViewController {
    
    var viewModel: CameraViewModelProtocol?
    let overlay = CameraOverlayView.loadFromNib()
    var photoTakenView: PhotoTakenView?
    let filterProvider = FilterProvider()
    let context = CIContext(options: nil)
    var pinchGesture = UIPinchGestureRecognizer()
    @IBOutlet fileprivate var captureView: UIView!
    fileprivate var cameraPosition: AVCaptureDevicePosition = .back
    
    var imageView = UIImageView()
    
    var session = AVCaptureSession()
    var stillImageOutput: AVCapturePhotoOutput?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    var currentDevice: AVCaptureDevice?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        loadCamera(atPosition: .back)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureCameraView()
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let viewModel = viewModel else { fatalError() }
        let rotateCamera: RotateCamera = { [weak self] in self?.switchCamera() }
        let takePhoto: TakePhoto = { [weak self] flashMode in self?.takePhoto(withFlashMode: flashMode) }
        let vm = CameraOverlayViewModel(initialCount: viewModel.initialCount,
                                        takePhoto: takePhoto,
                                        showSettings: viewModel.showSettings,
                                        sentPostcardsTapHandler: viewModel.sentPostcardsTapHandler,
                                        rotateCamera: rotateCamera,
                                        sendPhoto: { image in
                                            viewModel.sendPhoto(image)
                                        },
                                        countAction: viewModel.countAction)
        view.addSubview(overlay)
        overlay.constrainToSuperview()
        overlay.viewModel = vm
        
        self.pinchGesture = UIPinchGestureRecognizer(target: self, action:#selector(pinch(_:)))
        overlay.addGestureRecognizer(self.pinchGesture)
    }
    
    fileprivate func capturePhotoSettings(flashMode: AVCaptureFlashMode) -> AVCapturePhotoSettings {
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecJPEG])
        #if (!arch(x86_64))
        settings.flashMode = stillImageOutput?.supportedFlashModes.contains(NSNumber(value: flashMode.rawValue)) ?? false ? flashMode : .off
        #endif
        return settings
    }
    
    fileprivate func configureCameraView() {
        videoPreviewLayer?.frame = captureView.frame
    }
    
    fileprivate func loadCamera(atPosition position: AVCaptureDevicePosition) {
        #if (!arch(x86_64))
        let camera = AVCaptureDevice.defaultDevice(withDeviceType: .builtInWideAngleCamera, mediaType: AVMediaTypeVideo, position: position)
        currentDevice = camera
        
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
            cameraPosition = position
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
            videoPreviewLayer!.videoGravity = AVLayerVideoGravityResizeAspectFill
            captureView.layer.addSublayer(videoPreviewLayer!)
            session.startRunning()
        }
        #endif
    }
    
    func takePhoto(withFlashMode flashMode: AVCaptureFlashMode) {
        #if (!arch(x86_64))
        stillImageOutput?.capturePhoto(with: capturePhotoSettings(flashMode: flashMode), delegate: self)
        #endif
    }

    func switchCamera() {
        if cameraPosition == .back { loadCamera(atPosition: .front) }
        else { loadCamera(atPosition: .back) }
        configureCameraView()
    }
    
    func deletePhoto() {
        photoTakenView?.removeFromSuperview()
    }
    
    func savePhoto(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image.fixOrientation(), self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        PKHUD.sharedHUD.contentView = UIView()
        PKHUD.sharedHUD.show()
    }
    
    func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            PKHUD.sharedHUD.hide()
            let alert = UIAlertController.okAlert(title: "Sorry we couldn't save your photo", message: "Check your settings to make sure you've given Recap access to your photo library.")
            present(alert, animated: true, completion: nil)
        } else {
            PKHUD.sharedHUD.contentView = SimpleImageLabelAlert.successfulSave
            PKHUD.sharedHUD.show()
            PKHUD.sharedHUD.hide(afterDelay: 3.0)
        }
    }
    
    
    func returnToCamera() {
        self.photoTakenView?.removeFromSuperview()
    }
}

// MARK: - AVCapturePhotoCaptureDelegate

extension CameraViewController: AVCapturePhotoCaptureDelegate {
    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        guard let buffer = photoSampleBuffer else {
            return assertionFailure("unable to unwrap photo buffer")
        }
        guard let imageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: buffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer),
            let base = UIImage(data: imageData),
            let ciImage = CIImage(image: base) else { return }
        
        // need to preserve original scale and orientation to initialize with later
        let orientation = base.imageOrientation
        let scale = base.scale
        
        // apply filter and create CGImage
        let filteredCIImage = filterProvider.applyFilter(toImage: ciImage)
        let cgImage = context.createCGImage(filteredCIImage, from: filteredCIImage.extent)
        let filteredImage = UIImage(cgImage: cgImage!, scale: scale, orientation: cameraPosition == .front ? .leftMirrored : orientation)
        
        // create and overlay photo taken view
        let photoTakenView = PhotoTakenView(frame: .zero, image: filteredImage)
        view.addSubview(photoTakenView)
        photoTakenView.constrainToSuperview()
        photoTakenView.viewModel = PhotoTakenViewModel(
            sendPhoto: { [weak self] image in self?.viewModel?.sendPhoto(image)},
            deletePhotoAction: { [weak self] in self?.deletePhoto() },
            savePhotoAction: { [weak self] image in self?.savePhoto(image: image)}
        )
        self.photoTakenView = photoTakenView
    }
}

// MARK: - Pinch to zoom

extension CameraViewController {
    func pinch(_ pinch: UIPinchGestureRecognizer) {
        guard let device = currentDevice else { return }
        
        let minimumZoom: CGFloat = 1.0
        let maximumZoom: CGFloat = 3.0
        var lastZoomFactor: CGFloat = 1.0
        
        // Return zoom value between the minimum and maximum zoom values
        func minMaxZoom(_ factor: CGFloat) -> CGFloat {
            return min(min(max(factor, minimumZoom), maximumZoom), device.activeFormat.videoMaxZoomFactor)
        }
        
        func update(scale factor: CGFloat) {
            do {
                try device.lockForConfiguration()
                defer { device.unlockForConfiguration() }
                device.videoZoomFactor = factor
            } catch {
                print("\(error.localizedDescription)")
            }
        }
        
        let newScaleFactor = minMaxZoom(pinch.scale * lastZoomFactor)
        
        switch pinch.state {
        case .began:
            fallthrough
        case .changed:
            update(scale: newScaleFactor)
        case .ended:
            lastZoomFactor = minMaxZoom(newScaleFactor)
            update(scale: lastZoomFactor)
        default:
            break
        }
    }
}

extension UIImage {
    /// Used for saving a photo to your library - adjusts the image to the appropriate orientation
    func fixOrientation() -> UIImage {
        if self.imageOrientation == UIImageOrientation.up {
            return self
        }
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        if let normalizedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            return normalizedImage
        } else {
            return self
        }
    }
}
