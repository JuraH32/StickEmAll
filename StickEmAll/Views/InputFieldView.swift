//
//  InputView.swift
//  MovieApp
//
//  Created by endava-bootcamp on 27.03.2023..
//

import UIKit
import PureLayout

class InputFieldView: UIView {
    var label: UILabel!
    var labelText: String
    var inputFieldContainer: UIView!
    var inputField: UITextField!
    var inputFieldDefaultText: String
    var isNumber: Bool
    
    let fieldColor = UIColor(red: 0.322, green: 0.443, blue: 1, alpha: 1)
    
    init(label labelText: String, placeholder inputFieldDefaultText: String, isNumber: Bool) {
        self.labelText = labelText
        self.inputFieldDefaultText = inputFieldDefaultText
        self.isNumber = isNumber
        super.init(frame: .zero)
        self.commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        self.labelText = ""
        self.inputFieldDefaultText = ""
        self.isNumber = false
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        createViews()
        style()
        layout()
    }
    
    private func createViews() {
        label = UILabel()
        self.addSubview(label)
        
        inputFieldContainer = UIView()
        self.addSubview(inputFieldContainer)
        
        inputField = UITextField()
        if (isNumber) {
            inputField.delegate = self
        }
        inputFieldContainer.addSubview(inputField)
        
        label.text = labelText
        let placeholder = NSAttributedString(string: inputFieldDefaultText,
                                             attributes: [.foregroundColor: UIColor.lightGray])
        inputField.attributedPlaceholder = placeholder
    }
    
    private func style() {
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .white
        
        inputField.textColor = .white
        
        inputFieldContainer.backgroundColor = .lightBlurple
        inputFieldContainer.layer.borderColor = UIColor.blurple.cgColor
        inputFieldContainer.layer.borderWidth = 0.5
        inputFieldContainer.layer.cornerRadius = 10
        
    }
    
    private func layout() {
        label.autoPinEdge(toSuperviewEdge: .top)
        label.autoPinEdge(toSuperviewEdge: .leading, withInset: 8)
        
        inputFieldContainer.autoPinEdge(.top, to: .bottom, of: label, withOffset: 8)
        inputFieldContainer.autoPinEdge(toSuperviewEdge: .bottom)
        inputFieldContainer.autoAlignAxis(toSuperviewAxis: .vertical)
        inputFieldContainer.autoMatch(.width, to: .width, of: self)
        inputFieldContainer.autoSetDimension(.height, toSize: 48)
        
        inputField.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
    }
    
    func resetField() {
        inputField.text = isNumber ? "0" : ""
    }
}

extension InputFieldView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text else {
            return true
        }
        
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        // Perform validation
        let isValidNumber = Int(updatedText) ?? nil
        
        return updatedText == "" || isValidNumber != nil
    }
}
