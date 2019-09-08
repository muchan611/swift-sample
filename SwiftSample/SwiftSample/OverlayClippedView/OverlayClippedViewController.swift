import Foundation
import UIKit

class OverlayClippedViewController: UIViewController {
    private lazy var backgroundLayer: CALayer = {
        let clippedViewWidth: CGFloat = 220
        let clippedViewHeight: CGFloat = 220
        let backgroundLayer = CALayer()
        backgroundLayer.bounds = view.bounds
        backgroundLayer.position = view.center
        backgroundLayer.backgroundColor = UIColor.black.cgColor
        backgroundLayer.opacity = 0.5

        let maskLayer = CAShapeLayer()
        maskLayer.bounds = backgroundLayer.bounds
        let clippingViewRect =  CGRect(x: (view.bounds.width - clippedViewWidth) / 2, y: 190, width: clippedViewWidth, height: clippedViewHeight)
        let path =  UIBezierPath(roundedRect: clippingViewRect, cornerRadius: 5.0)
        path.append(UIBezierPath(rect: maskLayer.bounds))

        maskLayer.fillColor = UIColor.black.cgColor
        maskLayer.path = path.cgPath
        maskLayer.position = view.center
        maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
        backgroundLayer.mask = maskLayer
        return backgroundLayer
    }()
    
    override func viewDidLoad() {
        view.layer.addSublayer(backgroundLayer)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func didTapView(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
}
