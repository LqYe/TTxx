//
//  TweetViewController.swift
//  TTx
//
//  Created by Liqiang Ye on 9/30/17.
//  Copyright © 2017 Liqiang Ye. All rights reserved.
//

import UIKit
import UIView_Borders

class TweetDetailsViewController: UIViewController {

    @IBOutlet weak var retweetedLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var replyButton: UIButton!
    
    @IBOutlet weak var tweetDetailsView: UIView!
    @IBOutlet weak var statsView: UIView!
    @IBOutlet weak var actionItemView: UIView!
    
    var tweet: Tweet!
    var retweeted_by: String?
    var updateTweetHandler: () -> Void = { () in }
    
    @IBOutlet var doubleTapToLike: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let profileUrl = URL(string: (tweet.user?.profile_image_url_https)!)!
        let formattedCreatedDate = Utils.convertTweetDateToTimeAgo(tweetDate: tweet.created_at ?? "Unknown")
        
        profileImageView.setImageWith(profileUrl)
        nameLabel.text = tweet.user?.name
        screenNameLabel.text = "@" + (tweet.user?.screen_name ?? "")
        timestampLabel.text = formattedCreatedDate
        tweetTextLabel.text = tweet.text
        
        retweetCountLabel.text = "\(tweet.retweet_count ?? 0)"
        likeCountLabel.text = "\(tweet.favorite_count ?? 0)"
        
        if tweet.favorited != nil && tweet.favorited! {
            likeButton.setImage(UIImage(named: "liked"), for: UIControlState.normal)
        }

        if tweet.retweeted != nil && tweet.retweeted! {
            retweetButton.setImage(UIImage(named: "retweeted"), for: UIControlState.normal)
        }
        
        let tweetDetailGroupViewYconstraint = NSLayoutConstraint(item: tweetDetailsView, attribute: .top, relatedBy: .equal, toItem: retweetedLabel.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 0)

        if retweeted_by != nil {
            retweetedLabel.isHidden = false
            retweetedLabel.text = "retweeted by \(retweeted_by!)"
            NSLayoutConstraint.deactivate([tweetDetailGroupViewYconstraint])
            
        } else {
            retweetedLabel.isHidden = true
            NSLayoutConstraint.activate([tweetDetailGroupViewYconstraint])
        }
        
        statsView.addTopBorder(withHeight: 2.0, andColor: UIColor.lightGray)
        statsView.addBottomBorder(withHeight: 2.0, andColor: UIColor.lightGray)

        
        //set up double tap to like
        doubleTapToLike.numberOfTapsRequired = 2;
        doubleTapToLike.addTarget(self, action: #selector(doubleTapped))
    }
    
    @objc func doubleTapped() {
        handleLikeAction()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func didMove(toParentViewController parent: UIViewController?) {
        
    }
    
    fileprivate func handleLikeAction() {
        let id = tweet.id ?? 0
        
        if tweet.favorited == nil || !tweet.favorited! {
            TwitterClient.sharedInstance!.postLike(id: id, action: "create", success: {
                print("Successfully Liked a Tweet \(id)")
                self.tweet.favorited = true
                self.likeButton.setImage(UIImage(named: "liked"), for: UIControlState.normal)
                self.tweet.favorite_count = (self.tweet.favorite_count ?? 0) + 1
                self.likeCountLabel.text = "\(self.tweet.favorite_count!)"
            }, failure: { (error: Error!) in
                print("Error: \(error.localizedDescription)")
            })
            
                self.updateTweetHandler()
            
        } else {
            TwitterClient.sharedInstance!.postLike(id: id, action: "destroy", success: {
                print("Successfully Unliked a Tweet \(id)")
                self.tweet.favorited = false
                self.likeButton.setImage(UIImage(named: "like"), for: UIControlState.normal)
                self.tweet.favorite_count = (self.tweet.favorite_count ?? 1) - 1
                self.likeCountLabel.text = "\(self.tweet.favorite_count!)"
                
                self.updateTweetHandler()
                
            }, failure: { (error: Error!) in
                print("Error: \(error.localizedDescription)")
            })
        }
        
    }
    
    @IBAction func onLikeButtonClicked(_ sender: Any) {
        handleLikeAction()
    }
    
    
    @IBAction func onRetweetButtonClicked(_ sender: Any) {
        
        let id = tweet.id ?? 0
        
        if tweet.retweeted  == nil || !tweet.retweeted! {
            TwitterClient.sharedInstance!.postRetweet(id: id, action: "retweet", success: {
                print("Successfully Retweeted a Tweet \(id)")
                self.tweet.retweeted = true
                self.retweetButton.setImage(UIImage(named: "retweeted"), for: UIControlState.normal)
                self.tweet.retweet_count = (self.tweet.retweet_count ?? 0) + 1
                self.retweetCountLabel.text = "\(self.tweet.retweet_count!)"
                
                self.updateTweetHandler()
                
            }, failure: { (error: Error!) in
                print("Error: \(error.localizedDescription)")
            })
        } else {
            TwitterClient.sharedInstance!.postRetweet(id: id, action: "unretweet", success: {
                print("Successfully Unretweeted a Tweet \(id)")
                self.tweet.retweeted = false
                self.retweetButton.setImage(UIImage(named: "retweet"), for: UIControlState.normal)
                self.tweet.retweet_count = (self.tweet.retweet_count ?? 1) - 1
                self.retweetCountLabel.text = "\(self.tweet.retweet_count!)"
                
                self.updateTweetHandler()
                
            }, failure: { (error: Error!) in
                print("Error: \(error.localizedDescription)")
            })
        }
        
    }
    
    @IBAction func onReplyButtonClicked(_ sender: Any) {
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "showReply" {
            
            //the reply view is embeded in a navigation controller, so need to navigate throug to get it
            guard let replyNav = segue.destination as? UINavigationController,
                let replyVC = replyNav.viewControllers.first as? ReplyViewController else {
                    return
            }
            
            replyVC.tweet = self.tweet
            
        }
        
    }
 

}
