//
//  HomeTimelineViewController.swift
//  TTx
//
//  Created by Liqiang Ye on 9/29/17.
//  Copyright © 2017 Liqiang Ye. All rights reserved.
//

import UIKit

class HomeTimelineViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tweetsTableView: UITableView!
    var tweets: [Tweet] = [Tweet]()
    
    //views
    var spinner: UIActivityIndicatorView!
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tweetsTableView.estimatedRowHeight = 200
        tweetsTableView.rowHeight = UITableViewAutomaticDimension
        
        fetchData()
        
        //add pull to refresh
        //1. initialize a UI refresh control
        let refreshControl = UIRefreshControl()
        
        //2. implment an action to update the list - see refreshControlAction
        
        //3. bind the action to the refresh control
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        
        //4. insert the refresh control into the list
        tweetsTableView.insertSubview(refreshControl, at: 0)
        
        
        //add inifite scroll indicator
        spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        spinner.frame = CGRect(x:0, y: 0, width: self.tweetsTableView.frame.width, height: 40)
        self.tweetsTableView.tableFooterView = spinner
    }
    
    func fetchData() {
        let params = ["count": "\(Tweet.count)"]
        TwitterClient.sharedInstance!.getHomeTimeline(parameters: params, success: { (homeTimeline: [Tweet]!) in
            
            print("***************Start Printing Hometimeline************")
            print(homeTimeline)
            
            self.tweets = homeTimeline
            self.updateTweetIds()
            self.tweetsTableView.reloadData()
            
        }, failure: { (error: Error!) -> Void in
            print("Error: \(error.localizedDescription)")
        })
    }
    
    fileprivate func updateTweetIds() {
        if self.tweets.count > 0 {
            Tweet.since_id = self.tweets[0].id!
            Tweet.max_id = self.tweets[self.tweets.count - 1].id! - 1
        }
    }
    
    @objc func refreshControlAction(_ refreshControl: UIRefreshControl){
        
        let params = ["count": "\(Tweet.count)"]
        TwitterClient.sharedInstance!.getHomeTimeline(parameters: params, success: { (homeTimeline: [Tweet]!) in
            
            print("***************Pull to refresh Hometimeline************")
            self.tweets = homeTimeline
            refreshControl.endRefreshing()
            self.updateTweetIds()
            self.tweetsTableView.reloadData()

        }, failure: { (error: Error!) -> Void in
            print("Error: \(error.localizedDescription)")
            refreshControl.endRefreshing()
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onLogoutButtonClicked(_ sender: Any) {
        
        TwitterClient.sharedInstance!.logout()
    
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tweets.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     
        return 1
        
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tweetsTableView.dequeueReusableCell(withIdentifier: "TweetCell") as? TweetCell else {
            return UITableViewCell()
        }
        
        cell.tweet = tweets[indexPath.section]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell  = tweetsTableView.cellForRow(at: indexPath) as! TweetCell
        cell.selectionStyle = .none
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        //when it reaches bottom of tableview
        if(indexPath.section == self.tweets.count - 1 && tweetsTableView.isDragging) {

            spinner.startAnimating()
            
            let params = ["count": "\(Tweet.count)", "max_id": "\(Tweet.max_id)"]
            TwitterClient.sharedInstance!.getHomeTimeline(parameters: params, success: { (homeTimeline: [Tweet]!) in
                
                print("***************Infinite Scroll to refresh Hometimeline************")
                let lastIndex = self.tweets.count
                
                self.tweets.append(contentsOf: homeTimeline)
                
                self.spinner.stopAnimating()
                
                Tweet.max_id = self.tweets[self.tweets.count - 1].id! - 1
                
                self.doUpdateNewTweet(indexSet: IndexSet((lastIndex)...(self.tweets.count - 1)))
                
            }, failure: { (error: Error!) -> Void in
                print("Error: \(error.localizedDescription)")
                self.spinner.stopAnimating()
            })
        }
        
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "showTweetDetails" {
        
            let dvc = segue.destination as! TweetDetailsViewController
            let indexPath = tweetsTableView.indexPath(for: sender as! UITableViewCell)!
            let tweetCell = tweetsTableView.cellForRow(at: indexPath) as! TweetCell
            
            if let retweeted_status = tweetCell.tweet.retweeted_status {
                dvc.tweet = retweeted_status
                dvc.retweeted_by = tweetCell.tweet.user?.name
            } else {
                dvc.tweet = tweetCell.tweet
            }
            
            dvc.updateTweetHandler = { () in
                self.tweetsTableView.reloadData()
            }
            
        } else if segue.identifier == "showComposeTweet" {
            
            //the new tweet compose view is embeded in a navigation controller, so need to navigate throug to get it
            guard let composeNav = segue.destination as? UINavigationController,
                let composeVC = composeNav.viewControllers.first as? TweetComposeViewController else {
                    return
            }
            
            composeVC.prepare(tweets: tweets, newTweetHandler: { (updatedTweets) in
                
                self.tweets = updatedTweets
                self.doUpdateNewTweet(indexSet: [0])
            })
            
        }
        
    }
 
    func doUpdateNewTweet(indexSet: IndexSet) {
        
        tweetsTableView.beginUpdates()
        tweetsTableView.insertSections(indexSet, with: .automatic)
        tweetsTableView.endUpdates()
    
    }
    
}
