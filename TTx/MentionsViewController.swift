//
//  MentionsViewController.swift
//  TTx
//
//  Created by Liqiang Ye on 10/8/17.
//  Copyright © 2017 Liqiang Ye. All rights reserved.
//

import UIKit

class MentionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var mentionsTableView: UITableView!{
        didSet {
            self.mentionsTableView.register(UINib(nibName: "TweetCellNib", bundle: Bundle.main), forCellReuseIdentifier: "TweetCell")
            self.mentionsTableView.estimatedRowHeight = 100
            self.mentionsTableView.rowHeight = UITableViewAutomaticDimension
        }
    }
    
    var tweets: [Tweet] = [Tweet]()
    
    //views
    var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mentionsTableView.estimatedRowHeight = 200
        mentionsTableView.rowHeight = UITableViewAutomaticDimension
        
        fetchData()
        
        //add pull to refresh
        //1. initialize a UI refresh control
        let refreshControl = UIRefreshControl()
        
        //2. implment an action to update the list - see refreshControlAction
        
        //3. bind the action to the refresh control
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        
        //4. insert the refresh control into the list
        mentionsTableView.insertSubview(refreshControl, at: 0)
        
        
        //add inifite scroll indicator
        spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        spinner.frame = CGRect(x:0, y: 0, width: self.mentionsTableView.frame.width, height: 40)
        self.mentionsTableView.tableFooterView = spinner
    }
    
    func fetchData() {
        let params = ["count": "\(Tweet.count)"]
        TwitterClient.sharedInstance!.getMentionsTimeline(parameters: params, success: { (mentionsTimeline: [Tweet]!) in
            
            print("***************Start Printing Hometimeline************")
            print(mentionsTimeline)
            
            self.tweets = mentionsTimeline
            self.updateTweetIds()
            self.mentionsTableView.reloadData()
            
        }, failure: { (error: Error!) -> Void in
            print("Error: \(error.localizedDescription)")
        })
    }
    
    fileprivate func updateTweetIds() {
        if self.tweets.count > 0 {
            Tweet.mentions_max_id = self.tweets[self.tweets.count - 1].id! - 1
        }
    }
    
    @objc func refreshControlAction(_ refreshControl: UIRefreshControl){
        
        let params = ["count": "\(Tweet.count)"]
        TwitterClient.sharedInstance!.getMentionsTimeline(parameters: params, success: { (mentionsTimeline: [Tweet]!) in
            
            print("***************Pull to refresh Hometimeline************")
            self.tweets = mentionsTimeline
            refreshControl.endRefreshing()
            self.updateTweetIds()
            self.mentionsTableView.reloadData()
            
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
        
        guard let cell = mentionsTableView.dequeueReusableCell(withIdentifier: "TweetCell") as? TweetCell else {
            return UITableViewCell()
        }
        
        cell.tweet = tweets[indexPath.section]
        cell.pushToProfileView = { (user: User) in
            
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            //profile vc
            let profileVC = storyboard.instantiateViewController(withIdentifier: "profileViewController") as! ProfileViewController
            profileVC.user = user
            self.navigationController?.pushViewController(profileVC, animated: true)
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell  = mentionsTableView.cellForRow(at: indexPath) as! TweetCell
        cell.selectionStyle = .none
        self.performSegue(withIdentifier: "showTweetDetails", sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        //when it reaches bottom of tableview
        if(indexPath.section == self.tweets.count - 1 && mentionsTableView.isDragging) {
            
            spinner.startAnimating()
            
            let params = ["count": "\(Tweet.count)", "max_id": "\(Tweet.mentions_max_id)"]
            TwitterClient.sharedInstance!.getHomeTimeline(parameters: params, success: { (homeTimeline: [Tweet]!) in
                
                print("***************Infinite Scroll to refresh Hometimeline************")
                let nextIndex = self.tweets.count
                
                self.tweets.append(contentsOf: homeTimeline)
                
                self.spinner.stopAnimating()
                
                Tweet.mentions_max_id = self.tweets[self.tweets.count - 1].id! - 1
                
                if (nextIndex <= self.tweets.count - 1) {
                    self.doUpdateNewTweet(indexSet: IndexSet((nextIndex)...(self.tweets.count - 1)))
                }
                
            }, failure: { (error: Error!) -> Void in
                print("Error: \(error.localizedDescription)")
                self.spinner.stopAnimating()
            })
        }
        
    }
    
    func doUpdateNewTweet(indexSet: IndexSet) {
        
        mentionsTableView.beginUpdates()
        mentionsTableView.insertSections(indexSet, with: .automatic)
        mentionsTableView.endUpdates()
        
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
            
            let tweetCell = mentionsTableView.cellForRow(at: indexPath) as! TweetCell
            
            if let retweeted_status = tweetCell.tweet.retweeted_status {
                dvc.tweet = retweeted_status
                dvc.retweeted_by = tweetCell.tweet.user?.name
            } else {
                dvc.tweet = tweetCell.tweet
            }
            
            dvc.updateTweetHandler = { () in
                self.mentionsTableView.reloadData()
            }
        }
    }

}
