import PureLayout

class CreateAlbumViewController: UIViewController {
    
    private let router: Router!
    
    var viewTitle: UILabel!
    var barcodeView: AlbumBarcodeView!
    var formView: AlbumFormView!
    var createButton: UIButton!
    var createButtonLabel: UILabel!
    var viewModel: CreateAlbumViewModel!
    
    let padding = 20.0
    
    init(viewModel: CreateAlbumViewModel, router: Router) {
        self.viewModel = viewModel
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        createViews()
        styleViews()
        defineLayoutForViews()
        self.hideKeyboardWhenTappedAround()
    }
    
    private func createViews() {
        viewTitle = UILabel()
        navigationItem.titleView = viewTitle
        
        formView = AlbumFormView()
        view.addSubview(formView)
        
        barcodeView = AlbumBarcodeView { [weak self] barCode in
            self?.formView.inputFieldCode.inputField.text = barCode
        }
        view.addSubview(barcodeView)
        
        createButton = UIButton()
        view.addSubview(createButton)
        
        createButtonLabel = UILabel()
        createButton.addSubview(createButtonLabel)
        createButton.addTarget(self, action: #selector(handleCreateTap), for: .touchUpInside)
    }
    
    private func styleViews() {
        view.backgroundColor = .white
        
        viewTitle.text = "New album"
        viewTitle.font = .boldSystemFont(ofSize: 30)
        
        createButton.setTitleColor(.black, for: .normal)
        createButton.layer.cornerRadius = 10
        createButton.backgroundColor = .lightBlurple
        
        createButtonLabel.text = "Add album"
        createButtonLabel.textColor = .white
        createButtonLabel.font = .boldSystemFont(ofSize: 22)
    }
    
    private func defineLayoutForViews() {
        barcodeView.autoAlignAxis(toSuperviewAxis: .vertical)
        barcodeView.autoPinEdge(toSuperviewSafeArea: .top, withInset: padding)
        barcodeView.autoMatch(.width, to: .width, of: view, withMultiplier: 0.85)
        barcodeView.autoSetDimension(.height, toSize: 200)
        
        formView.autoAlignAxis(toSuperviewAxis: .vertical)
        formView.autoPinEdge(.top, to: .bottom, of: barcodeView, withOffset: padding)
        formView.autoMatch(.width, to: .width, of: view, withMultiplier: 0.85)
        
        createButton.autoAlignAxis(toSuperviewAxis: .vertical)
        createButton.autoPinEdge(.top, to: .bottom, of: formView, withOffset: padding)
        createButton.autoPinEdge(toSuperviewSafeArea: .bottom, withInset: padding)
        
        createButtonLabel.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets.init(top: 4, left: 8, bottom: 4, right: 8))
    }
    
    @objc func handleCreateTap() {
        let code = formView.inputFieldCode.inputField.text!
        let name = formView.inputFieldName.inputField.text!
        let numberOfStickers = Int(formView.inputFieldStickerNumber.inputField.text!) ?? 0
        let numberOfStickerPerPack = Int(formView.inputFieldPacketCount.inputField.text!) ?? 0
        viewModel.createAlbum(code: code, name: name, numberOfSticker: numberOfStickers, numberOfStickerPerPack: numberOfStickerPerPack)
        router.addedAlbum()
    }
    
    
}
