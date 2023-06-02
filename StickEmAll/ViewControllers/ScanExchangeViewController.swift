
import Foundation
import UIKit
import PureLayout

class ScanExchangeViewController: UIViewController {
    
    private let router: Router
    private var exchangeData: Exchange?
    
    private var okBtn: UIButton!
    private var inputLabel: UILabel!
    private var codeFieldContainer: UIView!
    private var codeField: UITextField!
    
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
        
        okBtn.autoSetDimension(.width, toSize: 64)
        okBtn.autoMatch(.height, to: .width, of: okBtn)
        okBtn.autoAlignAxis(toSuperviewAxis: .vertical)
        okBtn.autoPinEdge(toSuperviewSafeArea: .bottom, withInset: 20)
    }
    
    @objc func onClick() {
        //let code = String(codeField.text!)
        let code = "381ccc674b4ecc00c3c00001110100000000E000000000000C000000300000000010000000000000E000000000400000000000000000003"
        router.scannedCode(code: code)
    }
}
