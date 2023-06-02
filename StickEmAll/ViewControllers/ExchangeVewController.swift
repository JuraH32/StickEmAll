
import Foundation
import PureLayout
import UIKit
import Combine

class ExchangeViewController: UIViewController {
    
    private let viewModel: ExchangeViewModel
    private let router: Router
    private var exchangeData: Exchange?
    private var disposable = Set<AnyCancellable>()
    
    private var albumNameLabel: UILabel!
    private var contentContainer: UIView!
    var recieveCollectionView: UICollectionView!
    var giveCollectionView: UICollectionView!
    private var exchangeButton: UIButton!
    private var exchangeView: UIView!
    private var exchangeLabel: UILabel!
    private var exchangeImageView: UIImageView!
    
    init (viewModel: ExchangeViewModel, router: Router) {
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
    
    private func createViews() {
        albumNameLabel = UILabel()
        view.addSubview(albumNameLabel)
        
        contentContainer = UIView()
        view.addSubview(contentContainer)
        
        exchangeButton = UIButton()
        contentContainer.addSubview(exchangeButton)
        exchangeButton.addTarget(self, action: #selector(handleExchange), for: .touchUpInside)
        
        exchangeView = UIView()
        exchangeButton.addSubview(exchangeView)
        
        exchangeLabel = UILabel()
        exchangeView.addSubview(exchangeLabel)
        
        exchangeImageView = UIImageView()
        exchangeView.addSubview(exchangeImageView)
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        flowLayout.minimumInteritemSpacing = 10 // ?
        flowLayout.itemSize = CGSize(width: 100, height: 80)
        
        recieveCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        recieveCollectionView.dataSource = self
        recieveCollectionView.delegate = self
        recieveCollectionView.register(ExchangeStickerCell.self, forCellWithReuseIdentifier: ExchangeStickerCell.reuseIdentifier)
        contentContainer.addSubview(recieveCollectionView)
        
        giveCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        giveCollectionView.dataSource = self
        giveCollectionView.delegate = self
        giveCollectionView.register(ExchangeStickerCell.self, forCellWithReuseIdentifier: ExchangeStickerCell.reuseIdentifier)
        contentContainer.addSubview(giveCollectionView)
        
    }
    
    private func styleViews() {
        view.backgroundColor = .white
        contentContainer.backgroundColor = .white
        
        albumNameLabel.backgroundColor = .lightRed
        albumNameLabel.textColor = .white
        albumNameLabel.font = .boldSystemFont(ofSize: 32)
        albumNameLabel.textAlignment = .center
        albumNameLabel.numberOfLines = 0
        albumNameLabel.lineBreakMode = .byWordWrapping
        
        exchangeButton.backgroundColor = .blurple.withAlphaComponent(0.8)
        exchangeButton.layer.cornerRadius = 15
        
        exchangeLabel.text = "Exchange"
        exchangeLabel.font = .boldSystemFont(ofSize: 24)
        exchangeLabel.textColor = .white
        
        let iconConfig = UIImage.SymbolConfiguration(pointSize: 24, weight: .medium)
        let icon = UIImage(systemName: "arrow.up.arrow.down", withConfiguration: iconConfig)
        exchangeImageView.image = icon
        exchangeImageView.tintColor = .white
        exchangeImageView.contentMode = .scaleAspectFit
    }
    
    private func defineLayout() {
        albumNameLabel.autoPinEdge(toSuperviewSafeArea: .top)
        albumNameLabel.autoPinEdge(toSuperviewSafeArea: .leading)
        albumNameLabel.autoPinEdge(toSuperviewSafeArea: .trailing)
        albumNameLabel.autoSetDimension(.height, toSize: 100)
        
        exchangeButton.autoCenterInSuperview()
        exchangeButton.autoSetDimension(.height, toSize: 50)
        exchangeButton.autoMatch(.width, to: .width, of: exchangeView, withOffset: 30)
        
        exchangeView.autoCenterInSuperview()
        exchangeView.autoPinEdge(toSuperviewEdge: .top)
        exchangeView.autoPinEdge(toSuperviewEdge: .bottom)
        
        exchangeLabel.autoPinEdge(toSuperviewEdge: .top)
        exchangeLabel.autoPinEdge(toSuperviewEdge: .bottom)
        exchangeLabel.autoPinEdge(toSuperviewEdge: .trailing)
        exchangeLabel.autoPinEdge(.leading, to: .trailing, of: exchangeImageView, withOffset: 20)
        
        exchangeImageView.autoPinEdge(toSuperviewEdge: .top)
        exchangeImageView.autoPinEdge(toSuperviewEdge: .bottom)
        exchangeImageView.autoPinEdge(toSuperviewEdge: .leading)
        
        contentContainer.autoPinEdge(.top, to: .bottom, of: albumNameLabel)
        contentContainer.autoPinEdge(toSuperviewSafeArea: .bottom)
        contentContainer.autoPinEdge(toSuperviewSafeArea: .leading)
        contentContainer.autoPinEdge(toSuperviewSafeArea: .trailing)
        
        giveCollectionView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .bottom)
        giveCollectionView.autoPinEdge(.bottom, to: .top, of: exchangeButton)
        
        recieveCollectionView.autoPinEdge(.top, to: .bottom, of: exchangeButton)
        recieveCollectionView.autoPinEdge(toSuperviewEdge: .leading)
        recieveCollectionView.autoPinEdge(toSuperviewEdge: .trailing)
        recieveCollectionView.autoPinEdge(toSuperviewEdge: .bottom)
    }
    
    private func bindData() {
        viewModel.$exchange.sink{ [weak self] exchange in
            self?.exchangeData = exchange
            DispatchQueue.main.async {
                self?.albumNameLabel.text = self?.exchangeData?.name
            }
        }.store(in: &disposable)
    }
    
    @objc func handleExchange() {
        // TODO
        router.handleExchange()
    }
}

extension ExchangeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == recieveCollectionView {
            return exchangeData != nil ? exchangeData!.recieve.count : 0
        } else if collectionView == giveCollectionView {
            return exchangeData != nil ? exchangeData!.give.count : 0
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExchangeStickerCell.reuseIdentifier, for: indexPath) as? ExchangeStickerCell else { fatalError() }
        var number = 0
        var direction = 0
        if collectionView == recieveCollectionView {
            number = exchangeData != nil ? exchangeData!.recieve[indexPath.item] : 0
            direction = 1
        } else if collectionView == giveCollectionView{
            number = exchangeData != nil ? exchangeData!.give[indexPath.item] : 0
            direction = -1
        }
        cell.setData(number: number, direcionOfExchange: direction)
        return cell
    }
}

