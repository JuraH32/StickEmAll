
import Foundation
import UIKit
import PureLayout

class StickerCell: UICollectionViewCell {
    
    static let reuseIdentifier = String(describing: StickerCell.self)
    
    private var stickerFrame: UIView!
    private var duplicateFrame: UIView!
    private var numberLabel: UILabel!
    private var stickerNumberLabel: UILabel!
    
    private var number: Int!
    private var noCollected: Int!
    private var change: Int?
    
    private var changeFunction: ChangeCountFunction?
    
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
        
        stickerNumberLabel = UILabel()
        addSubview(stickerNumberLabel)
        bringSubviewToFront(stickerNumberLabel)
        
        let touchStickerGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        touchStickerGesture.numberOfTouchesRequired = 1
        touchStickerGesture.numberOfTapsRequired = 1
        self.addGestureRecognizer(touchStickerGesture)
    }
    
    private func styleViews() {
        //self.backgroundColor = .blue
        self.alpha = 0
        
        stickerFrame.backgroundColor = .darkYellow
        
        duplicateFrame.backgroundColor = UIColor(red: 0.322, green: 0.443, blue: 1, alpha: 0.5)
        duplicateFrame.isHidden = true
        self.sendSubviewToBack(duplicateFrame)
        
        numberLabel.textColor = .black
        numberLabel.font = .boldSystemFont(ofSize: 25)
        numberLabel.textAlignment = .center
        
        stickerNumberLabel.text = "(0)"
        stickerNumberLabel.font = .systemFont(ofSize: 16)
        
        
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
        
        stickerNumberLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 4)
        stickerNumberLabel.autoPinEdge(toSuperviewEdge: .trailing, withInset: 4)
    }
    
    public func setData(number: Int, collected: Int, change: Int?, addState: Bool, changeFunction: @escaping ChangeCountFunction) {
        self.number = number
        self.changeFunction = changeFunction
        noCollected = collected
        
        numberLabel.text = String(number)
        stickerNumberLabel.textColor = .black
        
        let collected = noCollected + (change ?? 0)
        
        if change != nil && addState {
            let changeNumber = abs(change!)
            stickerNumberLabel.text = "(\(String(describing: noCollected!)) \(change! >= 0 ? "+" : "-") \(changeNumber))"
            if change! > 0 {
                stickerNumberLabel.textColor = .green
            } else if change! < 0 {
                stickerNumberLabel.textColor = .red
            }
        } else {
            stickerNumberLabel.text = "(\(String(describing: noCollected!)))"
        }
        if collected == 0 {
            stickerFrame.backgroundColor = .darkYellow
            duplicateFrame.isHidden = true
        }
        if collected > 0 {
            stickerFrame.backgroundColor = UIColor(red: 0.322, green: 0.443, blue: 1, alpha: 1)
            duplicateFrame.isHidden = true
        }
        if collected > 1 {
            duplicateFrame.isHidden = false
        }
    }
        
    @objc private func handleTap(_ gestureReocgnizer: UITapGestureRecognizer) {
        if changeFunction == nil {
            return
        }
        changeFunction!(number)
    }
}

typealias ChangeCountFunction = (Int) -> Void
