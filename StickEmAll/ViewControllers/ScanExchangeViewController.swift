
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
    private var unavailableLabel: UILabel!
    
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
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        startQRCodeScanner()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        stopQRCodeScanner()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer?.frame = previewContainer.layer.bounds
    }
    
    private func createViews() {
        inputLabel = UILabel()
        view.addSubview(inputLabel)
        
        codeFieldContainer = UIView()
        view.addSubview(codeFieldContainer)
        
        codeField = UITextField()
        codeFieldContainer.addSubview(codeField)
        
        previewContainer = UIView()
        view.addSubview(previewContainer)
        
        unavailableLabel = UILabel()
        previewContainer.addSubview(unavailableLabel)
        
        okBtn = UIButton()
        view.addSubview(okBtn)
        okBtn.addTarget(self, action: #selector(onClick), for: .touchUpInside)
    }
    
    private func styleViews() {
        view.backgroundColor = .lightRed
        
        inputLabel.text = "Input code or scan QR code"
        inputLabel.font = .boldSystemFont(ofSize: 26)
        inputLabel.textColor = .white
        inputLabel.textAlignment = .center
        
        codeField.textColor = .white
        
        codeFieldContainer.backgroundColor = .white.withAlphaComponent(0.3)
        codeFieldContainer.layer.borderColor = UIColor.white.cgColor
        codeFieldContainer.layer.borderWidth = 3
        codeFieldContainer.layer.cornerRadius = 10
        
        okBtn.setAttributedTitle(NSAttributedString(string: "OK", attributes: [.font: UIFont.boldSystemFont(ofSize: 24), .foregroundColor: UIColor.white]), for: .normal)
        okBtn.backgroundColor = .lightBlurple
        okBtn.layer.cornerRadius = 32
        okBtn.layer.borderColor = UIColor.white.cgColor
        okBtn.layer.borderWidth = 3
        
        previewContainer.backgroundColor = .lightGray
        previewContainer.layer.cornerRadius = 10
        previewContainer.layer.borderColor = UIColor.white.cgColor
        previewContainer.layer.borderWidth = 3
        
        unavailableLabel.text = "Camera is not available"
        unavailableLabel.textColor = .black
    }
    
    private func defineLayout() {
        inputLabel.autoPinEdge(toSuperviewSafeArea: .top, withInset: 20)
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
        
        okBtn.autoSetDimension(.width, toSize: 64)
        okBtn.autoMatch(.height, to: .width, of: okBtn)
        okBtn.autoAlignAxis(toSuperviewAxis: .vertical)
        okBtn.autoPinEdge(toSuperviewSafeArea: .bottom)
        
        previewContainer.autoPinEdge(.top, to: .bottom, of: codeFieldContainer, withOffset: 40)
        previewContainer.autoPinEdge(.bottom, to: .top, of: okBtn, withOffset: -20)
        previewContainer.autoAlignAxis(toSuperviewAxis: .vertical)
        previewContainer.autoMatch(.width, to: .width, of: view, withMultiplier: 0.75)
        
        unavailableLabel.autoAlignAxis(toSuperviewAxis: .vertical)
        unavailableLabel.autoAlignAxis(toSuperviewAxis: .horizontal)
    }
    
    @objc func onClick() {
        let code = String(codeField.text!)
        router.scannedCode(code: code)
    }
    
    func setupQRCodeScanner() {
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
            captureMetadataOutput.metadataObjectTypes = [.qr]
            
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer.videoGravity = .resizeAspectFill
            previewLayer.cornerRadius = 10
            unavailableLabel.isHidden = true
            previewContainer.layer.addSublayer(previewLayer)
        } catch {
            print("Error setting up QR code scanner: \(error)")
        }
    }
    
    func startQRCodeScanner() {
        DispatchQueue.global(qos: .background).async {
            self.captureSession?.startRunning()
        }
    }
    
    func stopQRCodeScanner() {
        DispatchQueue.global(qos: .background).async {
            self.captureSession?.stopRunning()
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
           let stringValue = metadataObject.stringValue {
            stopQRCodeScanner()
            
            router.scannedCode(code: stringValue)
        }
    }
}
