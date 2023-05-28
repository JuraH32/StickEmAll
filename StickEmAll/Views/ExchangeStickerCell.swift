
import Foundation
import UIKit
import PureLayout

class ExchangeStickerCell: UICollectionViewCell {
    
    static let reuseIdentifier = String(describing: ExchangeStickerCell.self)
    
    private var numberLabel: UILabel!
    private var number: Int!
    private var direction: Int!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        buildViews()
    }
        
    private func buildViews() {
        createViews()
        styleViews()
        defineLayout()
    }
    
    private func createViews() {
        numberLabel = UILabel()
        addSubview(numberLabel)
    }
    
    private func styleViews() {
        backgroundColor = .lightRed
        layer.cornerRadius = 25
        
        numberLabel.textColor = .white
        numberLabel.font = .boldSystemFont(ofSize: 28)
        numberLabel.textAlignment = .center
    }
    
    private func defineLayout() {
        numberLabel.autoPinEdgesToSuperviewEdges()
    }
    
    public func setData(number: Int, direcionOfExchange: Int) {
        self.number = number
        direction = direcionOfExchange
        
        numberLabel.text = String(number)
        
        if direction > 0 {
            numberLabel.textColor = .black
            backgroundColor = .darkYellow
        }
    }
}
