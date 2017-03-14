//
//  MainMenuViewController.swift
//  comeet
//
//  Created by stephen chang on 3/9/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //hide back button on navigation controller
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        //make navigation bar translucent
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //log out user from exchange
    //bring view back to log in segue
    @IBAction func LogOut(_ sender: Any) {
        _=navigationController?.popViewController(animated: true)
        
    }
    
    
    
    
}
