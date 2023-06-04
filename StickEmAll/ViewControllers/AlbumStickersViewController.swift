
import Foundation
import PureLayout
import UIKit
import Combine

class AlbumStickersViewController: UIViewController {
    
    private let viewModel: AlbumStickersViewModel
    private let router: Router
    
    private var stickersCollectionView: UICollectionView!
    private var collectionSuperview: UIView!
    private var albumNameLabel: UILabel!
    
    private var addModeButton: UIButton!
    private var cancelAddModeButton: UIButton!
    private var cancelmageView: UIImageView!
    private var finishAddModeButton: UIButton!
    private var finishImageView: UIImageView!
    private var modeSwitch: ModeSwitchView!
    
    private var albumDetails: AlbumModel?
    private var disposable = Set<AnyCancellable>()
    
    private var addMode: Bool = false
    private var stickerChanges: [Sticker] = []
    
    
    init (viewModel: AlbumStickersViewModel, router: Router) {
        self.router = router
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        createViews()
        styleViews()
        defineLayout()
        bindData()
    }
    
    override func viewDidLayoutSubviews() {
        collectionSuperview.addCornerRadiusToTopCorners(radius: 50)
    }
    
    private func createViews() {
        albumNameLabel = UILabel()
        view.addSubview(albumNameLabel)
        
        collectionSuperview = UIView()
        view.addSubview(collectionSuperview)
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.sectionInset = UIEdgeInsets(top: 30, left: 20, bottom: 30, right: 20)
        flowLayout.minimumInteritemSpacing = 15
        flowLayout.itemSize = CGSize(width: 75, height: 90)
        
        stickersCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        stickersCollectionView.dataSource = self
        stickersCollectionView.delegate = self
        stickersCollectionView.register(StickerCell.self, forCellWithReuseIdentifier: StickerCell.reuseIdentifier)
        collectionSuperview.addSubview(stickersCollectionView)
        
        addModeButton = UIButton()
        addModeButton.addTarget(self, action: #selector(startAddMode), for: .touchUpInside)
        view.addSubview(addModeButton)
        view.bringSubviewToFront(addModeButton)
        
        modeSwitch = ModeSwitchView()
        view.addSubview(modeSwitch)
        view.bringSubviewToFront(modeSwitch)
        
        cancelAddModeButton = UIButton()
        cancelAddModeButton.addTarget(self, action: #selector(cancelAddMode), for: .touchUpInside)
        view.addSubview(cancelAddModeButton)
        view.bringSubviewToFront(cancelAddModeButton)
        let cancelImage = UIImage(systemName: "x.circle")
        cancelmageView = UIImageView(image: cancelImage)
        cancelAddModeButton.addSubview(cancelmageView)
        
        finishAddModeButton = UIButton()
        finishAddModeButton.addTarget(self, action: #selector(finishAddMode), for: .touchUpInside)
        let finishImage = UIImage(systemName: "checkmark.circle")
        finishImageView = UIImageView(image: finishImage)
        finishAddModeButton.addSubview(finishImageView)
        view.addSubview(finishAddModeButton)
        view.bringSubviewToFront(finishAddModeButton)
    }
    
    private func styleViews() {
        view.backgroundColor = .white
        
        stickersCollectionView.backgroundColor = .lightYellow
        
        albumNameLabel.font = .boldSystemFont(ofSize: 30)
        albumNameLabel.text = "test"
        albumNameLabel.textAlignment = .center
        albumNameLabel.lineBreakMode = .byWordWrapping
        albumNameLabel.numberOfLines = 0
        
        addModeButton.layer.cornerRadius = 32
        addModeButton.backgroundColor = .lightRed 
        addModeButton.layer.borderWidth = 3
        addModeButton.layer.borderColor = UIColor.white.cgColor
        addModeButton.setImage(UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 24, weight: .bold)), for: .normal)
        addModeButton.tintColor = .white

        cancelmageView.tintColor = .red
        cancelAddModeButton.isHidden = true
        
        finishImageView.tintColor = .green
        finishAddModeButton.isHidden = true
        
        modeSwitch.isHidden = true
    }
    
    private func defineLayout() {
        albumNameLabel.autoPinEdge(toSuperviewSafeArea: .top)
        albumNameLabel.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 10)
        albumNameLabel.autoPinEdge(toSuperviewSafeArea: .trailing, withInset: 10)
        
        modeSwitch.autoAlignAxis(toSuperviewAxis: .vertical)
        modeSwitch.autoPinEdge(.top, to: .bottom, of: albumNameLabel, withOffset: 20)
        modeSwitch.autoMatch(.width, to: .width, of: view, withMultiplier: 0.5)
        
        finishAddModeButton.autoAlignAxis(.horizontal, toSameAxisOf: modeSwitch)
        finishAddModeButton.autoMatch(.height, to: .height, of: modeSwitch, withMultiplier: 1.2)
        finishAddModeButton.autoMatch(.width, to: .height, of: finishAddModeButton)
        finishAddModeButton.autoPinEdge(.leading, to: .trailing, of: modeSwitch, withOffset: 20)
        finishImageView.autoPinEdgesToSuperviewEdges()
        
        cancelAddModeButton.autoAlignAxis(.horizontal, toSameAxisOf: modeSwitch)
        cancelAddModeButton.autoMatch(.height, to: .height, of: finishAddModeButton)
        cancelAddModeButton.autoMatch(.width, to: .height, of: finishAddModeButton)
        cancelAddModeButton.autoPinEdge(.trailing, to: .leading, of: modeSwitch, withOffset: -20)
        cancelmageView.autoPinEdgesToSuperviewEdges()
        
        collectionSuperview.autoPinEdge(toSuperviewSafeArea: .bottom)
        collectionSuperview.autoPinEdge(toSuperviewSafeArea: .leading)
        collectionSuperview.autoPinEdge(toSuperviewSafeArea: .trailing)
        collectionSuperview.autoPinEdge(.top, to: .bottom, of: modeSwitch, withOffset: 20)
        
        stickersCollectionView.autoPinEdgesToSuperviewEdges()
        
        addModeButton.autoSetDimension(.width, toSize: 64)
        addModeButton.autoMatch(.height, to: .width, of: addModeButton)
        addModeButton.autoAlignAxis(toSuperviewAxis: .vertical)
        addModeButton.autoPinEdge(toSuperviewSafeArea: .bottom, withInset: 20)
    }
    
