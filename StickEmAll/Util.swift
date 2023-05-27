import PureLayout

extension UIView {
    func addCornerRadiusToTopCorners(radius: CGFloat) {
        let maskPath = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: [.topLeft, .topRight],
            cornerRadii: CGSize(width: radius, height: radius)
        )
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        layer.mask = maskLayer
    }
    
    func addBottomBorder(color: UIColor, thickness: CGFloat) {
            let borderLayer = CALayer()
            borderLayer.backgroundColor = color.cgColor
            borderLayer.frame = CGRect(x: 0, y: frame.size.height - thickness, width: frame.size.width, height: thickness)
            layer.addSublayer(borderLayer)
    }
}

extension UIColor {
    static let lightYellow = UIColor(red: 1, green: 0.93, blue: 0.649, alpha: 1)
    
    static let darkYellow = UIColor(red: 1, green: 0.871, blue: 0.349, alpha: 1)
    
    static let blurple = UIColor(red: 0.322, green: 0.443, blue: 1, alpha: 1)
    
    static let lightBlurple = UIColor(red: 0.433, green: 0.535, blue: 1, alpha: 1) //UIColor(red: 0.525, green: 0.61, blue: 1, alpha: 1)
}
