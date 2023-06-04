
import Foundation
import UIKit
import PureLayout

class ExchangeCollectionView: UIView {
    
    private var stickerList: [Int]!
    private var collectionView: UICollectionView!
    private let direction: Int
    
    init(listOfStickers: [Int], direction: Int) {
        stickerList = listOfStickers
        self.direction = direction
        super.init(frame: .zero)
        buildViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildViews() {
        createViews()
        styleViews()
        defineLayout()
    }
    
    private func createViews() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.itemSize = CGSize(width: 100, height: 80)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ExchangeStickerCell.self, forCellWithReuseIdentifier: ExchangeStickerCell.reuseIdentifier)
        addSubview(collectionView)
    }
    
    private func styleViews() {
        collectionView.backgroundColor = .white
    }
    
    private func defineLayout() {
        collectionView.autoPinEdgesToSuperviewEdges()
    }
    
    func setStickersList(listOfStickers: [Int]) {
        stickerList = listOfStickers
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

extension ExchangeCollectionView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        stickerList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExchangeStickerCell.reuseIdentifier, for: indexPath) as? ExchangeStickerCell else { fatalError() }
        let number = stickerList[indexPath.item]
        cell.setData(number: number, direcionOfExchange: direction)
        return cell
    }
}
