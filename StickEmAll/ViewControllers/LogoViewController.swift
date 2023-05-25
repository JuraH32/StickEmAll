
import Foundation
import UIKit
import PureLayout

class LogoViewController: UIViewController {
    
    private var logoImageView: UIImageView!
    private var logoImage: UIImage!
    
    private let router: Router
    
    init(router: Router) {
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        createViews()
        styleViews()
        defineLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
                
        logoImageView.transform = logoImageView.transform.rotated(by: .pi)
        logoImageView.alpha = 0
    }
            
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate( withDuration: 0.5, animations: {
            self.logoImageView.transform = .identity
            self.logoImageView.alpha = 1
        })
    }
    
    private func createViews() {
        logoImage = UIImage(named: "StickEmAll_icon.png")
        
        logoImageView = UIImageView()
        view.addSubview(logoImageView)
        
        let touchAnywhereGesture = UITapGestureRecognizer(target: self, action: #selector(handleNextScreen(_:)))
        touchAnywhereGesture.numberOfTapsRequired = 1
        touchAnywhereGesture.numberOfTouchesRequired = 1
        view.addGestureRecognizer(touchAnywhereGesture)
    }
    
    private func styleViews() {
        
        logoImageView.image = logoImage
        logoImageView.contentMode = .scaleAspectFit
        
        view.backgroundColor = .white
    }
    
    private func defineLayout() {
        logoImageView.autoMatch(.width, to: .width, of: view, withOffset: -80)
        logoImageView.autoAlignAxis(toSuperviewAxis: .horizontal)
        logoImageView.autoAlignAxis(toSuperviewAxis: .vertical)
    }
    
    @objc private func handleNextScreen(_ gestureRecognizer: UITapGestureRecognizer) {
        if gestureRecognizer.state == .ended {
            router.changeToPickerScreen()
        }
    }
}
