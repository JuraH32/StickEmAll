import PureLayout

class AlbumPreviewView: UIView {
    private var title: UILabel!
    private var albumData: AlbumModel?
    
    init() {
        super.init(frame: .zero)
        buildViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateData(albumData: AlbumModel?) {
        self.albumData = albumData
        DispatchQueue.main.async {
            self.styleData()
        }
    }
    
    private func buildViews() {
        createViews()
        styleViews()
        defineLayoutForViews()
    }
    
    private func createViews() {
        title = UILabel()
        self.addSubview(title)
    }
    
    private func styleViews() {
        title.textAlignment = .center
        title.lineBreakMode = .byWordWrapping
        
        self.layer.borderWidth = 1
    }
    
    private func defineLayoutForViews() {
        title.autoPinEdgesToSuperviewEdges()
    }
    
    private func styleData() {
        if (albumData != nil) {
            backgroundColor = albumData!.color
            title.text = albumData!.name
        } else {
            backgroundColor = .white.withAlphaComponent(0)
            title.text = ""
        }
    }
    
}
