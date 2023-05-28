//
//  InputView.swift
//  MovieApp
//
//  Created by endava-bootcamp on 27.03.2023..
//

import PureLayout

class ModeSwitchView: UIView {
    var addButton: UIButton!
    var removeButton: UIButton!
    var state: Bool = true
    var selectedView: UIView!
    
    var selectedConstraint: NSLayoutConstraint!
    
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
        selectedView = UIView()
        addSubview(selectedView)
        
        addButton = UIButton()
        addButton.addTarget(self, action: #selector(toggleAdd), for: .touchUpInside)
        addSubview(addButton)
        bringSubviewToFront(addButton)
        
        removeButton = UIButton()
        removeButton.addTarget(self, action: #selector(toggleRemove), for: .touchUpInside)
        addSubview(removeButton)
        bringSubviewToFront(removeButton)
    }
    
    private func style() {
        layer.cornerRadius = 16
        backgroundColor = .lightGray.withAlphaComponent(0.3)
        
        addButton.setTitle("Add", for: .normal)
        removeButton.setTitle("Remove", for: .normal)
        
        selectedView.backgroundColor = .green
        selectedView.clipsToBounds = true
        selectedView.layer.cornerRadius = 16
    }
    
    private func layout() {
        addButton.autoPinEdgesToSuperviewSafeArea(with: .zero, excludingEdge: .trailing)
        removeButton.autoPinEdgesToSuperviewSafeArea(with: .zero, excludingEdge: .leading)
        
        addButton.autoMatch(.width, to: .width, of: self, withMultiplier: 0.5)
        removeButton.autoMatch(.width, to: .width, of: addButton)
        
        selectedView.autoAlignAxis(toSuperviewAxis: .horizontal)
        selectedView.autoMatch(.width, to: .width, of: self, withMultiplier: 0.5)
        selectedView.autoMatch(.height, to: .height, of: self)
        selectedConstraint = selectedView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0)
        
        
        NSLayoutConstraint.activate([selectedConstraint])
    }
    
    @objc private func toggleAdd() {
        if (state) {
            return
        }
        state = true
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
            self.selectedConstraint.constant = 0
            self.selectedView.backgroundColor = .green
            self.layoutIfNeeded()
        }
    }
    
    @objc private func toggleRemove() {
        if (!state) {
            return
        }
        state = false
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
            self.selectedConstraint.constant = self.bounds.width / 2
            self.selectedView.backgroundColor = .red
            self.layoutIfNeeded()
        }
    }
}


