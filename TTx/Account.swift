//
//  Account.swift
//  TTx
//
//  Created by Liqiang Ye on 10/8/17.
//  Copyright © 2017 Liqiang Ye. All rights reserved.
//

import Foundation
import BDBOAuth1Manager

struct Account {

    var user: User?
    var accessToken: BDBOAuth1Credential?
    var selected: Bool = false
    
    init(user: User?, accessToken: BDBOAuth1Credential?) {
        self.user = user
        self.accessToken = accessToken
    }
    
    
}
