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
