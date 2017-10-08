//
//  MenuCell.swift
//  TTx
//
//  Created by Liqiang Ye on 10/5/17.
//  Copyright © 2017 Liqiang Ye. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {

    @IBOutlet weak var menuLabel: UILabel!
    
    @IBOutlet weak var menuLabelToSuperViewTrailingConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        menuLabelToSuperViewTrailingConstraint.constant = (menuLabel.superview?.frame.width ?? 300) * 0.6 - 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
