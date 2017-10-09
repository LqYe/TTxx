//
//  Account.swift
//  TTx
//
//  Created by Liqiang Ye on 10/8/17.
//  Copyright © 2017 Liqiang Ye. All rights reserved.
//

import Foundation
import BDBOAuth1Manager

class Account: NSObject, NSCoding {

    var user: User?
    var accessToken: BDBOAuth1Credential?
    var selected: Bool?
    
    init(user: User?, accessToken: BDBOAuth1Credential?, selected: Bool?) {
        self.user = user
        self.accessToken = accessToken
        self.selected = selected
    }

    
    func encode(with aCoder: NSCoder) {
        
        do {
            let userData = try JSONEncoder().encode(self.user)
            aCoder.encode(userData, forKey: "user")
        } catch let encodeError {
            print("Error: \(encodeError.localizedDescription)")
        }
        
        aCoder.encode(self.accessToken, forKey: "accessToken")
        aCoder.encode(self.selected, forKey: "selected")
    }

    required convenience init(coder decoder: NSCoder) {
        
        var user: User?
        if let userData = decoder.decodeObject(forKey: "user") as? Data {
            do {
                user = try JSONDecoder().decode(User.self, from: userData)
            } catch let decodeError {
                print("Error: \(decodeError.localizedDescription)")
            }
        }
        
        let accessToken = decoder.decodeObject(forKey: "accessToken") as? BDBOAuth1Credential
        let selected = decoder.decodeObject(forKey: "selected") as? Bool

        self.init(user: user, accessToken: accessToken, selected: selected)
    }
    
}
