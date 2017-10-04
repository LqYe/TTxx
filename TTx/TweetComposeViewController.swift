//
//  TweetComposeViewController.swift
//  TTx
//
//  Created by Liqiang Ye on 9/30/17.
//  Copyright © 2017 Liqiang Ye. All rights reserved.
//

import UIKit
import UITextView_Placeholder

class TweetComposeViewController: UIViewController {

    @IBOutlet weak var newTweetTextView: UITextView!
    var tweets: [Tweet] = [Tweet]()
    var newTweetHandler: ([Tweet]) -> Void = { (tweet) in }
    
    func prepare(tweets: [Tweet]?, newTweetHandler: @escaping ([Tweet]) -> Void) {
        
        if let tweets = tweets {
            self.tweets = tweets
        }
        
        self.newTweetHandler = newTweetHandler
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //3rd pod to display a place holder in text view
        newTweetTextView.attributedPlaceholder = NSAttributedString(string: "What's happening?", attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        
        //hide the tweet button as no user input yet
        navigationItem.leftBarButtonItem?.isEnabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTweetButtonClicked(_ sender: Any) {
        
        let text = newTweetTextView.text
        
        if !(text ?? "").isEmpty {
            TwitterClient.sharedInstance!.postTweet(text: text, replytoId: nil, success: { (newTweet: Tweet!) in
                print("Successfully Posted a Tweet")
                
                self.tweets.insert(newTweet, at: 0)
                self.newTweetHandler(self.tweets)
                
            }, failure: { (error: Error!) in
                print("Error: \(error.localizedDescription)")
            })
            
        }
        
        dismiss(animated: true, completion: nil)

    }
    
    @IBAction func onCancelNavButtonClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension TweetComposeViewController: UITextViewDelegate {
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        //range is the index being edited. Editng: You can add a char or paste a sentence/paragraph.
        //suppose current textview has "what", if "?" is added to front, then this method will be triggered with range 0 and text "?". If "?" is added at the end, the range is 4.
        //text is the text being entered: can be more than one char i.e. pasted sentence or paragraph.
        let maxChars: Int = 140
        
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.characters.count // for Swift use count(newText)
        
        if numberOfChars <= maxChars {
            navigationItem.title = "\(maxChars - numberOfChars)"
        
            if(numberOfChars == 0) {
                navigationItem.leftBarButtonItem?.isEnabled = false
            } else {
                navigationItem.leftBarButtonItem?.isEnabled = true
            }
        }
        
        
        return numberOfChars <= maxChars;
        
    }
    
    
}
