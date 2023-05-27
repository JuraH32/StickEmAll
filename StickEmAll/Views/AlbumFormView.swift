import PureLayout
import SwiftUI

class AlbumFormView: UIView {
    var inputFieldCode: InputFieldView!
    var inputFieldName: InputFieldView!
    var inputFieldStickerNumber: InputFieldView!
    var inputFieldPacketCount: InputFieldView!
    
    
    init() {
        super.init(frame: .zero)
        self.createViews()
        self.styleViews()
        self.defineLayoutForViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createViews() {
        inputFieldCode = InputFieldView(label: "Album barcode", placeholder: "", isNumber: false)
        self.addSubview(inputFieldCode)
        
        inputFieldName = InputFieldView(label: "Album name", placeholder: "Album 1", isNumber: false)
        self.addSubview(inputFieldName)
        
        inputFieldStickerNumber = InputFieldView(label: "Number of stickers in album", placeholder: "100", isNumber: true)
        self.addSubview(inputFieldStickerNumber)
        
        inputFieldPacketCount = InputFieldView(label: "Number of stickers in a packet", placeholder: "5", isNumber: true)
        self.addSubview(inputFieldPacketCount)
    }
    
    private func styleViews() {
        self.backgroundColor = .blurple
        self.alpha = 0.85
        self.layer.cornerRadius = 40
    }
    
    private func defineLayoutForViews() {
        inputFieldCode.autoAlignAxis(toSuperviewAxis: .vertical)
        inputFieldCode.autoPinEdge(toSuperviewEdge: .top, withInset: 20)
        inputFieldCode.autoMatch(.width, to: .width, of: self, withMultiplier: 0.8)
        
        inputFieldName.autoAlignAxis(toSuperviewAxis: .vertical)
        inputFieldName.autoPinEdge(.top, to: .bottom, of: inputFieldCode, withOffset: 20)
        inputFieldName.autoMatch(.width, to: .width, of: inputFieldCode)
        
        inputFieldStickerNumber.autoAlignAxis(toSuperviewAxis: .vertical)
        inputFieldStickerNumber.autoPinEdge(.top, to: .bottom, of: inputFieldName, withOffset: 20)
        inputFieldStickerNumber.autoMatch(.width, to: .width, of: inputFieldName)
        
        inputFieldPacketCount.autoAlignAxis(toSuperviewAxis: .vertical)
        inputFieldPacketCount.autoPinEdge(.top, to: .bottom, of: inputFieldStickerNumber, withOffset: 20)
        inputFieldPacketCount.autoMatch(.width, to: .width, of: inputFieldName)
    }
    
    func clearForm() {
        inputFieldCode.resetField()
        inputFieldName.resetField()
        inputFieldStickerNumber.resetField()
        inputFieldPacketCount.resetField()
    }
}
