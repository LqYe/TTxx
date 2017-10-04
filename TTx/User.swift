//
//  User.swift
//  TTx
//
//  Created by Liqiang Ye on 9/28/17.
//  Copyright © 2017 Liqiang Ye. All rights reserved.
//

import Foundation

struct User: Decodable, Encodable {
    
    let name: String?
    let screen_name: String?
    let location: String?
    let profile_image_url_https: String?
    let description: String?

    static let userLogoutNotification = NSNotification.Name(rawValue: "UserDidLogout")

    static var _currentUser: User?
    
    static var currentUser: User? {
        
        get {
            if _currentUser != nil {
                return _currentUser
            }

            let defaults = UserDefaults.standard
            guard let userData = defaults.object(forKey: "currentTwitterUser") as? Data else {return _currentUser}

            do {
                let user = try JSONDecoder().decode(User.self, from: userData)
                _currentUser = user

            } catch let decodeError {
                print("Error: \(decodeError.localizedDescription)")
            }
            
            return _currentUser
        }

        set {
                _currentUser = newValue

                let defaults = UserDefaults.standard
                if (newValue != nil) {
                        do {
                            //Note: user dafaults only store NS generic types. For other types, archive/serialization to NSData/Data is required
                            let userData = try JSONEncoder().encode(newValue!)
                            defaults.set(userData, forKey: "currentTwitterUser")
                        } catch let encodeError {
                            print("Error: \(encodeError.localizedDescription)")
                        }
                } else {
                    defaults.set(nil, forKey: "currentTwitterUser")
                }
            
        }
        
    }
}
