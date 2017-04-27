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
    
    let type = AuthType.oauth2
    
    internal var organization: String?
    
    func getToken(completion:@escaping TokenCompletion) {
        var error: ADAuthenticationError?
        let authContext: ADAuthenticationContext = ADAuthenticationContext(authority: AuthenticatorADALSettings.authority,
                                                                           error: &error)
        
        authContext.acquireToken(withResource: AuthenticatorADALSettings.resource, clientId: AuthenticatorADALSettings.clientId, redirectUri: AuthenticatorADALSettings.redirectUri) { [weak self] (result: ADAuthenticationResult?) in
            self?.handle(result: result, error: error, completion: completion)
        }
    }
    
    func hasToken() -> String? {
        var error: AutoreleasingUnsafeMutablePointer<ADAuthenticationError?>?
        guard let allItems = ADKeychainTokenCache.defaultKeychain().allItems(error) else {
            return nil
        }
        
        for item in allItems {
            if let accessToken = item.accessToken, item.clientId == AuthenticatorADALSettings.Constants.clientId {
                return accessToken
            }
        }
        return nil
    }
    
    func logout() {
        var error: AutoreleasingUnsafeMutablePointer<ADAuthenticationError?>?
        ADKeychainTokenCache.defaultKeychain().removeAll(forClientId: AuthenticatorADALSettings.clientId, error: error)
        
        guard error == nil else {
            return
        }
        organization = nil
        self.deleteCookies(cookiesNames: AuthenticatorADALSettings.authCookies)
    }
    
    func getOrganization() -> String {
        return organization ?? AuthenticatorUtils.Constants.defaultOrganization
    }
}

internal extension AuthenticatorADALImplementer {
    
    func handle(result: ADAuthenticationResult?, error: ADAuthenticationError?, completion:@escaping TokenCompletion) {
        guard error == nil else {
            completion(nil, error, type)
            return
        }
        guard result?.status.rawValue == AD_SUCCEEDED.rawValue,
            let token = result?.accessToken,
            let item = result?.tokenCacheItem else {
                completion(nil, error, type)
                return
        }
        saveUserEmail(item: item)
        completion(token, error, type)
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
            organization = AuthenticatorUtils.getUserOrganization(email: userEmail)
        } else if let userId = userInformation.userId  {
            organization = AuthenticatorUtils.getUserOrganization(email: userId)
        }
    }
}
