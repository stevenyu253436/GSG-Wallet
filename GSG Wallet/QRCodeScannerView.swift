import SwiftUI
import AVFoundation

struct QRCodeScannerView: UIViewControllerRepresentable {
    class QRCodeCoordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate {
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

        @objc func backButtonTapped() {
            parent.onDismiss?()
        }
    }

    var didFindCode: (String) -> Void
    var didFail: (() -> Void)? = nil
    var onDismiss: (() -> Void)? = nil // 这里添加一个回调，用于处理点击返回按钮

    func makeCoordinator() -> QRCodeCoordinator {
        QRCodeCoordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        let captureSession = AVCaptureSession()

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

        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

    // 提供一个默认的失败处理方法
    static func dismantleUIViewController(_ uiViewController: UIViewController, coordinator: QRCodeCoordinator) {
        // 停止捕捉会话
        if let previewLayer = uiViewController.view.layer.sublayers?.first(where: { $0 is AVCaptureVideoPreviewLayer }) as? AVCaptureVideoPreviewLayer {
            previewLayer.session?.stopRunning()
        }
    }
}
