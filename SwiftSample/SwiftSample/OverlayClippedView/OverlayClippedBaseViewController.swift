import Foundation
import UIKit

class OverlayClippedBaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let squareView = UIView(frame: .zero)
        view.addSubview(squareView)
        squareView.clipsToBounds = true
        squareView.layer.cornerRadius = 5.0
        squareView.backgroundColor = .green
        squareView.translatesAutoresizingMaskIntoConstraints = false
        squareView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        squareView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        squareView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        squareView.topAnchor.constraint(equalTo: view.topAnchor, constant: 200).isActive = true
        
        let button = UIButton(frame: .zero)
        view.addSubview(button)
        button.setTitle("モーダルを表示", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 200).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.topAnchor.constraint(equalTo: squareView.bottomAnchor, constant: 100).isActive = true
        button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
    }
    
    @objc func didTapButton(_ sender: UIButton) {
        let modalViewController = OverlayClippedViewController()
        modalViewController.modalPresentationStyle = .overCurrentContext
        modalViewController.modalTransitionStyle = .crossDissolve
        present(modalViewController, animated: true, completion: nil)
    }
}
