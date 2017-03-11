//
//  LoginViewController.swift
//  comeet
//
//  Created by Ricardo Contreras on 3/6/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var tokenLabel: UILabel!
    internal let viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    @IBAction func getToken(_ sender: Any) {
        viewModel.getToken()
    }
    
    @IBAction func logIn(_ sender: Any) {
        
        viewModel.getToken()
        performSegue(withIdentifier: "MainMenuSegue", sender: self)
        
        
    }
    
    
    
}

private extension LoginViewController {
    func setup() {
        viewModel.tokenBinding = { [weak self] (token: String) in
            self?.tokenLabel.text = "Token: " + token
        }
        viewModel.tokenErrorBinding = { [weak self] (error: Error) in
            self?.tokenLabel.text = "Error: " + error.localizedDescription
        }
    }
}
