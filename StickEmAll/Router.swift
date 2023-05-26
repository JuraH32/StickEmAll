
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
}
