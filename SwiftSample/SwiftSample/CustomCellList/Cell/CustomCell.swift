import Foundation
import UIKit

class CustomCell: UITableViewCell {
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func update(item: CustomCellItem) {
        dateLabel.text = item.date
        titleLabel.text = item.title
    }
}
