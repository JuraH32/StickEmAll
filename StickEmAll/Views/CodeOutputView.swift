import PureLayout
import Combine

class CodeOutputView: UIView {
    private var outMessage: UILabel!
    private var okBtn: UIButton!
    private var qrCodeButton: UIButton!
    private var qrCodeView: UIImageView!
    private let sizeMulitplier = 0.8
    private var exchangeCode: String?
    
    init() {
        super.init(frame: .zero)
        buildViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildViews() {
        createViews()
        styleViews()
        defineLayout()
    }
    
    private func createViews() {
        outMessage = UILabel()
        addSubview(outMessage)
        
        okBtn = UIButton()
        addSubview(okBtn)
        okBtn.addTarget(self, action: #selector(handleOK), for: .touchUpInside)
        
        qrCodeButton = UIButton()
        qrCodeButton.addTarget(self, action: #selector(handleQRCodePress), for: .touchUpInside)
        addSubview(qrCodeButton)
        
        let touchGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnView(_:)))
        touchGesture.numberOfTapsRequired = 1
        touchGesture.numberOfTouchesRequired = 1
        addGestureRecognizer(touchGesture)
    }
    
    private func styleViews() {
        
        outMessage.text = "Scan or click to copy exchange code"
        outMessage.font = .systemFont(ofSize: 22)
        outMessage.backgroundColor = .white
        outMessage.textAlignment = .center
        outMessage.lineBreakMode = .byWordWrapping
        outMessage.numberOfLines = 0
        
        okBtn.setTitle("OK", for: .normal)
        okBtn.setTitleColor(.black, for: .normal)
        okBtn.setAttributedTitle(NSAttributedString(string: "OK", attributes: [.font: UIFont.systemFont(ofSize: 26)]), for: .normal)
        okBtn.backgroundColor = .white
        
        backgroundColor = .white
    }
    
    private func defineLayout() {
        outMessage.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .bottom)

        qrCodeButton.autoPinEdge(.top, to: .bottom, of: outMessage)
        qrCodeButton.autoMatch(.width, to: .height, of: qrCodeButton)
        qrCodeButton.autoAlignAxis(toSuperviewAxis: .horizontal)
        qrCodeButton.autoAlignAxis(toSuperviewAxis: .vertical)
        qrCodeButton.autoMatch(.width, to: .width, of: self, withMultiplier: sizeMulitplier)
        
        okBtn.autoPinEdge(toSuperviewEdge: .bottom)
        okBtn.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .top)
        okBtn.autoPinEdge(.top, to: .bottom, of: qrCodeButton, withOffset: 10)
    }
    
    @objc private func handleOK() {
        self.isHidden = true
    }
    
    func loadCode(code: String) {
        self.exchangeCode = code
        qrCodeButton.subviews.forEach({$0.removeFromSuperview()})
        let image = UIImageView(image: generateQRCode(from: code, width: self.layer.bounds.width, height: self.layer.bounds.width))
        qrCodeButton.addSubview(image)
        image.autoPinEdgesToSuperviewEdges()
        layoutIfNeeded()
    }
    
    @objc private func handleQRCodePress() {
        guard let exchangeCode = self.exchangeCode else { return }
        let pasteboard = UIPasteboard.general
        pasteboard.string = exchangeCode
    }
    
    @objc private func tapOnView(_ gestureRecognizer: UITapGestureRecognizer) {
        // do nothing
    }
}
