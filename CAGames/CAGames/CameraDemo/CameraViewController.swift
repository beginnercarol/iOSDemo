//
//  CameraViewController.swift
//  CAGames
//
//  Created by Carol on 2019/5/18.
//  Copyright © 2019 Carol. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
import GLKit

class CameraViewController: UIViewController {
    let session = AVCaptureSession()
    var device: AVCaptureDevice!
    var window: UIView = UIApplication.shared.windows.first!
    var preview: CameraPreview!
    var photoOutput: AVCapturePhotoOutput!
    var deviceInput: AVCaptureDeviceInput!
    var videoOutput: AVCaptureVideoDataOutput!
    
    var captureBtn: UIButton!
    
    var photo: AVCapturePhoto!
    
    var filterSlider: UISlider!
    
    var ciContext: CIContext!
    
    var eaglContext: EAGLContext!
    
    var sepiaFilter: CIFilter?
    
    var sepiaCIImage: CIImage?
    
    var focusView: CameraFocusView!
    
    var videoPreview: GLKView!
    
    var videoPreviewBounds: CGRect!
    
    var filterCollectionView: UICollectionView! {
        return filterCollectionVC.collectionView
    }
    
    var filterCollectionVC: FilterCollectionVC!
    
    var videoCaptureSessionQueue: DispatchQueue!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupEAGLContext()
        setupView()
//        setupCollectionView()
        setupCamera()
    }
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = cellItemSize
        filterCollectionVC = FilterCollectionVC(collectionViewLayout: layout)
        layout.minimumInteritemSpacing = 0
        self.addChild(filterCollectionVC)
        self.view.addSubview(filterCollectionVC.collectionView)
        filterCollectionVC.context = self.eaglContext
    }
    
    func setupView() {
        captureBtn = UIButton(type: .system)
        captureBtn.setTitle("Capture", for: .normal)
        captureBtn.addTarget(self, action: #selector(takePhoto(_:)), for: .touchUpInside)
        self.view.addSubview(captureBtn)
        
        captureBtn.snp.makeConstraints { (make) in
            make.leading.equalTo(view.snp.leading).offset(20)
            make.bottom.equalTo(view.snp.bottom)
        }
        captureBtn.addTarget(self, action: #selector(takePhoto(_:)), for: .touchUpInside)
        filterSlider = UISlider(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        view.addSubview(filterSlider)
        filterSlider.snp.makeConstraints { (make) in
            make.leading.equalTo(captureBtn.snp.trailing).offset(20)
            make.bottom.equalTo(view.snp.bottom)
            make.width.equalTo(200)
        }
        filterSlider.minimumValue = 0.0
        filterSlider.maximumValue = 1.0
        filterSlider.setValue(0.5, animated: false)
        filterSlider.addTarget(self, action: #selector(changeFilterValue(_:)), for: .valueChanged)
        focusView = CameraFocusView(frame: CGRect(x: 100, y: 100, width: 50, height: 35))
        videoPreview.addSubview(focusView)
        focusView.isHidden = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(focusGesture(_:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        self.videoPreview.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func takePhoto(_ sender: UIButton) {
        var photoSettings = AVCapturePhotoSettings()
        
        if self.photoOutput.availableLivePhotoVideoCodecTypes.contains(.hevc) {
            photoSettings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.hevc])
        }
        
        if self.deviceInput.device.isFlashAvailable {
            photoSettings.flashMode = .auto
        }
        
//        photoSettings.isHighResolutionPhotoEnabled = true
        if !photoSettings.__availablePreviewPhotoPixelFormatTypes.isEmpty {
            photoSettings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: photoSettings.__availablePreviewPhotoPixelFormatTypes.first!]
        }
//        if self.livePhotoMode == .on && self.photoOutput.isLivePhotoCaptureSupported { // Live Photo capture is not supported in movie mode.
//            let livePhotoMovieFileName = NSUUID().uuidString
//            let livePhotoMovieFilePath = (NSTemporaryDirectory() as NSString).appendingPathComponent((livePhotoMovieFileName as NSString).appendingPathExtension("mov")!)
//            photoSettings.livePhotoMovieFileURL = URL(fileURLWithPath: livePhotoMovieFilePath)
//        }
//
//        photoSettings.isDepthDataDeliveryEnabled = (self.depthDataDeliveryMode == .on
//            && self.photoOutput.isDepthDataDeliveryEnabled)
//
//        photoSettings.isPortraitEffectsMatteDeliveryEnabled = (self.portraitEffectsMatteDeliveryMode == .on
//            && self.photoOutput.isPortraitEffectsMatteDeliveryEnabled)
//        self.photoOutput.capturePhoto(with: photoSettings, delegate: self)
    }
    
    @objc func changeFilterValue(_ sender: UISlider) {
        
    }

    override var shouldAutorotate: Bool {
        return false
    }
    
    // MARK: -Camera Related
    func setupCamera() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            self.setupSession()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { (granted) in
                if granted {
                    self.setupSession()
                }
            }
        case .denied:
            return
        case .restricted:
            return
        }
    }
    
    func setupSession() {
        session.beginConfiguration()
        guard let device = chooseDevice() else {
            return
        }
        self.device = device
        guard let deviceInput = try? AVCaptureDeviceInput(device: self.device) else {
            return
        }
        self.deviceInput = deviceInput
        if session.canAddInput(deviceInput) {
            session.addInput(deviceInput)
        }
        
        let videoOutput = AVCaptureVideoDataOutput()
        
        let photoOutput = AVCapturePhotoOutput()
        
        if session.canAddOutput(videoOutput) {
            session.addOutput(videoOutput)
            self.videoOutput = videoOutput
        }
        session.sessionPreset = AVCaptureSession.Preset.hd1280x720
        videoCaptureSessionQueue = DispatchQueue(label: "sample buffer delegate")
        self.videoOutput.setSampleBufferDelegate(self, queue: self.videoCaptureSessionQueue)
        session.commitConfiguration()
        session.startRunning()
    }

    func chooseDevice() -> AVCaptureDevice? {
        if let device = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back) {
            return device
        } else if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
            return device
        } else {
            NSLog("No Camera Available")
            return nil
        }
    }
    
    // MARK: - Filter
    func setupEAGLContext() {
        guard let context = try? EAGLContext(api: .openGLES2) else {
            return
        }
        self.eaglContext = context
        videoPreview = GLKView(frame: self.view.bounds, context: self.eaglContext)
        videoPreview.delegate = self
        self.view.addSubview(videoPreview)
        videoPreview.sendSubviewToBack(self.view)
        videoPreview.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2.0)
        //Why need to change frame after transform??
        videoPreview.frame = window.bounds
        videoPreview.bindDrawable()
        videoPreviewBounds = CGRect.zero
        videoPreviewBounds.size.height = CGFloat(videoPreview.drawableHeight)
        videoPreviewBounds.size.width = CGFloat(videoPreview.drawableWidth)
        ciContext = CIContext(eaglContext: self.eaglContext, options: nil)
    }
    
    // MARK: - Focus
    @objc func focusGesture(_ sender: UITapGestureRecognizer) {
        let point = sender.location(in: sender.view)
        self.focusAtPoint(withPoint: point)
    }
    
    func focusAtPoint(withPoint point: CGPoint) {
        let size = self.videoPreviewBounds.size
        let focusPoint = CGPoint(x: point.y/size.height, y: 1-point.x/size.width)
        
        do {
            try self.device.lockForConfiguration()
            if self.device.isFocusModeSupported(.autoFocus) {
                if self.device.isFocusPointOfInterestSupported {
                    self.device.focusPointOfInterest = focusPoint
                }
            }
            if self.device.isExposureModeSupported(.autoExpose) {
                if self.device.isExposurePointOfInterestSupported {
                    self.device.exposurePointOfInterest = focusPoint
                }
            }
            self.device.unlockForConfiguration()
            self.focusView.center = point
            self.focusView.isHidden = false
            UIView.animate(withDuration: 0.3, animations: {
                self.focusView.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
            }) { (success) in
                if success {
                    self.focusView.transform = CGAffineTransform.identity
                    self.focusView.isHidden = true
                }
            }
        } catch let err {
            NSLog("Error: \(err)")
        }
    }
    
    
    
    // MARK: - OpenGL Related
    var Vertices = [
        Vertex(x: 0.5, y: -0.5, z: 0, r: 1, g: 0, b: 0, a: 1),
        Vertex(x: 0.5, y: 0.5, z: 0, r: 0, g: 1, b: 0, a: 1),
        Vertex(x: -0.5, y: 0.5, z: 0, r: 0, g: 0, b: 1, a: 1),
        Vertex(x: -0.5, y: -0.5, z: 0, r: 0, g: 0, b: 0, a: 1)
    ]
    
    var Indices: [GLubyte] = [
        0, 1, 2,
        2, 3, 0
    ]
    
    private var ebo = GLuint()
    private var vbo = GLuint()
    private var vao = GLuint()
    
    func createSquare() {
        let vertexAttribColor = GLuint(GLKVertexAttrib.color.rawValue)
        let vertexAttribPosition = GLuint(GLKVertexAttrib.position.rawValue)
        let vertexSize = MemoryLayout<Vertex>.stride
        let colorOffset = MemoryLayout<GLfloat>.stride*3
        let colorOffsetPointer = UnsafeRawPointer(bitPattern: colorOffset)
        
        glGenVertexArraysOES(1, &vao)
        glBindVertexArrayOES(vao)
        
        glGenBuffers(1, &vbo)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vbo)
        glBufferData(GLenum(GL_ARRAY_BUFFER), Vertices.size(), Vertices, GLenum(GL_STATIC_DRAW))
        glEnableVertexAttribArray(vertexAttribPosition)
        glVertexAttribPointer(vertexAttribPosition, 3, GLenum(GL_FLOAT), GLboolean(UInt8(GL_FALSE)), GLsizei(vertexSize), nil)
        
        glEnableVertexAttribArray(vertexAttribColor)
        glVertexAttribPointer(vertexAttribColor, 4, GLenum(GL_FLOAT), GLboolean(UInt8(GL_FALSE)), GLsizei(vertexSize), colorOffsetPointer)
        
        glGenBuffers(1, &ebo)
        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), ebo)
        glBufferData(GLenum(GL_ELEMENT_ARRAY_BUFFER),
                     Indices.size(),
                     Indices,
                     GLenum(GL_STATIC_DRAW))
        glBindVertexArrayOES(0)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), 0)
        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), 0)

    }
    

}

