//
//  InputView.swift
//  MovieApp
//
//  Created by endava-bootcamp on 27.03.2023..
//

import PureLayout

class ModeSwitchView: UIView {
    var addLabel: UILabel!
    var removeLabel: UILabel!
    var buttonView: UIButton!
    
    init() {
        super.init(frame: .zero)
        self.commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        createViews()
        style()
        layout()
    }
    
    private func createViews() {
        buttonView = UIButton()
        addSubview(buttonView)
        
        addLabel = UILabel()
        buttonView.addSubview(addLabel)
        buttonView.bringSubviewToFront(addLabel)
        
        removeLabel = UILabel()
        buttonView.addSubview(removeLabel)
        buttonView.bringSubviewToFront(removeLabel)
        
    }
    
    private func style() {
        self.layer.cornerRadius = 20
        self.backgroundColor = .lightGray
        
        addLabel.text = "Add"
        removeLabel.text = "Remove"
        
        addLabel.textAlignment = .center
        removeLabel.textAlignment = .center
    }
    
    private func layout() {
        buttonView.autoPinEdgesToSuperviewSafeArea()
        
        addLabel.autoPinEdgesToSuperviewSafeArea(with: .zero, excludingEdge: .trailing)
        removeLabel.autoPinEdgesToSuperviewSafeArea(with: .zero, excludingEdge: .leading)
        
        addLabel.autoMatch(.width, to: .width, of: self, withMultiplier: 0.5)
        removeLabel.autoMatch(.width, to: .width, of: addLabel)
    }
}


