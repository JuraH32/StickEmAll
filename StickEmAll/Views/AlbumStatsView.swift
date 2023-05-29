import PureLayout

class AlbumStatsView: UIView {
    
    var viewHeader: UIView!
    var viewBody: UIView!
    var albumData: AlbumModel?
    var stickerCollected: UILabel!
    var stickerLabel: UILabel!
    let statsViewMinHeight: CGFloat
    
    init(statsViewMinHeight: CGFloat) {
        self.statsViewMinHeight = statsViewMinHeight
        super.init(frame: .zero)
        self.createViews()
        self.styleViews()
        self.defineLayoutForViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setAlbumData(albumData: AlbumModel) {
        self.albumData = albumData
        DispatchQueue.main.async {
            self.stickerCollected.text = "\(String(describing: self.albumData!.numberOfCollectedStickers))/\(String(describing: self.albumData!.numberOfStickers))"
        }
    }
    
    private func createViews() {
        viewHeader = UIView()
        self.addSubview(viewHeader)
        
        stickerCollected = UILabel()
        viewHeader.addSubview(stickerCollected)
        
        stickerLabel = UILabel()
        viewHeader.addSubview(stickerLabel)
        
        viewBody = UIView()
        self.addSubview(viewBody)
    }
    
    private func styleViews() {
        self.backgroundColor = .blue.withAlphaComponent(0)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        viewHeader.backgroundColor = .lightYellow
        stickerLabel.text = "Stickers"
        stickerLabel.font = .systemFont(ofSize: 24)
        stickerLabel.textAlignment = .center
        
        stickerCollected.font = .boldSystemFont(ofSize: 32)
        stickerCollected.textAlignment = .center
        
        viewBody.backgroundColor = .lightYellow
    }
    
    private func defineLayoutForViews() {
        viewHeader.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .bottom)
        viewHeader.autoSetDimension(.height, toSize: statsViewMinHeight - 50)
        
        stickerCollected.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .bottom)
        stickerLabel.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .top)
        stickerLabel.autoPinEdge(.top, to: .bottom, of: stickerCollected)
        
        viewBody.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .top)
        viewBody.autoPinEdge(.top, to: .bottom, of: viewHeader)
    }
}
