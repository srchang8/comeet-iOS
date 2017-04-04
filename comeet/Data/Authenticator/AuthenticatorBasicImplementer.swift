//
//  AuthenticatorBasicImplementer.swift
//  comeet
//
//  Created by Ricardo Contreras on 4/2/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import Foundation
import UIKit

class AuthenticatorBasicImplementer : AuthenticatorProtocol {
    
    struct Constants {
        static let authType = AuthType.basic
    }
    
    // TODO: Use keychain
    internal var userEmail: String?
    internal var password: String?
    internal var loginViewController: AuthenticatorBasicViewController?
    internal var completion: TokenCompletion?
    internal var token: String? {
        get {
            guard let userEmail = userEmail, let password = password else {
                return nil
            }
            let credentialData = "\(userEmail):\(password)".data(using: String.Encoding.utf8)!
            let base64Credentials = credentialData.base64EncodedString()
            return base64Credentials
        }
    }
    
    func getToken(completion:@escaping TokenCompletion) {
        
        loginViewController = AuthenticatorBasicViewController()
        
        guard let controller = AuthenticatorBasicImplementer.topViewController(),
            let loginViewController = loginViewController else {
            completion(nil, nil, Constants.authType)
            return
        }
        
        self.completion = completion
        loginViewController.delegate = self
        controller.present(loginViewController, animated: true, completion: nil)
    }
    
    func isLoggedIn() -> Bool {
        return userEmail != nil && password != nil
    }
    
    func logout() {
        userEmail = nil
        password = nil
    }
    
    func getOrganization() -> String {
        let dafault = AuthenticatorUtils.Constants.defaultOrganization
        guard let userEmail = userEmail else {
            return dafault
        }
        
        return AuthenticatorUtils.getUserOrganization(email: userEmail) ?? dafault
    }
}

extension AuthenticatorBasicImplementer : AuthenticatorBasicViewControllerDelegate {
    
    func authenticate(userEmail: String?, password: String?) {
        self.userEmail = userEmail
        self.password = password
        
        loginViewController?.dismiss(animated: true, completion: { [weak self] in
            self?.loginViewController = nil
        })
        
        guard token != nil else {
            return
        }
        
        completion?(token, nil, Constants.authType)
    }
}

private extension AuthenticatorBasicImplementer {
    
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
