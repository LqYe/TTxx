//
//  MenuViewController.swift
//  TTx
//
//  Created by Liqiang Ye on 10/4/17.
//  Copyright © 2017 Liqiang Ye. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    @IBOutlet weak var menuTableView: UITableView!
    
    private var profileNavController: UINavigationController!
    private var homeTimelineNavController: UINavigationController!
    
    private var mentionNavController: UINavigationController!
    private var accountNavController: UINavigationController!
//
    
    var hamburgerViewController: HamburgerViewController!
    
    var viewControllers: [UIViewController] = []
    
    
    let menus = ["Profile", "Timeline", "Mentions", "Accounts"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        menuTableView.tableFooterView = UIView()

        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        //profile vc
        profileNavController = storyboard.instantiateViewController(withIdentifier: "profileNavController") as! UINavigationController
        let profileVC = profileNavController.viewControllers[0] as! ProfileViewController
        profileVC.user = User.currentUser
        viewControllers.append(profileNavController)
        
        //hometimeline vc
        homeTimelineNavController = storyboard.instantiateViewController(withIdentifier: "tweetsNavViewController") as! UINavigationController
        viewControllers.append(homeTimelineNavController)
        
        
        //mentions vc
        mentionNavController = storyboard.instantiateViewController(withIdentifier: "mentionsNavViewController") as! UINavigationController
        viewControllers.append(mentionNavController)
        
        //accounts vc
        accountNavController = storyboard.instantiateViewController(withIdentifier: "accountsNavViewController") as! UINavigationController
        viewControllers.append(accountNavController)

        
        hamburgerViewController.contentViewController = homeTimelineNavController
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let menuCell = menuTableView.dequeueReusableCell(withIdentifier: "MenuCell") as? MenuCell else {return UITableViewCell()}
        
        
        menuCell.menuLabel.text = menus[indexPath.row]
        
        return menuCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        menuTableView.deselectRow(at: indexPath, animated: true)
        
        hamburgerViewController.contentViewController = viewControllers[indexPath.row]
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.height * 1.0/CGFloat(menus.count)
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
