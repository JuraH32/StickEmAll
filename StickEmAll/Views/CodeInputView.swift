
import Foundation
import UIKit
import PureLayout

class CodeInputView: UIView {
    
    private var inMessage: UILabel!
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
        inMessage = UILabel()
        addSubview(inMessage)
        
        okBtn = UIButton()
        addSubview(okBtn)
        okBtn.addTarget(self, action: #selector(handleOK), for: .touchUpInside)
    }
    
    private func styleViews() {
        inMessage.text = "View to input code for exchange"
        inMessage.backgroundColor = .white
        inMessage.textAlignment = .center
        inMessage.lineBreakMode = .byWordWrapping
        inMessage.numberOfLines = 0
        
        okBtn.setTitle("OK - click me", for: .normal)
        okBtn.setTitleColor(.black, for: .normal)
        okBtn.backgroundColor = .white
    }
    
    private func defineLayout() {
        inMessage.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .bottom)
        //inMessage.autoSetDimension(.height, toSize: 200)
        
        okBtn.autoPinEdge(.top, to: .bottom, of: inMessage)
        okBtn.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .top)
        
    }
    
    @objc private func handleOK() {
        self.isHidden = true
    }
}
