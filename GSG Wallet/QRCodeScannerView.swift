import SwiftUI
import AVFoundation
import PhotosUI
import CoreImage

struct QRCodeScannerView: UIViewControllerRepresentable {
    class QRCodeCoordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate, UINavigationControllerDelegate, PHPickerViewControllerDelegate {
        var parent: QRCodeScannerView

        init(parent: QRCodeScannerView) {
            self.parent = parent
        }

        func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
            if let metadataObject = metadataObjects.first {
                guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
                guard let stringValue = readableObject.stringValue else { return }

                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                parent.didFindCode(stringValue)
            }
        }
        
        // Handle image picker (album) result
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                // Process the selected image here (e.g., run OCR, scan for QR codes, etc.)
                print("Selected image from album: \(selectedImage)")
            }
            parent.onDismiss?()
            picker.dismiss(animated: true)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.onDismiss?()
            picker.dismiss(animated: true)
        }
        
        // Handle PHPicker result
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            print("Entered picker(_:didFinishPicking:)")
            picker.dismiss(animated: true)
            guard let result = results.first else {
                print("No image selected, closing image picker.")
                parent.isShowingImagePicker = false
                return
            }

            if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (image, error) in
                    if let selectedImage = image as? UIImage {
                        DispatchQueue.main.async {
                            self?.parent.selectedImage = selectedImage

                            // Process the image for QR code detection
                            self?.detectQRCode(in: selectedImage)
                        }
                    }
                    // Set isShowingImagePicker to false after finishing the picker action
                    DispatchQueue.main.async {
                        print("Dismissing image picker after processing.")
                        self?.parent.isShowingImagePicker = false
                    }
                }
            } else {
                // Set isShowingImagePicker to false if the item cannot be loaded
                print("Could not load the selected item as an image, dismissing picker.")
                parent.isShowingImagePicker = false
            }
        }
        
        private func detectQRCode(in image: UIImage) {
            guard let ciImage = CIImage(image: image) else { return }
            
            let context = CIContext()
            let options: [String: Any] = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
            let qrDetector = CIDetector(ofType: CIDetectorTypeQRCode, context: context, options: options)
            
            if let features = qrDetector?.features(in: ciImage) as? [CIQRCodeFeature], let qrCode = features.first?.messageString {
                DispatchQueue.main.async {
                    self.parent.didFindCode(qrCode) // Update the withdrawal address
                }
            }
        }

        @objc func backButtonTapped() {
            parent.onDismiss?()
        }
        
        // Show album (photo library)
        @objc func albumButtonTapped() {
            print("Album button tapped") // Debug statement to confirm the method is called
            parent.isShowingImagePicker = true // Trigger the display of the sheet
        }
    }

    var didFindCode: (String) -> Void
    var didFail: (() -> Void)? = nil
    var onDismiss: (() -> Void)? = nil // 这里添加一个回调，用于处理点击返回按钮
    @State private var isShowingImagePicker = false // State variable to control the sheet presentation
    @State var selectedImage: UIImage? = nil // To store the selected image

    func makeCoordinator() -> QRCodeCoordinator {
        QRCodeCoordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        let captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            print("Failed to get the camera device.")
            didFail?() // 如果相机设备获取失败，也触发失败回调
            return viewController
        }
        
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            print("Failed to create video input.")
            didFail?() // 如果视频输入创建失败，也触发失败回调
            return viewController
        }
        
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            print("Could not add video input to capture session.")
            didFail?() // 如果视频输入添加失败，也触发失败回调
            return viewController
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(context.coordinator, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            print("Could not add metadata output to capture session.")
            didFail?() // 如果元数据输出添加失败，也触发失败回调
            return viewController
        }
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = viewController.view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        viewController.view.layer.addSublayer(previewLayer)

        captureSession.startRunning()
        print("AVCaptureSession started") // 在这里打印日志，确保 captureSession 启动

        // Add a square frame overlay to guide the user
        let overlayView = UIView(frame: viewController.view.bounds)
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        viewController.view.addSubview(overlayView)

        // Create a square hole in the overlay
        let scanFrame = CGRect(x: viewController.view.bounds.width * 0.2, y: viewController.view.bounds.height * 0.3, width: viewController.view.bounds.width * 0.6, height: viewController.view.bounds.width * 0.6)

        let path = UIBezierPath(rect: overlayView.bounds)
        let scanPath = UIBezierPath(rect: scanFrame)
        path.append(scanPath.reversing())

        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        overlayView.layer.mask = maskLayer

        // Add the scan frame border (optional)
        let scanBorder = CALayer()
        scanBorder.frame = scanFrame
        scanBorder.borderWidth = 2
        scanBorder.borderColor = UIColor.purple.cgColor
        viewController.view.layer.addSublayer(scanBorder)

        // 添加返回按钮
        let backButton = UIButton(type: .system)
        backButton.setTitle("返回", for: .normal)
        backButton.addTarget(context.coordinator, action: #selector(QRCodeCoordinator.backButtonTapped), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
        viewController.view.addSubview(backButton)
        viewController.view.bringSubviewToFront(backButton)

        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor, constant: 20),
            backButton.topAnchor.constraint(equalTo: viewController.view.topAnchor, constant: 50)
        ])
        
        // Add album button on the right
        let albumButton = UIButton(type: .system)
        albumButton.setTitle("相簿", for: .normal)
        albumButton.addTarget(context.coordinator, action: #selector(QRCodeCoordinator.albumButtonTapped), for: .touchUpInside)
        albumButton.translatesAutoresizingMaskIntoConstraints = false
        
        viewController.view.addSubview(albumButton)
        viewController.view.bringSubviewToFront(albumButton)

        NSLayoutConstraint.activate([
            albumButton.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor, constant: -20),
            albumButton.topAnchor.constraint(equalTo: viewController.view.topAnchor, constant: 50)
        ])

        // 检查相机权限
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            break // 已授权，继续执行
        case .notDetermined:
            // 请求权限
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    DispatchQueue.main.async {
                        // 重新加载视图
                        viewController.viewDidLoad()
                    }
                }
            }
        default:
            didFail?()
            return viewController
        }

        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if isShowingImagePicker {
            var configuration = PHPickerConfiguration()
            configuration.selectionLimit = 1
            configuration.filter = .images
            
            let picker = PHPickerViewController(configuration: configuration)
            picker.delegate = context.coordinator
            uiViewController.present(picker, animated: true) {
                // Set isShowingImagePicker to false after presenting the picker
                isShowingImagePicker = false
            }
        }
    }
    
    // 提供一个默认的失败处理方法
    static func dismantleUIViewController(_ uiViewController: UIViewController, coordinator: QRCodeCoordinator) {
        // 停止捕捉会话
        if let previewLayer = uiViewController.view.layer.sublayers?.first(where: { $0 is AVCaptureVideoPreviewLayer }) as? AVCaptureVideoPreviewLayer {
            previewLayer.session?.stopRunning()
        }
    }
}
