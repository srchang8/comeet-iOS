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
