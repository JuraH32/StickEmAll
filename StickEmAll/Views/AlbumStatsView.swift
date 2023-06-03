import PureLayout

class AlbumStatsView: UIView {
    
    var viewHeader: UIView!
    var viewBody: UIView!
    var albumData: AlbumModel?
    var stickerCollected: UILabel!
    var stickerLabel: UILabel!
    let statsViewMinHeight: CGFloat
    
    private var totalLabel: UILabel!
    private var totalCount: UILabel!
    private var packLabel: UILabel!
    private var packNumber: UILabel!
    private var percentageLabel: UILabel!
    private var percentageNumber: UILabel!
    
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
            self.totalCount.text = "\(String(describing: self.albumData!.totalStickerCount))"
            self.packNumber.text = "\(String(describing: self.albumData!.stickersPerPack ?? 0))"
            self.percentageNumber.text = "\(String(describing: self.albumData?.percentageCollected ?? 0))%"
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
        
        totalLabel = UILabel()
        viewBody.addSubview(totalLabel)
        
        totalCount = UILabel()
        viewBody.addSubview(totalCount)
        
        packLabel = UILabel()
        viewBody.addSubview(packLabel)
        
        packNumber = UILabel()
        viewBody.addSubview(packNumber)
        
        percentageLabel = UILabel()
        viewBody.addSubview(percentageLabel)
        
        percentageNumber = UILabel()
        viewBody.addSubview(percentageNumber)
    }
    
    private func styleViews() {
        backgroundColor = .blue.withAlphaComponent(0)
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = true
        
        viewHeader.backgroundColor = .lightYellow
        stickerLabel.text = "Stickers"
        stickerLabel.font = .boldSystemFont(ofSize: 24)
        stickerLabel.textAlignment = .center
        
        stickerCollected.font = .boldSystemFont(ofSize: 32)
        stickerCollected.textAlignment = .center
        
        viewBody.backgroundColor = .lightYellow
        
        totalLabel.text = "Total stickers:"
        totalLabel.font = .systemFont(ofSize: 24)
        
        totalCount.font = .italicSystemFont(ofSize: 24)
        
        packLabel.text = "Stickers per pack:"
        packLabel.font = .systemFont(ofSize: 24)
        
        packNumber.font = .italicSystemFont(ofSize: 24)
        
        percentageLabel.text = "Percentage collected"
        percentageLabel.font = .systemFont(ofSize: 24)
        
        percentageNumber.font = .italicSystemFont(ofSize: 24)
    }
    
    private func defineLayoutForViews() {
        viewHeader.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .bottom)
        viewHeader.autoSetDimension(.height, toSize: statsViewMinHeight - 50)
        
        stickerCollected.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .bottom)
        stickerLabel.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .top)
        stickerLabel.autoPinEdge(.top, to: .bottom, of: stickerCollected)
        
        viewBody.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .top)
        viewBody.autoPinEdge(.top, to: .bottom, of: viewHeader)
        
        percentageLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 20)
        percentageLabel.autoPinEdge(toSuperviewEdge: .leading, withInset: 40)
        
        percentageNumber.autoAlignAxis(.horizontal, toSameAxisOf: percentageLabel)
        percentageNumber.autoPinEdge(.leading, to: .trailing, of: percentageLabel, withOffset: 20)
        
        totalLabel.autoPinEdge(.top, to: .bottom, of: percentageLabel, withOffset: 20)
        totalLabel.autoPinEdge(toSuperviewEdge: .leading, withInset: 40)
        
        totalCount.autoPinEdge(.leading, to: .trailing, of: totalLabel, withOffset: 20)
        totalCount.autoAlignAxis(.horizontal, toSameAxisOf: totalLabel)
        
        packLabel.autoPinEdge(.top, to: .bottom, of: totalLabel, withOffset: 20)
        packLabel.autoPinEdge(toSuperviewEdge: .leading, withInset: 40)
        
        packNumber.autoPinEdge(.leading, to: .trailing, of: packLabel, withOffset: 20)
        packNumber.autoAlignAxis(.horizontal, toSameAxisOf: packLabel)
    }
}
