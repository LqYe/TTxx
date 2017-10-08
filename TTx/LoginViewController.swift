//
//  LoginViewController.swift
//  TTx
//
//  Created by Liqiang Ye on 9/26/17.
//  Copyright © 2017 Liqiang Ye. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {

    @IBOutlet weak var LoginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onLoginButtonClicked(_ sender: Any) {
        
        //invoke twitter client to login
        TwitterClient.sharedInstance!.login(success: {
            print("Login Success")
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
            
        }, failure: { (error: Error!) in
            print("Error: \(error.localizedDescription)")
        })
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "loginSegue" {
            
            guard let dvc = segue.destination as? HamburgerViewController else { return }
            
            let stortboard = UIStoryboard(name: "Main", bundle: nil)

            let menuVC = stortboard.instantiateViewController(withIdentifier: "menuViewController") as! MenuViewController
            
            menuVC.hamburgerViewController = dvc
            
            dvc.menuViewController = menuVC
            
        }
        
    }
    
}
