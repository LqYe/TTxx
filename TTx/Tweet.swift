//
//  Tweet.swift
//  TTx
//
//  Created by Liqiang Ye on 9/29/17.
//  Copyright © 2017 Liqiang Ye. All rights reserved.
//

import Foundation

class Tweet: Decodable {
    
    let id: Int64?
    let text: String?
    let created_at: String?
    var retweet_count: Int?
    var retweeted: Bool?
    var favorite_count: Int?
    var favorited: Bool?
    let retweeted_status: Tweet?
    
    
    //user object
    let user: User?
    
    static var since_id: Int64 = 0;
    static var max_id: Int64 = 0;
    static var count: Int = 30;
    
    
}


//struct RetweetStatus: Decodable {
//    
//    let id: Int64?
//    let text: String?
//    let created_at: String?
//    var retweet_count: Int?
//    var retweeted: Bool?
//    var favorite_count: Int?
//    var favorited: Bool?
//
//
//    //user object
//    let user: User?
//
//}

