import PureLayout
import Combine

class AlbumPickerViewController: UIViewController {
    
    private let router: Router
    private let viewModel: AlbumPickerViewModel
    
    private var viewTitleLabel: UILabel!
    private var currentAlbum: AlbumPreviewView!
    private var nextAlbum: AlbumPreviewView!
    private var previousAlbum: AlbumPreviewView!
    private var nextButton: UIButton!
    private var previousButton: UIButton!
    private var albumStatsView: AlbumStatsView!
    
    private var scanCodeBtn: UIButton!
    
    private var disposables = Set<AnyCancellable>()
    private var albums: [AlbumModel]!
    
    private var albumIndex = 0
    
    private let padding = 80.0
    
    let statsViewMinHeight: CGFloat = 200
    var statsViewMaxHeight: CGFloat!
    var bottomViewTopConstraint: NSLayoutConstraint!
    
    init (viewModel: AlbumPickerViewModel, router: Router) {
        self.router = router
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createViews()
        styleViews()
        defineLayoutForViews()
        bindData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.reloadAlbums()
    }
    
    override func viewDidLayoutSubviews() {
        albumStatsView.viewHeader.addCornerRadiusToTopCorners(radius: 50)
    }
    
    private func createViews() {
        viewTitleLabel = UILabel()
        view.addSubview(viewTitleLabel)
        
        currentAlbum = AlbumPreviewView()
        view.addSubview(currentAlbum)
        nextAlbum = AlbumPreviewView()
        view.addSubview(nextAlbum)
        previousAlbum = AlbumPreviewView()
        view.addSubview(previousAlbum)
        
        nextButton = UIButton()
        nextButton.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
        view.addSubview(nextButton)
        view.bringSubviewToFront(nextButton)
        previousButton = UIButton()
        previousButton.addTarget(self, action: #selector(handlePrevious), for: .touchUpInside)
        view.addSubview(previousButton)
        view.bringSubviewToFront(previousButton)
        
        albumStatsView = AlbumStatsView(statsViewMinHeight: statsViewMinHeight)
        view.addSubview(albumStatsView)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleStatsPan(_:)))
        albumStatsView.addGestureRecognizer(panGesture)
        
