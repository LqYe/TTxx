//
//  User.swift
//  TTx
//
//  Created by Liqiang Ye on 9/28/17.
//  Copyright © 2017 Liqiang Ye. All rights reserved.
//

import Foundation

struct User: Decodable, Encodable {
    
    let id: Int64?
    let name: String?
    let screen_name: String?
    let location: String?
    let profile_image_url_https: String?
    let description: String?
    
    let followers_count: Int?
    let friends_count: Int?
    let profile_banner_url: String?
    let profile_background_image_url_https: String?
    
    
    
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
    
    
//    func encode(with aCoder: NSCoder) {
//        aCoder.encode(self.id, forKey: "id")
//        aCoder.encode(self.name, forKey: "name")
//        aCoder.encode(self.screen_name, forKey: "name")
//        aCoder.encode(self.location, forKey: "location")
//        aCoder.encode(self.profile_image_url_https, forKey: "profile_image_url_https")
//        
//        aCoder.encode(self.description, forKey: "description")
//        aCoder.encode(self.followers_count, forKey: "followers_count")
//        aCoder.encode(self.friends_count, forKey: "friends_count")
//        aCoder.encode(self.profile_banner_url, forKey: "profile_banner_url")
//        aCoder.encode(self.profile_background_image_url_https, forKey: "profile_background_image_url_https")
//        
//    }
//    
//    required convenience init(coder decoder: NSCoder) {
//        

//        
//    }
}
