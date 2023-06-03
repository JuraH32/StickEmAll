import PureLayout
import Combine

class CodeOutputView: UIView {
    private var outMessage: UILabel!
    private var okBtn: UIButton!
    private var qrCodeButton: UIButton!
    private var qrCodeView: UIImageView!
    private let sizeMulitplier = 0.8
    
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
        addSubview(qrCodeButton)
    }
    
    private func styleViews() {
        outMessage.text = "View to generate code for exchange"
        outMessage.backgroundColor = .white
        outMessage.textAlignment = .center
        outMessage.lineBreakMode = .byWordWrapping
        outMessage.numberOfLines = 0
        
        okBtn.setTitle("OK - click me", for: .normal)
        okBtn.setTitleColor(.black, for: .normal)
        okBtn.backgroundColor = .white
        
        backgroundColor = .white
//
//        qrCodeButton.backgroundColor = .red
    }
    
    private func defineLayout() {
        outMessage.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .bottom)
        
//        qrCodeView.autoPinEdgesToSuperviewEdges()
        
        qrCodeButton.autoPinEdge(.top, to: .bottom, of: outMessage)
        qrCodeButton.autoMatch(.width, to: .height, of: qrCodeButton)
        qrCodeButton.autoAlignAxis(toSuperviewAxis: .horizontal)
        qrCodeButton.autoAlignAxis(toSuperviewAxis: .vertical)
        qrCodeButton.autoMatch(.width, to: .width, of: self, withMultiplier: sizeMulitplier)
        
        okBtn.autoPinEdge(toSuperviewEdge: .bottom)
        okBtn.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .top)
    }
    
//    func bindData(code: String) {
////        print(code)
//////        qrCodeView.image = nil
////        let dimensions = self.layer.bounds.width * sizeMulitplier
////        let image = generateQRCode(from: code, width: dimensions, height: dimensions)
////        DispatchQueue.main.async {
////            self.qrCodeButton.setBackgroundImage(image, for: .normal)
////        }
//    }
    
    @objc private func handleOK() {
        self.isHidden = true
    }
    
    func loadCode(code: String) {
        qrCodeButton.subviews.forEach({$0.removeFromSuperview()})
        let image = UIImageView(image: generateQRCode(from: code, width: self.layer.bounds.width, height: self.layer.bounds.width))
        qrCodeButton.addSubview(image)
        image.autoPinEdgesToSuperviewEdges()
        layoutIfNeeded()
    }
}
