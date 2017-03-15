//
//  MainMenuViewController.swift
//  comeet
//
//  Created by stephen chang on 3/9/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController {
    
    var viewModel: MainMenuViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //log out user from exchange
    //bring view back to log in segue
    @IBAction func logOut(_ sender: Any) {
        _=navigationController?.popViewController(animated: true)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier,
            let viewModel = viewModel else {
                return
        }
        Router.prepare(identifier: identifier, destination: segue.destination, sourceViewModel: viewModel)
    }
}

private extension MainMenuViewController {
    func setup() {
        
        self.title = "Menu"
        
        //hide back button on navigation controller
        self.navigationItem.setHidesBackButton(true, animated: false)
    }
}
