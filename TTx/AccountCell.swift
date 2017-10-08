//
//  AccountCell.swift
//  TTx
//
//  Created by Liqiang Ye on 10/8/17.
//  Copyright © 2017 Liqiang Ye. All rights reserved.
//

import UIKit

class AccountCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    
    @IBOutlet weak var checkMarkImgHeight: NSLayoutConstraint!
    
    @IBOutlet weak var checkMarkImgWidth: NSLayoutConstraint!
    
    @IBOutlet weak var checkMarkImg: UIImageView!
    var account: Account!{
        didSet{
            
            if let user = account.user {
                let profileUrl = URL(string: (user.profile_image_url_https)!)!
                profileImageView.setImageWith(profileUrl)
                nameLabel.text = user.name
                screenNameLabel.text = "@" + (user.screen_name ?? "")
                
            }
            
            if account.selected {
                checkMarkImg.isHidden = false
                checkMarkImgWidth.constant = 50
                checkMarkImgHeight.constant = 50
            } else {
                checkMarkImg.isHidden = true
                checkMarkImgWidth.constant = 0
                checkMarkImgHeight.constant = 0
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
