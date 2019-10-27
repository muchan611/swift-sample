import UIKit

extension UICollectionView {
    public func register(cellType: UICollectionViewCell.Type, bundle: Bundle? = nil) {
        let className = String(describing: cellType)
        let nib = UINib(nibName: className, bundle: bundle)
        register(nib, forCellWithReuseIdentifier: className)
    }

    public func dequeueReusableCell<T: UICollectionViewCell>(with type: T.Type,
                                                             for indexPath: IndexPath) -> T {
        let className = String(describing: type)
        let cell = dequeueReusableCell(withReuseIdentifier: className, for: indexPath) as? T
        guard let dequeueCell = cell else {
            fatalError("Could not dequeue a cell of class \(className)")
        }
        return dequeueCell
    }
}