extension CameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
//        checkForOrientation()
        let imgBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
        let sourceImg = CIImage(cvPixelBuffer: imgBuffer as! CVPixelBuffer, options: nil)
        let extent = sourceImg.extent
        
        let filter = CIFilter(name: "CIVignetteEffect")
        filter?.setValue(sourceImg, forKey: kCIInputImageKey)
        filter?.setValue(CIVector(x: extent.size.width/2, y: extent.size.height/2), forKey: kCIInputCenterKey)
        filter?.setValue(extent.size.width/2, forKey: kCIInputRadiusKey)
        var outputImg = filter?.outputImage
        let effectFilter = CIFilter(name: "CIPhotoEffectInstant")
        effectFilter?.setValue(outputImg, forKey: kCIInputImageKey)
        outputImg = effectFilter?.outputImage

        let sourceAspect = extent.size.width / extent.size.height
        let previewAspect = videoPreviewBounds.width / videoPreviewBounds.height
        var drawRect = extent
        // sourceAspect's height * previewAspect < extent.width, clip center
        if sourceAspect > previewAspect {
            drawRect.origin.x += (drawRect.size.width - drawRect.size.height*previewAspect)/2.0
            drawRect.size.width = drawRect.size.height*previewAspect
        } else {
            //extent width / previewAspect < preview.width, clip center of height
            drawRect.origin.y += (drawRect.size.height - drawRect.size.width/previewAspect)/2.0
            drawRect.size.height = drawRect.size.width/previewAspect
        }
        
        videoPreview.bindDrawable()
        if eaglContext != EAGLContext.current() {
            EAGLContext.setCurrent(eaglContext)
        }
        
        

        
        glClearColor(0.5, 0.5, 0.5, 1.0)
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT))
        glEnable(GLenum(GL_BLEND))
        glBlendFunc(GLenum(GL_ONE), GLenum(GL_ONE_MINUS_SRC_ALPHA))
        
        if let ciImg = outputImg {
            ciContext.draw(ciImg, in: videoPreviewBounds, from: drawRect)
        }
        createSquare()
        var effect = GLKBaseEffect()
        effect.prepareToDraw()
        glBindVertexArrayOES(vao);
        glDrawElements(GLenum(GL_TRIANGLES),     // 1
            GLsizei(Indices.count),   // 2
            GLenum(GL_UNSIGNED_BYTE), // 3
            nil)                      // 4
        glBindVertexArrayOES(0)

        videoPreview.display()
    }
    
    func checkForOrientation() {
        if let connection = videoOutput.connection(with: .video) {
            connection.videoOrientation = .portrait
        }
    }
    
    func resizeVideoSizeForCell(withSourceExtent srcExtent: CGRect) {
        let sourceAspect = srcExtent.width/srcExtent.height
        let previewAspect = cellWidth/cellHeight
        // Maintain Screen Size Ratio
        if sourceAspect > previewAspect {
            
        }
    }

    
}

extension CameraViewController: GLKViewDelegate {
    func glkView(_ view: GLKView, drawIn rect: CGRect) {
//        glClearColor(0.85, 0.85, 0.85, 1.0)
//        glClear(GLbitfield(GL_COLOR_BUFFER_BIT))
    }
    
    
}


extension CameraViewController {
    struct SizeRatio {
        static let cellRatio:  CGFloat = 0.33
    }
    private var cellWidth: CGFloat {
        return self.view.bounds.width/3
    }
    private var cellHeight: CGFloat {
        return self.view.bounds.height/3
    }
    private var cellItemSize: CGSize {
        return CGSize(width: cellWidth, height: cellHeight)
    }
}


extension Array {
    func size() -> Int {
        return MemoryLayout<Element>.stride * self.count
    }
}