    private func bindData() {
        viewModel.$albumDetails.sink{ [weak self] album in
            self?.albumDetails = album
            var stickerChanges: [Sticker] = []
            if (self?.albumDetails?.numberOfStickers ?? 0 > 0) {
                for i in 1...(self?.albumDetails?.numberOfStickers ?? 1) {
                    stickerChanges.append(Sticker(number: i, numberCollected: 0))
                }
                self?.stickerChanges = stickerChanges
            }
            DispatchQueue.main.async {
                self?.albumNameLabel.text = self?.albumDetails?.name
            }
        }.store(in: &disposable)
    }
    
    @objc private func startAddMode() {
        toggleAddMode(state: true)
        DispatchQueue.main.async {
            self.stickersCollectionView.reloadData()
        }
    }
    
    @objc private func cancelAddMode() {
        toggleAddMode(state: false)
        resetStickerChange()
    }
    
    @objc private func finishAddMode() {
        toggleAddMode(state: false)
        viewModel.changeStickers(stickers: stickerChanges)
        resetStickerChange()
    }
    
    private func resetStickerChange() {
        for i in 0...((albumDetails?.numberOfStickers ?? 1) - 1)  {
            stickerChanges[i].numberCollected = 0
        }
        DispatchQueue.main.async {
            self.stickersCollectionView.reloadData()
        }
    }
    
    private func toggleAddMode(state: Bool) {
        addMode = state
        if (state) {
            addModeButton.isHidden = true
            modeSwitch.isHidden = false
            finishAddModeButton.isHidden = false
            cancelAddModeButton.isHidden = false
        } else {
            addModeButton.isHidden = false
            modeSwitch.isHidden = true
            finishAddModeButton.isHidden = true
            cancelAddModeButton.isHidden = true
        }
    }
    
    private func changeSticker(number: Int, noStickers: Int) {
        if !addMode {
            return
        }
        stickerChanges[number-1].numberCollected = max(stickerChanges[number-1].numberCollected + noStickers, 0 - (albumDetails?.stickers[number-1].numberCollected ?? 0))
        DispatchQueue.main.async {
            self.stickersCollectionView.reloadData()
        }
    }
}

extension AlbumStickersViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albumDetails != nil ? albumDetails!.numberOfStickers : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = stickersCollectionView.dequeueReusableCell(withReuseIdentifier: StickerCell.reuseIdentifier, for: indexPath) as? StickerCell else { fatalError() }
        let number = albumDetails != nil ? albumDetails!.stickers[indexPath.item].number : 0
        let collected = albumDetails != nil ? albumDetails!.stickers[indexPath.item].numberCollected : 0
        let stickerChange = stickerChanges[number-1].numberCollected
        cell.setData(number: number, collected: collected, change: stickerChange, addState: addMode) { [weak self] number in
            let noStickers = self?.modeSwitch.state != nil ? ((self?.modeSwitch.state)! ? 1 : -1) : 0
            self?.changeSticker(number: number, noStickers: noStickers)
        }
        return cell
    }
    
}
