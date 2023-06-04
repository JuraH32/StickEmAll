import PureLayout

class AlbumPreviewView: UIView {
    
    private var title: UILabel!
    private var addView: UIImageView!
    var albumData: AlbumModel?
    private var colorID: Int = 0
    
    private var generateCodeBtn: UIButton!
    var codeView: CodeOutputView!
    
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
        
        generateCodeBtn = UIButton()
        addSubview(generateCodeBtn)
        generateCodeBtn.addTarget(self, action: #selector(handleOutBtn), for: .touchUpInside)
        
        codeView = CodeOutputView()
        addSubview(codeView)
    }
    
    private func styleViews() {
        generateCodeBtn.isHidden = true
        
        title.font = .boldSystemFont(ofSize: 22)
        title.textAlignment = .center
        title.numberOfLines = 0
        title.lineBreakMode = .byWordWrapping
        
        let plusImage = UIImage(systemName: "plus.circle")
        addView.image = plusImage
        addView.contentMode = .scaleAspectFit
        addView.tintColor = .black
        addView.layer.cornerRadius = 50
        addView.alpha = 0
        
        generateCodeBtn.layer.cornerRadius = 32
        generateCodeBtn.backgroundColor = .lightRed
        generateCodeBtn.setImage(UIImage(systemName: "qrcode", withConfiguration: UIImage.SymbolConfiguration(pointSize: 36, weight: .bold)), for: .normal)
        generateCodeBtn.tintColor = .white
        
        codeView.isHidden = true
        
        layer.cornerRadius = 10
    }
    
    private func defineLayoutForViews() {
        title.autoPinEdgesToSuperviewEdges()
        
        generateCodeBtn.autoPinEdge(toSuperviewEdge: .bottom, withInset: 30)
        generateCodeBtn.autoAlignAxis(toSuperviewAxis: .vertical)
        generateCodeBtn.autoSetDimensions(to: CGSize(width: 64, height: 64))
        self.bringSubviewToFront(generateCodeBtn)
        
        addView.autoAlignAxis(toSuperviewAxis: .vertical)
        addView.autoAlignAxis(toSuperviewAxis: .horizontal)
        addView.autoSetDimension(.width, toSize: 100)
        addView.autoMatch(.height, to: .width, of: addView)
        
        codeView.autoPinEdgesToSuperviewEdges()
        bringSubviewToFront(codeView)
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
            self.layer.borderWidth = 3
            self.layer.borderColor = UIColor.black.cgColor
        } else {
            self.layer.borderWidth = 0
        }
        generateCodeBtn.isHidden = colorID == 0 ? false : true
    }
    
    @objc private func handleOutBtn() {
        codeView.isHidden = false
    }
}
