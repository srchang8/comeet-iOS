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
    
    let type = AuthType.basic
    struct Constants {
        static let credentialsKey = "credentialsKey"
        static let emailKey = "emailKey"
    }
    
    // TODO: Use keychain
    internal var loginViewController: AuthenticatorBasicViewController?
    internal var completion: TokenCompletion?
    
    func getToken(completion:@escaping TokenCompletion) {
        
        if let token = UserDefaults.standard.string(forKey: Constants.credentialsKey) {
            completion(token, nil, type)
            return
        }
        
        loginViewController = AuthenticatorBasicViewController()
        
        guard let controller = AuthenticatorBasicImplementer.topViewController(),
            let loginViewController = loginViewController else {
            completion(nil, nil, type)
            return
        }
        
        self.completion = completion
        loginViewController.delegate = self
        controller.present(loginViewController, animated: true, completion: nil)
    }
    
    func hasToken() -> String? {
        return UserDefaults.standard.string(forKey: Constants.credentialsKey)
    }
    
    func logout() {
        UserDefaults.standard.setValue(nil, forKey: Constants.credentialsKey)
        UserDefaults.standard.synchronize()
    }
    
    func getOrganization() -> String {
        let defaultOrganization = AuthenticatorUtils.Constants.defaultOrganization
        guard let userEmail = UserDefaults.standard.string(forKey: Constants.emailKey) else {
            return defaultOrganization
        }
        
        return AuthenticatorUtils.getUserOrganization(email: userEmail) ?? defaultOrganization
    }
}

extension AuthenticatorBasicImplementer : AuthenticatorBasicViewControllerDelegate {
    
    func authenticate(userEmail: String?, password: String?) {
        
        loginViewController?.dismiss(animated: true, completion: { [weak self] in
            self?.loginViewController = nil
        })
        
        guard let userEmail = userEmail, let password = password else {
            return
        }

        let userToken = token(userEmail: userEmail, password: password)
        UserDefaults.standard.setValue(userToken, forKey: Constants.credentialsKey)
        UserDefaults.standard.setValue(userEmail, forKey: Constants.emailKey)
        UserDefaults.standard.synchronize()
        completion?(userToken, nil, type)
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
    
    func token(userEmail: String, password: String) -> String {
        let credentialData = "\(userEmail):\(password)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString()
        return base64Credentials
    }
}
