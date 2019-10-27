import UIKit

class NestedGroupCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var label: UILabel!
    
    func update(text: String) {
        label.text = text
    }
}
