//
//  AccountsViewController.swift
//  TTx
//
//  Created by Liqiang Ye on 10/8/17.
//  Copyright © 2017 Liqiang Ye. All rights reserved.
//

import UIKit

class AccountsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var accountsTableView: UITableView!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        accountsTableView.tableFooterView = UIView()

    }
    
    @IBAction func onLogoutAllClicked(_ sender: Any) {
        
        TwitterClient.sharedInstance!.logoutAll()
        
    }
    
    @IBAction func onAddButtonClicked(_ sender: Any) {
        //invoke twitter client to login
        TwitterClient.sharedInstance!.login(success: {
            print("Login Success")
            self.appDelegate.displayHomePage()
            
        }, failure: { (error: Error!) in
            print("Error: \(error.localizedDescription)")
        })
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TwitterClient.sharedInstance!.accounts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let accountCell = accountsTableView.dequeueReusableCell(withIdentifier: "AccountCell") as? AccountCell else {return UITableViewCell()}

        accountCell.account = TwitterClient.sharedInstance!.accounts[indexPath.row]
        accountCell.removeAccount = { (account) in
            
            if account.selected != nil && account.selected! {
               TwitterClient.sharedInstance!.logout()
            } else {
               
                TwitterClient.sharedInstance!.removeAccount(account: account)
                self.accountsTableView.reloadData()
            }
        }
        
        return accountCell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

       let selectedAccount = TwitterClient.sharedInstance!.accounts[indexPath.row]
       TwitterClient.sharedInstance!.currentAccount.selected = false
       TwitterClient.sharedInstance!.currentAccount = selectedAccount
       TwitterClient.sharedInstance!.saveAccounts()
        
       appDelegate.displayHomePage()
      
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
