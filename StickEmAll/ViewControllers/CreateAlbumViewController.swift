import PureLayout

class CreateAlbumViewController: UIViewController {
    var viewTitle: UILabel!
    var barcodeView: AlbumBarcodeView!
    var formView: AlbumFormView!
    var createButton: UIButton!
    var createButtonLabel: UILabel!
    var viewModel: CreateAlbumViewModel!
    
    let padding = 20.0
    
    init(viewModel: CreateAlbumViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        createViews()
        styleViews()
        defineLayoutForViews()
    }
    
    private func createViews() {
        viewTitle = UILabel()
        view.addSubview(viewTitle)
        
        barcodeView = AlbumBarcodeView()
        view.addSubview(barcodeView)
        
        formView = AlbumFormView()
        view.addSubview(formView)
        
        createButton = UIButton()
        view.addSubview(createButton)
        
        createButtonLabel = UILabel()
        createButton.addSubview(createButtonLabel)
        createButton.addTarget(self, action: #selector(handleCreateTap), for: .touchUpInside)
    }
    
    private func styleViews() {
        view.backgroundColor = .white
        
        viewTitle.text = "New album"
        
        createButton.setTitleColor(.black, for: .normal)
        createButton.layer.borderWidth = 1.0
        createButton.layer.cornerRadius = 10
        createButton.backgroundColor = .blue
        
        createButtonLabel.text = "Add new album"
        createButtonLabel.textColor = .white
    }
    
    private func defineLayoutForViews() {
        viewTitle.autoAlignAxis(toSuperviewAxis: .vertical)
        viewTitle.autoPinEdge(toSuperviewSafeArea: .top, withInset: padding)
        
        barcodeView.autoAlignAxis(toSuperviewAxis: .vertical)
        barcodeView.autoPinEdge(.top, to: .bottom, of: viewTitle, withOffset: padding)
        barcodeView.autoMatch(.width, to: .width, of: view, withMultiplier: 0.75)
        barcodeView.autoSetDimension(.height, toSize: 200)
        
        formView.autoAlignAxis(toSuperviewAxis: .vertical)
        formView.autoPinEdge(.top, to: .bottom, of: barcodeView, withOffset: padding)
        formView.autoMatch(.width, to: .width, of: view, withMultiplier: 0.75)
        
        createButton.autoAlignAxis(toSuperviewAxis: .vertical)
        createButton.autoPinEdge(.top, to: .bottom, of: formView, withOffset: padding)
        createButton.autoPinEdge(toSuperviewSafeArea: .bottom, withInset: padding)
        
        createButtonLabel.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets.init(top: 4, left: 8, bottom: 4, right: 8))
    }
    
    @objc func handleCreateTap() {
        let code = formView.inputFieldCode.inputField.text!
        let name = formView.inputFieldName.inputField.text!
        let numberOfStickers = Int(formView.inputFieldStickerNumber.inputField.text!) ?? 0
        let numberOfStickerPerPack = Int(formView.inputFieldStickerNumber.inputField.text!) ?? 0
        viewModel.createAlbum(code: code, name: name, numberOfSticker: numberOfStickers, numberOfStickerPerPack: numberOfStickerPerPack)
    }
}
