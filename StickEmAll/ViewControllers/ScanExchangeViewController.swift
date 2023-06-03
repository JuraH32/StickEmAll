
import Foundation
import UIKit
import PureLayout
import AVFoundation

class ScanExchangeViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    private let router: Router
    private var exchangeData: Exchange?
    
    private var okBtn: UIButton!
    private var inputLabel: UILabel!
    private var codeFieldContainer: UIView!
    private var codeField: UITextField!
    private var previewContainer: UIView!
    
    init (router: Router) {
        self.router = router
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        createViews()
        styleViews()
        defineLayout()
        setupQRCodeScanner()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        startQRCodeScanner()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        stopQRCodeScanner()
    }
    
    private func createViews() {
        okBtn = UIButton()
        view.addSubview(okBtn)
        okBtn.addTarget(self, action: #selector(onClick), for: .touchUpInside)
        
        inputLabel = UILabel()
        view.addSubview(inputLabel)
        
        codeFieldContainer = UIView()
        view.addSubview(codeFieldContainer)
        
        codeField = UITextField()
        codeFieldContainer.addSubview(codeField)
        
        previewContainer = UIView()
        view.addSubview(previewContainer)
    }
    
    private func styleViews() {
        view.backgroundColor = .lightRed
        
        inputLabel.text = "Input code" // "Scan QR code"
        inputLabel.font = .boldSystemFont(ofSize: 26)
        inputLabel.textColor = .white
        inputLabel.textAlignment = .center
        
        codeField.textColor = .white
        
        codeFieldContainer.layer.borderColor = UIColor.white.cgColor
        codeFieldContainer.layer.borderWidth = 2
        codeFieldContainer.layer.cornerRadius = 10
        
        okBtn.setTitle("OK", for: .normal)
        okBtn.backgroundColor = .lightBlurple
        okBtn.layer.cornerRadius = 32
        
    }
    
    private func defineLayout() {
        inputLabel.autoPinEdge(toSuperviewSafeArea: .top, withInset: 50)
        inputLabel.autoPinEdge(toSuperviewSafeArea: .leading)
        inputLabel.autoPinEdge(toSuperviewSafeArea: .trailing)
        
        codeFieldContainer.autoPinEdge(.top, to: .bottom, of: inputLabel, withOffset: 30)
        codeFieldContainer.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 20)
        codeFieldContainer.autoPinEdge(toSuperviewSafeArea: .trailing, withInset: 20)
        codeFieldContainer.autoSetDimension(.height, toSize: 50)
        
        codeField.autoPinEdge(toSuperviewEdge: .top)
        codeField.autoPinEdge(toSuperviewEdge: .bottom)
        codeField.autoPinEdge(toSuperviewEdge: .leading, withInset: 10)
        codeField.autoPinEdge(toSuperviewEdge: .trailing, withInset: 10)
        
        previewContainer.autoPinEdge(.top, to: .bottom, of: codeFieldContainer, withOffset: 40)
        previewContainer.autoPinEdge(.bottom, to: .top, of: okBtn, withOffset: 40)
        previewContainer.autoAlignAxis(toSuperviewAxis: .vertical)
        previewContainer.autoMatch(.width, to: .width, of: view, withMultiplier: 0.8)
        
        okBtn.autoSetDimension(.width, toSize: 64)
        okBtn.autoMatch(.height, to: .width, of: okBtn)
        okBtn.autoAlignAxis(toSuperviewAxis: .vertical)
        okBtn.autoPinEdge(toSuperviewSafeArea: .bottom, withInset: 20)
    }
    
    @objc func onClick() {
        let code = String(codeField.text!)
        //let code = "381ccc674b4ecc00c3c00001110100000000E000000000000C000000300000000010000000000000E000000000400000000000000000003"
        router.scannedCode(code: code)
    }
    
    func setupQRCodeScanner() {
        // Create an instance of AVCaptureDevice for the default camera
        guard let captureDevice = AVCaptureDevice.default(for: .video) else {
            print("Failed to access the camera.")
            return
        }
        
        do {
            // Create an input object from the capture device
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Create an instance of AVCaptureSession
            captureSession = AVCaptureSession()
            captureSession.addInput(input)
            
            // Create an AVCaptureMetadataOutput object and add it to the session
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            
            // Set the delegate and queue on the output object to receive metadata
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [.qr]
            
            // Create a preview layer and set it as the view's layer
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer.videoGravity = .resizeAspectFill
            previewLayer.frame = previewContainer.layer.bounds
            previewContainer.layer.addSublayer(previewLayer)
        } catch {
            print("Error setting up QR code scanner: \(error)")
        }
    }
    
    func startQRCodeScanner() {
        captureSession?.startRunning()
    }
    
    func stopQRCodeScanner() {
        captureSession?.stopRunning()
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Check if any metadata objects are found
        if let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
           let stringValue = metadataObject.stringValue {
            // Process the captured QR code value
            print("QR Code value: \(stringValue)")
            
            // Stop the scanner after capturing a QR code if needed
            stopQRCodeScanner()
            
            // Perform any desired actions with the captured value
            // ...
        }
    }
}
