//
//  AuthenticatorBasicViewController.swift
//  comeet
//
//  Created by Ricardo Contreras on 4/2/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import UIKit

protocol AuthenticatorBasicViewControllerDelegate {
    func authenticate(userEmail: String?, password: String?)
}

class AuthenticatorBasicViewController: UIViewController {
    
    @IBOutlet weak var userEmailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    
    var delegate: AuthenticatorBasicViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        userEmailInput.becomeFirstResponder()
    }
    
    @IBAction func logIn(_ sender: Any) {
        guard let email = userEmailInput.text, !email.isEmpty, AuthenticatorUtils.isValidEmail(testStr: email) else {
            userEmailInput.backgroundColor = UIColor.red
            return
        }
        userEmailInput.backgroundColor = UIColor.white
        guard let password = passwordInput.text, !password.isEmpty else {
            passwordInput.backgroundColor = UIColor.red
            return
        }
        passwordInput.backgroundColor = UIColor.white
        view.endEditing(true)
        delegate?.authenticate(userEmail: email, password: password)
    }
    
    @IBAction func back(_ sender: Any) {
        view.endEditing(true)
        delegate?.authenticate(userEmail: nil, password: nil)
    }
}
