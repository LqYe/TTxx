//
//  Utils.swift
//  TTx
//
//  Created by Liqiang Ye on 9/30/17.
//  Copyright © 2017 Liqiang Ye. All rights reserved.
//

import Foundation
import NSDateMinimalTimeAgo

class Utils {
    
    
    class func convertTweetDateToTimeAgo(tweetDate:String) -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy"
        
        let inputDate = formatter.date(from: tweetDate) as NSDate?
        
        var outputDate:String?
    
        if let input = inputDate {
            outputDate = input.timeAgo()
        }
        return outputDate;
    }
    
    
}
