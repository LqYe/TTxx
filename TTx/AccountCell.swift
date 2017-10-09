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
    
    
    @IBOutlet weak var accountView: UIView!
    
    
    var removeAccount: (Account) -> Void = { (account) in }
    
    var account: Account!{
        didSet{
            
            if let user = account.user {
                let profileUrl = URL(string: (user.profile_image_url_https)!)!
                profileImageView.setImageWith(profileUrl)
                nameLabel.text = user.name
                screenNameLabel.text = "@" + (user.screen_name ?? "")
                
            }
            
            if account.selected != nil && account.selected! {
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
        
        let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(onSwiped))
        accountView.addGestureRecognizer(swipeGesture)
        accountView.isUserInteractionEnabled = true
        
    }
    
    @objc func onSwiped(sender: UIPanGestureRecognizer) {
        
        switch sender.state {
        case .began:
            print ("long pan starts")
        case .changed:
            if let view = sender.view {
                let translation = sender.translation(in: sender.view)
                view.center = CGPoint(x: view.center.x + translation.x, y: view.center.y)
            }
        case .ended:
            print("long pan ended")
            removeAccount(account)
        default:
            break
        }
        
        sender.setTranslation(CGPoint.zero, in: self.superview)

    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
