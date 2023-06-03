
import Foundation
import PureLayout
import UIKit
import Combine

class ExchangeViewController: UIViewController {
    
    private let viewModel: ExchangeViewModel
    private let router: Router
    private var exchangeData: Exchange?
    private var recieveList: [Int] = []
    private var giveList: [Int] = []
    private var disposable = Set<AnyCancellable>()
    
    private var albumNameLabel: UILabel!
    private var contentContainer: UIView!
    var recieveCollectionView: ExchangeCollectionView!
    var giveCollectionView: ExchangeCollectionView!
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
        
        exchangeView = UIView()
        contentContainer.addSubview(exchangeView)
        
        let touchGesture = UITapGestureRecognizer(target: self, action: #selector(handleExchange(_:)))
        touchGesture.numberOfTapsRequired = 1
        touchGesture.numberOfTouchesRequired = 1
        exchangeView.addGestureRecognizer(touchGesture)
        
        exchangeLabel = UILabel()
        exchangeView.addSubview(exchangeLabel)
        
        exchangeImageView = UIImageView()
        exchangeView.addSubview(exchangeImageView)
        
        giveCollectionView = ExchangeCollectionView(listOfStickers: giveList, direction: -1)
        contentContainer.addSubview(giveCollectionView)
        
        recieveCollectionView = ExchangeCollectionView(listOfStickers: recieveList, direction: 1)
        contentContainer.addSubview(recieveCollectionView)
        
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
        
        exchangeView.backgroundColor = .blurple.withAlphaComponent(0.8)
        exchangeView.layer.cornerRadius = 15
        
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
        
        exchangeView.autoCenterInSuperview()
        exchangeView.autoSetDimension(.height, toSize: 50)
        
        exchangeLabel.autoPinEdge(toSuperviewEdge: .top)
        exchangeLabel.autoPinEdge(toSuperviewEdge: .bottom)
        exchangeLabel.autoPinEdge(toSuperviewEdge: .trailing, withInset: 20)
        exchangeLabel.autoPinEdge(.leading, to: .trailing, of: exchangeImageView, withOffset: 20)
        
        exchangeImageView.autoPinEdge(toSuperviewEdge: .top)
        exchangeImageView.autoPinEdge(toSuperviewEdge: .bottom)
        exchangeImageView.autoPinEdge(toSuperviewEdge: .leading, withInset: 20)
        
        contentContainer.autoPinEdge(.top, to: .bottom, of: albumNameLabel)
        contentContainer.autoPinEdge(toSuperviewSafeArea: .bottom)
        contentContainer.autoPinEdge(toSuperviewSafeArea: .leading)
        contentContainer.autoPinEdge(toSuperviewSafeArea: .trailing)
        
        giveCollectionView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .bottom)
        giveCollectionView.autoPinEdge(.bottom, to: .top, of: exchangeView)
        
        recieveCollectionView.autoPinEdge(.top, to: .bottom, of: exchangeView)
        recieveCollectionView.autoPinEdge(toSuperviewEdge: .leading)
        recieveCollectionView.autoPinEdge(toSuperviewEdge: .trailing)
        recieveCollectionView.autoPinEdge(toSuperviewEdge: .bottom)
    }
    
    private func bindData() {
        viewModel.$exchange.sink{ [weak self] exchange in
            self?.exchangeData = exchange
            DispatchQueue.main.async { [self] in
                self?.albumNameLabel.text = self?.exchangeData?.name
                self?.recieveList = self?.exchangeData?.recieve ?? []
                self?.recieveCollectionView.setStickersList(listOfStickers: self!.recieveList)
                self?.giveList = self?.exchangeData?.give ?? []
                self?.giveCollectionView.setStickersList(listOfStickers: self!.giveList)
            }
        }.store(in: &disposable)
    }
    
    @objc func handleExchange(_ gestureRecognizer: UITapGestureRecognizer) {
        if gestureRecognizer.state == .ended {
            viewModel.updateStickers()
            router.handleExchange(code: exchangeData?.code ?? "")
        }
    }
}
