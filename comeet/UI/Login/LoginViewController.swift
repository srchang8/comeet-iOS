//
//  LoginViewController.swift
//  comeet
//
//  Created by Ricardo Contreras on 3/6/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    internal let viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
   
    @IBAction func logIn(_ sender: Any) {
        viewModel.getToken()
        
    }
    
    
    
}

private extension LoginViewController {
    func setup() {
        //invoked when we get a token by the view model
        viewModel.tokenBinding = { [weak self] (token: String) in
            self?.goToMenu()
        }
        
        viewModel.tokenErrorBinding = { [weak self] (error: Error) in
        }
    }
    
    func goToMenu(){
        performSegue(withIdentifier: "MainMenuSegue", sender: self)
    }
}
