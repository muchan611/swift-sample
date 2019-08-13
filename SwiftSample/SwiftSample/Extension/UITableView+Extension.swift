import UIKit

extension UITableView {
    public func register(cellType: UITableViewCell.Type, bundle: Bundle? = nil) {
        let className = String(describing: cellType)
        let nib = UINib(nibName: className, bundle: bundle)
        register(nib, forCellReuseIdentifier: className)
    }
    
    public func dequeueReusableCell<T: UITableViewCell>(with type: T.Type,
                                                        for indexPath: IndexPath) -> T {
        let className = String(describing: type)
        let cell = dequeueReusableCell(withIdentifier: className, for: indexPath) as? T
        guard let dequeueCell = cell else {
            fatalError("Could not dequeue a cell of class \(className)")
        }
        return dequeueCell
    }
}
