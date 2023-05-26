import PureLayout

class AlbumBarcodeView: UIView {
    
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
        
    }
    
    private func styleViews() {
        self.backgroundColor = .gray
        self.layer.cornerRadius = 40
    }
    
    private func defineLayoutForViews() {
        
    }
}
