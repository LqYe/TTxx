//
//  ProfileViewController.swift
//  TTx
//
//  Created by Liqiang Ye on 10/7/17.
//  Copyright © 2017 Liqiang Ye. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var profileTableView: UITableView! {
        didSet {
            self.profileTableView.register(UINib(nibName: "TweetCellNib", bundle: Bundle.main), forCellReuseIdentifier: "TweetCell")
            self.profileTableView.estimatedRowHeight = 100
            self.profileTableView.rowHeight = UITableViewAutomaticDimension
        }
    }
    var user: User!
    var tweets: [Tweet] = [Tweet]()
    var user_tweet_max_id: Int64 = 0;

    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    //views
    var spinner: UIActivityIndicatorView!
    
    var initialContentOffSet: CGPoint = CGPoint()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        fetchUser(success: { (user: User!) in
            
            self.user = user
            //note: get calls are asyncrhous calls. So first execute get user and the on success execute get user timeline
            self.fetchData()
            
        }, failure: { (error: Error!) -> Void in
            print("Error: \(error.localizedDescription)")
        })
        
        //set nav title
        if user.name != nil {
            navigationItem.title = user.name
        }
        
        //add pull to refresh
        //1. initialize a UI refresh control
        let refreshControl = UIRefreshControl()

        //2. implment an action to update the list - see refreshControlAction

        //3. bind the action to the refresh control
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)

        //4. insert the refresh control into the list
        profileTableView.insertSubview(refreshControl, at: 0)


        //add inifite scroll indicator
        spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        spinner.frame = CGRect(x:0, y: 0, width: self.profileTableView.frame.width, height: 40)
        self.profileTableView.tableFooterView = spinner
        
        //add long press gesture
        
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(onLongPressed))
        navigationController?.navigationBar.addGestureRecognizer(longPressGestureRecognizer)
        navigationController?.navigationBar.isUserInteractionEnabled = true
        
    }
    
    @objc func onLongPressed(sender: UILongPressGestureRecognizer) {
        
        switch sender.state {
        case .began:
            print ("long press starts")
        case .changed:
            navigationController?.navigationBar.barTintColor = .lightGray
        case .ended:
            let stortboard = UIStoryboard(name: "Main", bundle: nil)
            let accountsVC = stortboard.instantiateViewController(withIdentifier: "accountsNavViewController")
            UIView.animate(withDuration: 0.3, animations: {
                self.appDelegate.window?.rootViewController = accountsVC
            })
        default:
            ()
        }
        
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchUser(success: ((User?) -> Void)!, failure: ((Error?) -> Void)!) {
        
        TwitterClient.sharedInstance!.getUser(userId: user.id, screenName: user.screen_name, success: { (user: User!) in
            
            success(user)
            
        }, failure: { (error: Error!) -> Void in
            failure(error)
        })
        
    }
    
    func fetchData() {

        TwitterClient.sharedInstance!.getUserTimeline(userId: user.id, screenName: user.screen_name, maxId: nil, success: { (userTimeline: [Tweet]!) in
            
            print("***************Start Printing Hometimeline************")
            print(userTimeline)
            
            self.tweets = userTimeline
            self.updateUserTweetIds()
            self.profileTableView.reloadData()
            
        }, failure: { (error: Error!) -> Void in
            print("Error: \(error.localizedDescription)")
        })
    }
    
    fileprivate func updateUserTweetIds() {
        if self.tweets.count > 0 {
            self.user_tweet_max_id = self.tweets[self.tweets.count - 1].id! - 1
        }
    }
    
    @objc func refreshControlAction(_ refreshControl: UIRefreshControl){
        
//        TwitterClient.sharedInstance!.getUserTimeline(userId: user.id, screenName: user.screen_name, maxId: nil, success: { (userTimeline: [Tweet]!) in
//
//            print("***************Pull to refresh Hometimeline************")
//            self.tweets = userTimeline
//            refreshControl.endRefreshing()
//            self.updateUserTweetIds()
//            self.profileTableView.reloadData()
//
//        }, failure: { (error: Error!) -> Void in
//            print("Error: \(error.localizedDescription)")
//            refreshControl.endRefreshing()
//        })
        fetchUser(success: { (user: User!) in
            
            self.user = user
            //note: get calls are asyncrhous calls. So first execute get user and the on success execute get user timeline
            TwitterClient.sharedInstance!.getUserTimeline(userId: user.id, screenName: user.screen_name, maxId: nil, success: { (userTimeline: [Tweet]!) in
                
              
                self.tweets = userTimeline
                refreshControl.endRefreshing()
                self.updateUserTweetIds()
                self.profileTableView.reloadData()
                
            }, failure: { (error: Error!) -> Void in
                print("Error: \(error.localizedDescription)")
            })
            
            
        }, failure: { (error: Error!) -> Void in
            print("Error: \(error.localizedDescription)")
        })
        
    }
    
    @IBAction func onLogoutButtonClicked(_ sender: Any) {
        
        TwitterClient.sharedInstance!.logout()
        
    }
    

    func numberOfSections(in tableView: UITableView) -> Int {
        return tweets.count + 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
        
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            guard let cell = profileTableView.dequeueReusableCell(withIdentifier: "ProfileCell") as? ProfileCell else {
                return UITableViewCell()
            }
            
            cell.user = user
            return cell

        default:
            guard let cell = profileTableView.dequeueReusableCell(withIdentifier: "TweetCell") as? TweetCell else {
                return UITableViewCell()
            }
            
            cell.tweet = tweets[indexPath.section - 1]
            return cell

        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 0:
            ()
        default:
            let cell  =                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             profileTableView.cellForRow(at: indexPath) as! TweetCell
            cell.selectionStyle = .none
            
            self.performSegue(withIdentifier: "showTweetDetails", sender: indexPath)
            
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        //when it reaches bottom of tableview
        if(indexPath.section - 1 == self.tweets.count - 1 && profileTableView.isDragging) {
            
            spinner.startAnimating()
            
            TwitterClient.sharedInstance!.getUserTimeline(userId: user.id, screenName: user.screen_name, maxId: user_tweet_max_id, success: { (userTimeline: [Tweet]!) in

                print("***************Infinite Scroll to refresh Hometimeline************")
                let nextIndex = self.tweets.count + 1
                
                self.tweets.append(contentsOf: userTimeline)
                
                self.spinner.stopAnimating()
                
                self.user_tweet_max_id = self.tweets[self.tweets.count - 1].id! - 1
                
                if (nextIndex <= self.tweets.count) {
                    self.doUpdateNewTweet(indexSet: IndexSet((nextIndex)...(self.tweets.count)))
                }
                
            }, failure: { (error: Error!) -> Void in
                print("Error: \(error.localizedDescription)")
                self.spinner.stopAnimating()
            })
        }
        
    }
    
    func doUpdateNewTweet(indexSet: IndexSet) {
        
        profileTableView.beginUpdates()
        profileTableView.insertSections(indexSet, with: .automatic)
        profileTableView.endUpdates()
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "showTweetDetails" {
            
            let dvc = segue.destination as! TweetDetailsViewController
            guard let indexPath = sender as? IndexPath else { return }
            
            let tweetCell = profileTableView.cellForRow(at: indexPath) as! TweetCell
            
            if let retweeted_status = tweetCell.tweet.retweeted_status {
                dvc.tweet = retweeted_status
                dvc.retweeted_by = tweetCell.tweet.user?.name
            } else {
                dvc.tweet = tweetCell.tweet
            }
            
            dvc.updateTweetHandler = { () in
                self.profileTableView.reloadData()
            }
        } else if segue.identifier == "showComposeTweet" {
            
            //the new tweet compose view is embeded in a navigation controller, so need to navigate throug to get it
            guard let composeNav = segue.destination as? UINavigationController,
                let composeVC = composeNav.viewControllers.first as? TweetComposeViewController else {
                    return
            }
            
            composeVC.prepare(tweets: tweets, newTweetHandler: { (updatedTweets) in
                
                self.tweets = updatedTweets
                self.doUpdateNewTweet(indexSet: [1])
            })
            
        }
    }

    

}

extension ProfileViewController: UIScrollViewDelegate {
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        initialContentOffSet = scrollView.contentOffset
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if initialContentOffSet.y > scrollView.contentOffset.y {
            print("up")
            print(scrollView.contentOffset.y)
            //profileTableView.alpha = min(0.7, abs(scrollView.contentOffset.y) * 0.01)
        } else {
            print("down")
            print(scrollView.contentOffset.y)
            profileTableView.alpha = min(1, abs(scrollView.contentOffset.y) * 0.01)
        }
    }
    
}
