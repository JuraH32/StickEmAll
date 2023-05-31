import PureLayout

class AlbumPreviewView: UIView {
    
    private var title: UILabel!
    private var addView: UIImageView!
    var albumData: AlbumModel?
    private var colorID: Int = 0
    
    private var exchangeInBtn: UIButton!
    private var exchangeOutBtn: UIButton!
    var codeInputView: CodeInputView!
    var codeOutputVIew: CodeOutputView!
    
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
        
        exchangeInBtn = UIButton()
        addSubview(exchangeInBtn)
        exchangeInBtn.addTarget(self, action: #selector(handleInBtn), for: .touchUpInside)
        
        exchangeOutBtn = UIButton()
        addSubview(exchangeOutBtn)
        exchangeOutBtn.addTarget(self, action: #selector(handleOutBtn), for: .touchUpInside)
        
        codeInputView = CodeInputView()
        addSubview(codeInputView)
        
        codeOutputVIew = CodeOutputView()
        addSubview(codeOutputVIew)
    }
    
    private func styleViews() {
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
        
        exchangeInBtn.backgroundColor = .lightRed
        exchangeInBtn.setTitle("In", for: .normal)
        exchangeInBtn.layer.cornerRadius = 10
        
        exchangeOutBtn.backgroundColor = .lightRed
        exchangeOutBtn.setTitle("Out", for: .normal)
        exchangeOutBtn.layer.cornerRadius = 10
        
        codeInputView.isHidden = true
        codeOutputVIew.isHidden = true
    }
    
    private func defineLayoutForViews() {
        title.autoPinEdgesToSuperviewEdges()
        
        exchangeInBtn.autoPinEdge(toSuperviewEdge: .bottom, withInset: 30)
        exchangeInBtn.autoPinEdge(toSuperviewEdge: .leading, withInset: 30)
        exchangeInBtn.autoSetDimensions(to: CGSize(width: 50, height: 50))
        self.bringSubviewToFront(exchangeInBtn)
        
        exchangeOutBtn.autoPinEdge(toSuperviewEdge: .bottom, withInset: 30)
        exchangeOutBtn.autoPinEdge(toSuperviewEdge: .trailing, withInset: 30)
        exchangeOutBtn.autoSetDimensions(to: CGSize(width: 50, height: 50))
        self.bringSubviewToFront(exchangeOutBtn)
        
        addView.autoAlignAxis(toSuperviewAxis: .vertical)
        addView.autoAlignAxis(toSuperviewAxis: .horizontal)
        addView.autoSetDimension(.width, toSize: 100)
        addView.autoMatch(.height, to: .width, of: addView)
        
        codeInputView.autoPinEdgesToSuperviewEdges()
        bringSubviewToFront(codeInputView)
        
        codeOutputVIew.autoPinEdgesToSuperviewEdges()
        bringSubviewToFront(codeOutputVIew)
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
        exchangeInBtn.isHidden = colorID == 0 ? false : true
        exchangeOutBtn.isHidden = colorID == 0 ? false : true
    }
    
    @objc private func handleInBtn() {
        codeInputView.isHidden = false
    }
    
    @objc private func handleOutBtn() {
        codeOutputVIew.isHidden = false
    }
}
