//
//  TabCollectionCell.swift
//  SwiftSample
//
//  Created by Mutsumi Kakuta on 2020/06/26.
//  Copyright © 2020 Mutsumi Kakuta. All rights reserved.
//

import Foundation
import UIKit

class TabCollectionCell: UICollectionViewCell {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var grayBorderView: UIView!
    @IBOutlet private weak var activeBorderView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(title: String, isActive: Bool) {
        titleLabel.text = title
        activeBorderView.isHidden = !isActive
    }
}
