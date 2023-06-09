
import Foundation
import UIKit

protocol AppRouterProtocol {
    func setStartScreen(in window: UIWindow?)
}

class Router: AppRouterProtocol{
    
    private var albumDataSource: AlbumDataSource!
    private var navigationController: UINavigationController?
    
    init(with navigationController: UINavigationController, dataSource: AlbumDataSource) {
        self.navigationController = navigationController
        albumDataSource = dataSource
    }
    
    func setStartScreen(in window: UIWindow?) {
        let logoViewController = LogoViewController(router: self)
        navigationController?.pushViewController(logoViewController, animated: true)
        navigationController?.navigationBar.tintColor = .black
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    func changeToPickerScreen() {
        let albumPickerViewModel = AlbumPickerViewModel(dataSource: albumDataSource)
        let albumPickerViewController = AlbumPickerViewController(viewModel: albumPickerViewModel, router: self)
        navigationController?.setViewControllers([albumPickerViewController], animated: true)
    }
    
    func openAlbumDetails(code: String) {
        let albumStickersViewModel = AlbumStickersViewModel(dataSource: albumDataSource, albumCode: code)
        let albumStickersViewController = AlbumStickersViewController(viewModel: albumStickersViewModel, router: self)
        navigationController?.pushViewController(albumStickersViewController, animated: true)
    }
    
    func openCreateAlbum() {
        let createAlbumViewModel = CreateAlbumViewModel(dataSource: albumDataSource)
        let createAlbumViewController = CreateAlbumViewController(viewModel: createAlbumViewModel, router: self)
        navigationController?.pushViewController(createAlbumViewController, animated: true)
    }
    
    func addedAlbum() {
        navigationController?.popViewController(animated: true)
    }
    
    func scannedCode(code: String) {
        if (code.trimmingCharacters(in: .whitespacesAndNewlines).count == 0) {
            navigationController?.popViewController(animated: true)
            return
        }
        let exchangeViewModel = ExchangeViewModel(dataSource: albumDataSource, exchangeCode: code)
        let exchangeViewController = ExchangeViewController(viewModel: exchangeViewModel, router: self)
        navigationController?.popViewController(animated: false)
        navigationController?.pushViewController(exchangeViewController, animated: true)
    }
    
    func changeToScanScreen() {
        let scanExchangeViewController = ScanExchangeViewController(router: self)
        navigationController?.pushViewController(scanExchangeViewController, animated: true)
    }
    
    func handleExchange(code: String) {
        navigationController?.popViewController(animated: true)
        openAlbumDetails(code: code)
    }
}
