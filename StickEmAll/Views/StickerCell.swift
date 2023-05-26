
import Foundation
import UIKit
import PureLayout

class StickerCell: UICollectionViewCell {
    
    static let reuseIdentifier = String(describing: StickerCell.self)
    
    private var stickerFrame: UIView!
    private var duplicateFrame: UIView!
    private var numberLabel: UILabel!
    private var number: Int!
    private var noCollected: Int!
    
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
        stickerFrame = UIView()
        self.addSubview(stickerFrame)
        
        duplicateFrame = UIView()
        self.addSubview(duplicateFrame)
        
        numberLabel = UILabel()
        stickerFrame.addSubview(numberLabel)
    }
    
    private func styleViews() {
        //self.backgroundColor = .blue
        self.alpha = 0
        
        stickerFrame.backgroundColor = UIColor(red: 1, green: 0.871, blue: 0.349, alpha: 1)
        
        duplicateFrame.backgroundColor = UIColor(red: 0.322, green: 0.443, blue: 1, alpha: 0.5)
        duplicateFrame.isHidden = true
        self.sendSubviewToBack(duplicateFrame)
        
        numberLabel.textColor = .black
        numberLabel.font = .boldSystemFont(ofSize: 40)
        numberLabel.textAlignment = .center
        
    }
    
    private func defineLayout() {
        stickerFrame.autoPinEdge(toSuperviewEdge: .top, withInset: 12)
        stickerFrame.autoPinEdge(toSuperviewEdge: .leading)
        stickerFrame.autoPinEdge(toSuperviewEdge: .trailing, withInset: 12)
        stickerFrame.autoPinEdge(toSuperviewEdge: .bottom)
        
        duplicateFrame.autoPinEdge(toSuperviewEdge: .top)
        duplicateFrame.autoPinEdge(toSuperviewEdge: .leading, withInset: 12)
        duplicateFrame.autoPinEdge(toSuperviewEdge: .trailing)
        duplicateFrame.autoPinEdge(toSuperviewEdge: .bottom, withInset: 12)
        
        numberLabel.autoPinEdgesToSuperviewEdges()
    }
    
    public func setData(number: Int, collected: Int) {
        self.number = number
        noCollected = collected
        
        numberLabel.text = String(number)
        
        if noCollected > 0 {
            stickerFrame.backgroundColor = UIColor(red: 0.322, green: 0.443, blue: 1, alpha: 1)
        }
        if noCollected > 1 {
            duplicateFrame.isHidden = false
        }
    }
}
