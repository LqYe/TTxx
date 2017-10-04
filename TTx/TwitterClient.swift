//
//  TwitterClient.swift
//  TTx
//
//  Created by Liqiang Ye on 9/29/17.
//  Copyright © 2017 Liqiang Ye. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    static let sharedInstance = TwitterClient(baseURL: AppConstants.APIConstants.accessBaseUrl, consumerKey: AppConstants.APIConstants.consumerKey, consumerSecret: AppConstants.APIConstants.consumerSecret)
        
    var onLoginSuccess: (() -> Void)?
    var onLoginFailed: ((Error?) -> Void)?
    
    func login(success: (() -> Void)!, failure: ((Error?) -> Void)!) {
        
        //clear keychains and previous sessions
//        TwitterClient.sharedInstance!.deauthorize()
        
        //request temporary token
        TwitterClient.sharedInstance!.fetchRequestToken(withPath: AppConstants.APIConstants.requestTokenPath, method: "POST", callbackURL: URL(string: "TTxapp://oauth"), scope: nil, success: { (requestToken : BDBOAuth1Credential!) -> Void in

            self.onLoginSuccess = success
            self.onLoginFailed = failure
            
            //after getting temporary token, directs user to authorize page
            //once user authorizes, it should be redirected back to the client app.
            let authorizeUrl  = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token!)")!
            
            //now open the authorize web page
            UIApplication.shared.open(authorizeUrl, options: [:], completionHandler: nil)
            
        }, failure: { (error: Error!) -> Void in
            print("Error: \(error.localizedDescription)")
        })
        
    }
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        
        //When user logs out, redict to login page
        //Notification Pattern: send a message to various classes or parts of the app in case of an event
        NotificationCenter.default.post(name: User.userLogoutNotification, object: nil)
        
    }
    
    func handleOpenUrl(url: URL) {
        
        let requestToken = BDBOAuth1Credential(queryString: url.query!)
        
        //get access token and then get user and its home timeline on success
        fetchAccessToken(withPath: AppConstants.APIConstants.accessTokenPath, method: "POST", requestToken: requestToken, success: { (accessToken : BDBOAuth1Credential!) -> Void in
            
            self.getCurrentUser(success: { (user: User!) in
                self.onLoginSuccess?()

                print("***************Start Printing User************")
                print(user)
                User.currentUser = user
                
            }, failure: { (error: Error!) -> Void in
               self.onLoginFailed?(error)
            })
            

        }, failure: { (error: Error!) -> Void in
            self.onLoginFailed?(error)
        })
        
        
    }
    
    //added success and failure closure arguments so that driver can do custom processing on success and failure
    func getCurrentUser(success: ((User?) -> Void)!, failure: ((Error?) -> Void)!) {
        
        get("/1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
            
            guard let response = response as? NSDictionary else {return}
            
            do  {
                let json = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                print(json)
                let user = try JSONDecoder().decode(User.self, from: json)
                
                success(user)
                
            } catch let jsonError {
                print("Error: \(jsonError.localizedDescription)")
            }
            
        }, failure: { (task: URLSessionDataTask?, error: Error) -> Void in
            failure(error)
        })
    }
    
    func getHomeTimeline(parameters: [String: String]?, success: (([Tweet]?) -> Void)!, failure: ((Error?) -> Void)!) {

        get("/1.1/statuses/home_timeline.json", parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
            
            guard let response = response as? [NSDictionary] else {return}
            
            do  {
                let json = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                print(json)
                let homeTimeline = try JSONDecoder().decode([Tweet].self, from: json)
                
                success(homeTimeline)
                
            } catch let jsonError {
                print("Error: \(jsonError.localizedDescription)")
            }
            
        }, failure: { (task: URLSessionDataTask?, error: Error) -> Void in
            failure(error)
        })
        
    }
    
    func postTweet(text: String!, replytoId: Int64?, success: ((Tweet) -> Void)!, failure: ((Error?) -> Void)!) {
        
        var params = ["status": text]
        
        if replytoId != nil {
            params["in_reply_to_status_id"] = "\(replytoId!)"
        }
        
        post("/1.1/statuses/update.json", parameters: params, progress: nil, success: {  (task: URLSessionDataTask,
            response: Any?) -> Void in
            
            
            guard let response = response as? NSDictionary else {return}
            
            do  {
                let json = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                print(json)
                let newTweet = try JSONDecoder().decode(Tweet.self, from: json)
                
                success(newTweet)
                
            } catch let jsonError {
                print("Error: \(jsonError.localizedDescription)")
            }
            
        }, failure: { (task: URLSessionDataTask?, error: Error) -> Void in
            failure(error)
        })
        
    }
    
    func postLike(id: Int64!, action: String!, success: (() -> Void)!, failure: ((Error?) -> Void)!) {
        
        let favoriteUrl = "/1.1/favorites/" + action + ".json"
        let params = ["id": id]
        post(favoriteUrl, parameters: params, progress: nil, success: {  (task: URLSessionDataTask,
            response: Any?) -> Void in
            
            success()
            
        }, failure: { (task: URLSessionDataTask?, error: Error) -> Void in
            failure(error)
        })
        
        
    }
    
    func postRetweet(id: Int64!, action: String!, success: (() -> Void)!, failure: ((Error?) -> Void)!) {
        
        let retweetUrl = "/1.1/statuses/\(action!)/\(id!).json"
        
        post(retweetUrl, parameters: nil, progress: nil, success: {  (task: URLSessionDataTask,
            response: Any?) -> Void in
            
            success()
            
        }, failure: { (task: URLSessionDataTask?, error: Error) -> Void in
            failure(error)
        })
        
        
    }

}
