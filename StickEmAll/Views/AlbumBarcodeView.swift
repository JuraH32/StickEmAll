import PureLayout
import AVFoundation

class AlbumBarcodeView: UIView {
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var setCodeFunction: SetCode!
    private var unavailableLabel: UILabel!
    
    init(setCodeFunction: @escaping SetCode) {
        super.init(frame: .zero)
        self.setCodeFunction = setCodeFunction
        self.createViews()
        self.styleViews()
        self.defineLayoutForViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createViews() {
        unavailableLabel = UILabel()
        addSubview(unavailableLabel)
    }
    
    private func styleViews() {
        self.backgroundColor = .gray
        self.layer.cornerRadius = 40
        
        unavailableLabel.text = "Barcode scanning is not available"
        unavailableLabel.textColor = .white
    }
    
    private func defineLayoutForViews() {
        unavailableLabel.autoAlignAxis(toSuperviewAxis: .vertical)
        unavailableLabel.autoAlignAxis(toSuperviewAxis: .horizontal)
    }
    
    func setupBarcodeScanner() {
        guard let captureDevice = AVCaptureDevice.default(for: .video) else {
            print("Failed to access the camera.")
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            captureSession = AVCaptureSession()
            captureSession.addInput(input)
            
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [.ean13, .ean8, .upce]
            
            unavailableLabel.isHidden = true
            
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer.videoGravity = .resizeAspectFill
            previewLayer.cornerRadius = 40
            self.layer.addSublayer(previewLayer)
        } catch {
            print("Error setting up barcode scanner: \(error)")
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        previewLayer?.frame = bounds
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if self.superview != nil {
            self.setupBarcodeScanner()
            startBarcodeScanner()
        } else {
            stopBarcodeScanner()
        }
    }
    
    func startBarcodeScanner() {
        DispatchQueue.global(qos: .background).async {
            self.captureSession?.startRunning()
        }
    }
    
    func stopBarcodeScanner() {
        DispatchQueue.global(qos: .background).async {
            self.captureSession?.stopRunning()
        }
    }
}

typealias SetCode = (String) -> Void

extension AlbumBarcodeView: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Check if any metadata objects are found
        if let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
           let stringValue = metadataObject.stringValue {
            // Process the captured barcode value
            print("Barcode value: \(stringValue)")
            stopBarcodeScanner()
            setCodeFunction(stringValue)
            
            
        }
    }
}
