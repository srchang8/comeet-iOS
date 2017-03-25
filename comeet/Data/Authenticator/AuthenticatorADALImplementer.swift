//
//  AuthenticatorADALImplementer.swift
//  comeet
//
//  Created by Ricardo Contreras on 3/6/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import Foundation
import ADAL

class AuthenticatorADALImplementer : AuthenticatorProtocol {
    
    private struct Constants {
        static let authority = "https://login.microsoftonline.com/common"
        static let resource = "https://outlook.office365.com"
        static let clientId = "a64d56ea-5675-4ccf-82e9-5757620e1d26"
        static let redirectUri = URL(string: "http://localhost/comeet")
        static let authCookies = ["MSISAuth", "MSISAuthenticated", "MSISLoopDetectionCookie"]
        static let defaultOrganization = "organization"
    }
    
    internal var organization: String?
    
    func getToken(completion:@escaping TokenCompletion) {
        var error: ADAuthenticationError?
        let authContext: ADAuthenticationContext = ADAuthenticationContext(authority: Constants.authority,
                                                                           error: &error)
        
        authContext.acquireToken(withResource: Constants.resource, clientId: Constants.clientId, redirectUri: Constants.redirectUri) { [weak self] (result: ADAuthenticationResult?) in
            self?.handle(result: result, error: error, completion: completion)
        }
    }
    
    func isLoggedIn() -> Bool {
        var error: AutoreleasingUnsafeMutablePointer<ADAuthenticationError?>?
        guard let allItems = ADKeychainTokenCache.defaultKeychain().allItems(error) else {
            return false
        }
        return allItems.count > 0
    }
    
    func logout() {
        var error: AutoreleasingUnsafeMutablePointer<ADAuthenticationError?>?
        ADKeychainTokenCache.defaultKeychain().removeAll(forClientId: Constants.clientId, error: error)
        
        guard error == nil else {
            return
        }
        organization = nil
        self.deleteCookies(cookiesNames: Constants.authCookies)
    }
    
    func getOrganization() -> String {
        return organization ?? Constants.defaultOrganization
    }
}

internal extension AuthenticatorADALImplementer {
    
    func handle(result: ADAuthenticationResult?, error: ADAuthenticationError?, completion:@escaping TokenCompletion) {
        guard error == nil else {
            completion(nil, error)
            return
        }
        guard result?.status.rawValue == AD_SUCCEEDED.rawValue,
            let token = result?.accessToken,
            let item = result?.tokenCacheItem else {
                completion(nil, error)
                return
        }
        saveUserEmail(item: item)
        completion(token, error)
    }
    
    func deleteCookies(cookiesNames: [String]) {
        let cookieJar = HTTPCookieStorage.shared
        guard let cookies = cookieJar.cookies else {
            return
        }
        for cookie in cookies {
            if (cookiesNames.contains(cookie.name)) {
                cookieJar.deleteCookie(cookie)
            }
        }
    }
    
    func saveUserEmail(item: ADTokenCacheItem) {
        guard let userInformation = item.userInformation else {
            return
        }
        
        if let userEmail = userInformation.eMail {
            organization = getUserOrganization(email: userEmail)
        } else if let userId = userInformation.userId  {
            organization = getUserOrganization(email: userId)
        }
    }
    
    func getUserOrganization(email: String) -> String? {
        let components = email.components(separatedBy: "@")
        guard components.count == 2 else {
            return nil
        }
        return components[1]
    }
}
