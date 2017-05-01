//
//  LoginViewController.swift
//  comeet
//
//  Created by Ricardo Contreras on 3/6/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController {

    internal let viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
   
    @IBAction func logIn(_ sender: Any) {
        viewModel.getToken()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        Router.prepare(identifier: identifier, destination: segue.destination, sourceViewModel: viewModel)
    }
}

private extension LoginViewController {
    func setup() {
        
        self.title = "Login"
        
        //invoked when we get a token by the view model
        viewModel.tokenBinding = { [weak self] (token: String) in
            self?.goToMenu()
        }
        
        viewModel.tokenErrorBinding = { (error: Error) in
        }
        
        viewModel.getToken()
    }
    
    func goToMenu(){
        let userDefault = UserDefaults.standard
        userDefault.set(false, forKey: "isRoomsGuideShown")
        
        performSegue(withIdentifier: Router.Constants.mainMenuSegue, sender: self)
    }
}
