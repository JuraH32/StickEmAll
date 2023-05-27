import PureLayout

class AlbumPreviewView: UIView {
    
    private var title: UILabel!
    private var addView: UIImageView!
    var albumData: AlbumModel?
    private var colorID: Int = 0
    
    init() {
        super.init(frame: .zero)
        buildViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateData(albumData: AlbumModel?, colorID: Int) {
        self.colorID = colorID
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
        
        addView = UIImageView()
        addSubview(addView)
    }
    
    private func styleViews() {
        title.font = .boldSystemFont(ofSize: 22)
        title.textAlignment = .center
        title.lineBreakMode = .byWordWrapping
        
        let plusImage = UIImage(systemName: "plus.circle")
        addView.image = plusImage
        addView.contentMode = .scaleAspectFit
        addView.tintColor = .black
        addView.layer.cornerRadius = 50
        addView.alpha = 0
    }
    
    private func defineLayoutForViews() {
        title.autoPinEdgesToSuperviewEdges()
        
        addView.autoAlignAxis(toSuperviewAxis: .vertical)
        addView.autoAlignAxis(toSuperviewAxis: .horizontal)
        addView.autoSetDimension(.width, toSize: 100)
        addView.autoMatch(.height, to: .width, of: addView)
    }
    
    private func styleData() {
        if (albumData != nil && albumData?.code != "") {
            backgroundColor = colorID == 0 ? .darkYellow : .blurple //.yellow
            title.text = albumData!.name
        } else {
            backgroundColor = .white.withAlphaComponent(0)
            title.text = ""
        }
        addView.alpha = 0
        if (albumData?.code == "") {
            addView.alpha = 1
            self.layer.borderWidth = 2
            self.layer.borderColor = UIColor.black.cgColor
        }
    }
    
}
