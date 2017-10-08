//
//  ProfileCell.swift
//  TTx
//
//  Created by Liqiang Ye on 10/7/17.
//  Copyright © 2017 Liqiang Ye. All rights reserved.
//

import UIKit

class ProfileCell: UITableViewCell {

    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followerCountLabel: UILabel!
    
    
    var user: User! {
        
        didSet {
            
            if user.profile_banner_url != nil {
             
                let bannerUrl = URL(string: (user.profile_banner_url)!)!
                bannerImageView.setImageWith(bannerUrl)
                
            } else {
                let backgroundUrl = URL(string: (user.profile_background_image_url_https)!)!
                bannerImageView.setImageWith(backgroundUrl)
            }
            let profileUrl = URL(string: (user.profile_image_url_https)!)!
            profileImageView.setImageWith(profileUrl)
            
            
            nameLabel.text = user.name
            screenNameLabel.text = "@" + (user.screen_name ?? "")
            followingCountLabel.text = "\(user.friends_count ?? 0)"
            followerCountLabel.text = "\(user.followers_count ?? 0)"
            
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profileImageView.clipsToBounds = true
        //corner radius should be underlying frame height / 2
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2;
        profileImageView.layer.borderColor = UIColor(white: 0.7, alpha: 0.8).cgColor
        profileImageView.layer.borderWidth = 1;
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
