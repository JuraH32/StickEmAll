
import Foundation
import UIKit
import PureLayout

class CodeOutputView: UIView {
    
    private var outMessage: UILabel!
    private var okBtn: UIButton!
    
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
    }
    
    private func defineLayout() {
        outMessage.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .bottom)
        
        okBtn.autoPinEdge(.top, to: .bottom, of: outMessage)
        okBtn.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .top)
        
    }
    
    @objc private func handleOK() {
        self.isHidden = true
    }
}
