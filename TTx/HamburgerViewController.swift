//
//  HamburgerViewController.swift
//  TTx
//
//  Created by Liqiang Ye on 10/4/17.
//  Copyright © 2017 Liqiang Ye. All rights reserved.
//

import UIKit

class HamburgerViewController: UIViewController {

    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var contentViewLeadingMargin: NSLayoutConstraint!
    var originalContentViewLeadingMargin: CGFloat!
    
    
    //If you want multiple view and view controllers to be on the same scene/view, just grab their view controllers and put their underlying views into the current view hierarchy
    
    //add menu view to hamburger view
    var menuViewController: UIViewController! {
        didSet (oldContentViewController) {
            view.layoutIfNeeded()
            
            //remove existing view from content view hierarchy
            if oldContentViewController != nil {
                oldContentViewController.willMove(toParentViewController: nil)
                oldContentViewController.view.removeFromSuperview()
                oldContentViewController.didMove(toParentViewController: nil)
            }
            
            menuViewController.willMove(toParentViewController: self)
            menuView.addSubview(menuViewController.view)
            menuViewController.didMove(toParentViewController: self)
        }
    }
    
    var contentViewController: UIViewController! {
        didSet (oldContentViewController) {
            view.layoutIfNeeded()
         
            //remove existing view from content view hierarchy
            if oldContentViewController != nil {
                oldContentViewController.willMove(toParentViewController: nil)
                oldContentViewController.view.removeFromSuperview()
                oldContentViewController.didMove(toParentViewController: nil)
            }
            
            contentViewController.willMove(toParentViewController: self)
            contentView.addSubview(contentViewController.view)
            contentViewController.didMove(toParentViewController: self)
            
            UIView.animate(withDuration: 0.3, animations: {
                self.contentViewLeadingMargin.constant = 0
                self.view.layoutIfNeeded()
            })
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onPanGesture(_ sender: UIPanGestureRecognizer) {
        
        //when a pan genture occurs, bump the content vew to the right so that underying menu view's left portion will be shown
        let transalation = sender.translation(in: view)
        
        let velocity = sender.velocity(in: view)
        
        switch sender.state {
        case .began:
        originalContentViewLeadingMargin = contentViewLeadingMargin.constant
        case.changed:
            contentViewLeadingMargin.constant = originalContentViewLeadingMargin + transalation.x
        case.ended:
            
            UIView.animate(withDuration: 0.3, animations: {
               
                //when the pan gesture is ended, if the pan gesture goes right, set the content view left margin to > 0 so that underying menu view (pin to window)'s left portion can show up. If it goes left, then reset content view's leading margin to 0 to fully overlap with underlying menu view so that it's not shown.
                self.contentViewLeadingMargin.constant = velocity.x > 0 ? self.view.frame.size.width * 0.4 : 0
                
                    self.view.layoutIfNeeded()
            })
            
        default:
            break
        }
        
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
