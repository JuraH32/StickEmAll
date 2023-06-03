import PureLayout
import CoreImage

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
    
    static let lightRed = UIColor(red: 1, green: 0.367, blue: 0.367, alpha: 1)
}

extension String {

    var length: Int {
        return count
    }

    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }

    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }

    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }

    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
}

extension UIImageView {
    func setImageWithoutCache(image: UIImage?) {
            let uniqueIdentifier = UUID().uuidString
            self.image = nil
            DispatchQueue.main.async {
                self.image = image
                self.accessibilityIdentifier = uniqueIdentifier
            }
        }
}


func generateQRCode(from string: String, width: CGFloat, height: CGFloat) -> UIImage? {
    let data = string.data(using: .isoLatin1)
    if let filter = CIFilter(name: "CIQRCodeGenerator") {
        filter.setValue(data, forKey: "inputMessage")
        guard let qrCodeImage = filter.outputImage else { return nil }

        let scaleX = width / qrCodeImage.extent.size.width
        let scaleY = height / qrCodeImage.extent.size.height
        let transformedImage = qrCodeImage.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))
        
        return UIImage(ciImage: transformedImage)
    }
    
    return nil
}
