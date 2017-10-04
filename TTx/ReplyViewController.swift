//
//  ReplyViewController.swift
//  TTx
//
//  Created by Liqiang Ye on 10/1/17.
//  Copyright © 2017 Liqiang Ye. All rights reserved.
//

import UIKit

class ReplyViewController: UIViewController {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var replyTextView: UITextView!
    
    var tweet: Tweet!
    
    var usernameReplyingTo: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        usernameReplyingTo = "@\(tweet.user?.screen_name ?? "Unknown")"
        userNameLabel.text = usernameReplyingTo
        navigationItem.title = "\(140 - usernameReplyingTo.count - 1)"
        
        //hide the reply button as no user input yet
        navigationItem.leftBarButtonItem?.isEnabled = false

        replyTextView.becomeFirstResponder()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onReplyButtonClicked(_ sender: Any) {
        
        let text = usernameReplyingTo + " " + replyTextView.text
        
        TwitterClient.sharedInstance!.postTweet(text: text, replytoId: tweet.id, success: { (newTweet: Tweet!) in
            
            print("Successfully Replied a Tweet")
            
        }, failure: { (error: Error!) in
            print("Error: \(error.localizedDescription)")
        })
        
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


extension ReplyViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        //range is the index being edited. Editng: You can add a char or paste a sentence/paragraph.
        //suppose current textview has "what", if "?" is added to front, then this method will be triggered with range 0 and text "?". If "?" is added at the end, the range is 4.
        //text is the text being entered: can be more than one char i.e. pasted sentence or paragraph.
        let maxChars: Int = 140 - usernameReplyingTo.count
        
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
