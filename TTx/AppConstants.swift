//
//  AppConstants.swift
//  TTx
//
//  Created by Liqiang Ye on 9/27/17.
//  Copyright © 2017 Liqiang Ye. All rights reserved.
//

import Foundation

struct AppConstants {
    
    
    struct APIConstants {
        static let baseUrl = "https://api.twitter.com"
        static let consumerKey = "Ao4zQPF7R3KxR350jTzUhRMx2"
        static let consumerSecret = "c7MnpnKuRwcpCsooQU1nnuBDqcO1G841t0pT2hhGadkm0dXcmz"
        static let requestTokenPath = "oauth/request_token"
        static let authorizePath = "oauth/authorize"
        static let accessBaseUrl = URL(string: baseUrl)!
        static let accessTokenPath = "oauth/access_token"
    }
    
    
}
