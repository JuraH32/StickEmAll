
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
    private var modeSwitch: ModeSwitchView!
    
    private var albumDetails: AlbumModel?
    private var disposable = Set<AnyCancellable>()
    
    
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
        flowLayout.minimumInteritemSpacing = 15 // ?
        flowLayout.itemSize = CGSize(width: 75, height: 90)
        
        stickersCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        stickersCollectionView.dataSource = self
        stickersCollectionView.delegate = self
        stickersCollectionView.register(StickerCell.self, forCellWithReuseIdentifier: StickerCell.reuseIdentifier)
        collectionSuperview.addSubview(stickersCollectionView)
        
        addModeButton = UIButton()
        view.addSubview(addModeButton)
        view.bringSubviewToFront(addModeButton)
        
        modeSwitch = ModeSwitchView()
        view.addSubview(modeSwitch)
        view.bringSubviewToFront(modeSwitch)
    }
    
    private func styleViews() {
        view.backgroundColor = .white
        
        stickersCollectionView.backgroundColor = .lightYellow
        
        albumNameLabel.font = .boldSystemFont(ofSize: 30)
        albumNameLabel.text = "test"
        albumNameLabel.textAlignment = .center
        albumNameLabel.lineBreakMode = .byWordWrapping
        albumNameLabel.numberOfLines = 0
        
<<<<<<< HEAD
=======
        albumNameLabel.font = .boldSystemFont(ofSize: 36)
        
        addModeButton.layer.cornerRadius = 32
        addModeButton.backgroundColor = .blue
        addModeButton.setTitle("+", for: .normal)
        
>>>>>>> 230b4c2 (saving changes)
    }
    
    private func defineLayout() {
        albumNameLabel.autoPinEdge(toSuperviewSafeArea: .top)
        albumNameLabel.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 10)
        albumNameLabel.autoPinEdge(toSuperviewSafeArea: .trailing, withInset: 10)
        
        collectionSuperview.autoPinEdge(toSuperviewSafeArea: .bottom)
        collectionSuperview.autoPinEdge(toSuperviewSafeArea: .leading)
        collectionSuperview.autoPinEdge(toSuperviewSafeArea: .trailing)
        collectionSuperview.autoPinEdge(.top, to: .bottom, of: albumNameLabel, withOffset: 20)
        
        stickersCollectionView.autoPinEdgesToSuperviewEdges()
        
        addModeButton.autoSetDimension(.width, toSize: 64)
        addModeButton.autoMatch(.height, to: .width, of: addModeButton)
        addModeButton.autoAlignAxis(toSuperviewAxis: .vertical)
        addModeButton.autoPinEdge(toSuperviewSafeArea: .bottom, withInset: 20)
        
        modeSwitch.autoAlignAxis(toSuperviewAxis: .vertical)
        modeSwitch.autoPinEdge(.top, to: .bottom, of: albumNameLabel, withOffset: 20)
        modeSwitch.autoMatch(.width, to: .width, of: view, withMultiplier: 0.5)
//
    }
    
    private func bindData() {
        viewModel.$albumDetails.sink{ [weak self] album in
            self?.albumDetails = album
            DispatchQueue.main.async {
                self?.albumNameLabel.text = self?.albumDetails?.name
            }
        }.store(in: &disposable)
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
        cell.setData(number: number, collected: collected)
        return cell
    }
    
}
