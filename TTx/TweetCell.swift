//
//  TweetCell.swift
//  TTx
//
//  Created by Liqiang Ye on 9/29/17.
//  Copyright © 2017 Liqiang Ye. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet weak var retweetedLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    @IBOutlet weak var likeCountLabel: UILabel!
    
    @IBOutlet weak var tweetDetailsView: UIView!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var retweetButton: UIButton!
    var tweetDetailGroupViewYconstraint: NSLayoutConstraint!
    
    
    var tweet: Tweet! {
        didSet {
            
            var theTweet: Tweet! = tweet
            if let retweeted_status = tweet.retweeted_status {
                theTweet = retweeted_status
                retweetedLabel.isHidden = false
                retweetedLabel.text = "retweeted by \(tweet.user?.name ?? "Unknown")"
                
            NSLayoutConstraint.deactivate([tweetDetailGroupViewYconstraint])

            } else {
                retweetedLabel.isHidden = true
            NSLayoutConstraint.activate([tweetDetailGroupViewYconstraint])
            }
            
            let profileUrl = URL(string: (theTweet.user?.profile_image_url_https)!)!
            let formattedCreatedDate = Utils.convertTweetDateToTimeAgo(tweetDate: theTweet.created_at ?? "Unknown")
            
            profileImageView.setImageWith(profileUrl)
            nameLabel.text = theTweet.user?.name
            screenNameLabel.text = "@" + (theTweet.user?.screen_name ?? "")
            timestampLabel.text = formattedCreatedDate
            tweetTextLabel.text = theTweet.text
            likeCountLabel.text = "\(theTweet.favorite_count ?? 0)"
            retweetCountLabel.text = "\(theTweet.retweet_count ?? 0)"
            
            if theTweet.favorited != nil && theTweet.favorited! {
                likeButton.setImage(UIImage(named: "liked"), for: UIControlState.normal)
            } else {
                likeButton.setImage(UIImage(named: "like"), for: UIControlState.normal)
            }
            
            if theTweet.retweeted != nil && theTweet.retweeted! {
                retweetButton.setImage(UIImage(named: "retweeted"), for: UIControlState.normal)
            } else {
                retweetButton.setImage(UIImage(named: "retweet"), for: UIControlState.normal)
            }
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
        
        tweetDetailGroupViewYconstraint = NSLayoutConstraint(item: tweetDetailsView, attribute: .top, relatedBy: .equal, toItem: tweetDetailsView.superview, attribute: .top, multiplier: 1, constant: 8)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