        let touchStatsGesture = UITapGestureRecognizer(target: self, action: #selector(handleStatsTap(_:)))
        touchStatsGesture.numberOfTapsRequired = 1
        touchStatsGesture.numberOfTouchesRequired = 1
        albumStatsView.addGestureRecognizer(touchStatsGesture)
        
        let touchAnywhereGesture = UITapGestureRecognizer(target: self, action: #selector(handleStatsClose(_:)))
        touchAnywhereGesture.numberOfTapsRequired = 1
        touchAnywhereGesture.numberOfTouchesRequired = 1
        view.addGestureRecognizer(touchAnywhereGesture)
        
        let touchGesture = UITapGestureRecognizer(target: self, action: #selector(handleOpenDetails(_:)))
        touchGesture.numberOfTapsRequired = 1
        touchGesture.numberOfTouchesRequired = 1
        currentAlbum.addGestureRecognizer(touchGesture)
        
        scanCodeBtn = UIButton()
        view.addSubview(scanCodeBtn)
        scanCodeBtn.addTarget(self, action: #selector(handleScan), for: .touchUpInside)
    }
    
    private func styleViews() {
        view.backgroundColor = .white
        view.clipsToBounds = false
        
        viewTitleLabel.text = "My Albums"
        viewTitleLabel.textAlignment = .center
        viewTitleLabel.font = .boldSystemFont(ofSize: 30)
        
        let nextArrow = UIImage(systemName: "chevron.right.circle")
        nextButton.setImage(nextArrow, for: .normal)
        nextButton.contentVerticalAlignment = .fill
        nextButton.contentHorizontalAlignment = .fill
        nextButton.tintColor = .black.withAlphaComponent(0.9)
        let previousArrow = UIImage(systemName: "chevron.left.circle")
        previousButton.setImage(previousArrow, for: .normal)
        previousButton.contentVerticalAlignment = .fill
        previousButton.contentHorizontalAlignment = .fill
        previousButton.tintColor = .black.withAlphaComponent(0.9)
        
        scanCodeBtn.layer.cornerRadius = 32
        scanCodeBtn.backgroundColor = .lightRed
        scanCodeBtn.setImage(UIImage(systemName: "qrcode.viewfinder", withConfiguration: UIImage.SymbolConfiguration(pointSize: 36, weight: .bold)), for: .normal)
        scanCodeBtn.tintColor = .white
    }
    
    private func defineLayoutForViews() {
        viewTitleLabel.autoPinEdge(toSuperviewSafeArea: .top)
        viewTitleLabel.autoPinEdge(toSuperviewSafeArea: .leading, withInset: padding)
        viewTitleLabel.autoPinEdge(toSuperviewSafeArea: .trailing, withInset: padding)
        viewTitleLabel.autoSetDimension(.height, toSize: 35)
        
        scanCodeBtn.autoPinEdge(toSuperviewSafeArea: .trailing, withInset: 20)
        scanCodeBtn.autoSetDimension(.width, toSize: 64)
        scanCodeBtn.autoMatch(.height, to: .width, of: scanCodeBtn)
        scanCodeBtn.autoAlignAxis(.horizontal, toSameAxisOf: viewTitleLabel)
        view.bringSubviewToFront(scanCodeBtn)
        
        currentAlbum.autoPinEdge(toSuperviewSafeArea: .leading, withInset: padding)
        currentAlbum.autoPinEdge(toSuperviewSafeArea: .trailing, withInset: padding)
        currentAlbum.autoPinEdge(.top, to: .bottom, of: viewTitleLabel, withOffset: 40)
        currentAlbum.autoPinEdge(toSuperviewSafeArea: .bottom, withInset: 200)
        
        nextAlbum.autoPinEdge(.leading, to: .trailing, of: currentAlbum, withOffset: padding / 4)
        nextAlbum.autoAlignAxis(.horizontal, toSameAxisOf: currentAlbum)
        nextAlbum.autoMatch(.height, to: .height, of: currentAlbum, withMultiplier: 0.5)
        nextAlbum.autoMatch(.width, to: .width, of: currentAlbum, withMultiplier: 0.5)
        
        previousAlbum.autoPinEdge(.trailing, to: .leading, of: currentAlbum, withOffset: -padding / 4)
        previousAlbum.autoAlignAxis(.horizontal, toSameAxisOf: currentAlbum)
        previousAlbum.autoMatch(.height, to: .height, of: currentAlbum, withMultiplier: 0.5)
        previousAlbum.autoMatch(.width, to: .width, of: currentAlbum, withMultiplier: 0.5)
        
        nextButton.autoPinEdge(.top, to: .bottom, of: nextAlbum, withOffset: 30)
        nextButton.autoPinEdge(toSuperviewSafeArea: .trailing, withInset: padding / 4 - 15)
        nextButton.autoSetDimension(.height, toSize: 48)
        nextButton.autoSetDimension(.width, toSize: 48)
        
        previousButton.autoPinEdge(.top, to: .bottom, of: previousAlbum, withOffset: 30)
        previousButton.autoPinEdge(toSuperviewSafeArea: .leading, withInset: padding / 4 - 15)
        previousButton.autoSetDimension(.height, toSize: 48)
        previousButton.autoSetDimension(.width, toSize: 48)
        
        bottomViewTopConstraint = albumStatsView.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -statsViewMinHeight)
        albumStatsView.autoPinEdgesToSuperviewSafeArea(with: .zero, excludingEdge: .top)
        NSLayoutConstraint.activate([
            bottomViewTopConstraint,
        ])
        statsViewMaxHeight = view.frame.height * 0.7
        
        currentAlbum.codeView.isHidden = true
    }
    
    private func bindData() {
        viewModel.$albums
            .receive(on: DispatchQueue.main)
            .sink { [weak self] albums in
                var albumsData = albums
                albumsData.append(AlbumModel(code: "", name: "", numberOfStickers: 1))
                self?.albums = albumsData
                self?.updateAlbumPreviews()
            }
            .store(in: &disposables)
    }
    
    private func updateAlbumPreviews() {
        currentAlbum.codeView.isHidden = true
        
        guard !albums.isEmpty else { return }
        let previous = albumIndex > 0 ? albums[albumIndex - 1] : nil
        previousAlbum.updateData(albumData: previous, colorID: 1)
        let current = albums[albumIndex]
        if (current.code != "") {
            currentAlbum.updateData(albumData: current, colorID: 0)
            albumStatsView.isHidden = false
            nextButton.isHidden = false
            currentAlbum.codeView.loadCode(code: currentAlbum.albumData?.exchangeCode ?? "")
        } else {
            currentAlbum.updateData(albumData: current, colorID: 2)
            albumStatsView.isHidden = true
            nextButton.isHidden = true
        }
        previousButton.isHidden = albumIndex == 0 ? true : false
        albumStatsView.setAlbumData(albumData: current)
        let next = albumIndex < albums.count - 1 ? albums[albumIndex + 1] : nil
        nextAlbum.updateData(albumData: next, colorID: 1)
    }
    
    @objc private func handleNext() {
        albumIndex += 1
        albumIndex = (albumIndex >= albums.count) ? albums.count - 1 : albumIndex
        updateAlbumPreviews()
    }
    
    @objc private func handlePrevious() {
        albumIndex -= 1
        albumIndex = albumIndex < 0 ? 0 : albumIndex
        updateAlbumPreviews()
    }
    
    @objc func handleStatsPan(_ gestureRecognizer: UIPanGestureRecognizer) {
        guard gestureRecognizer.view != nil else { return }

        let translation = gestureRecognizer.translation(in: view)

        switch gestureRecognizer.state {
        case .changed:
            let newY = -bottomViewTopConstraint.constant - translation.y
            bottomViewTopConstraint.constant = -min(statsViewMaxHeight, max(statsViewMinHeight, newY))
            gestureRecognizer.setTranslation(.zero, in: view)
        case .ended, .cancelled:
            let isExpanded = -bottomViewTopConstraint.constant - statsViewMinHeight > statsViewMaxHeight + bottomViewTopConstraint.constant

            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                if isExpanded {
                    self.bottomViewTopConstraint.constant = -self.statsViewMaxHeight
                } else {
                    self.bottomViewTopConstraint.constant = -self.statsViewMinHeight
                }
                self.view.layoutIfNeeded()
            })
        default:
            break
        }
    }
    
    @objc func handleStatsTap(_ gestureRecognizer: UITapGestureRecognizer) {
        if gestureRecognizer.state == .ended {
            if self.bottomViewTopConstraint.constant == -self.statsViewMinHeight {
                UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                    self.bottomViewTopConstraint.constant = -self.statsViewMaxHeight
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    
    @objc func handleStatsClose(_ gestureRecognizer: UITapGestureRecognizer) {
        if gestureRecognizer.state == .ended {
            if self.bottomViewTopConstraint.constant == -self.statsViewMaxHeight {
                UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                    self.bottomViewTopConstraint.constant = -self.statsViewMinHeight
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    
    @objc private func handleOpenDetails(_ gestureRecognizer: UITapGestureRecognizer) {
        if gestureRecognizer.state == .ended {
            if currentAlbum.albumData?.code == "" {
                router.openCreateAlbum()
            } else {
                router.openAlbumDetails(code: albums[albumIndex].code)
            }
        }
    }
    
    @objc func handleScan() {
        router.changeToScanScreen()
    }
}
