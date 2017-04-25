//
//  AuthenticatorADALSettings.swift
//  comeet
//
//  Created by Kevin Burek on 4/22/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import Foundation

class AuthenticatorADALSettings {
    
    internal struct Constants {
        static let authority = "https://login.microsoftonline.com/common"
        /// OAuth2 permission scopes:
        /// Exchange Web Services permission:
        ///
        /// Outlook REST Api calendar read permission:
        ///   https://msdn.microsoft.com/en-us/office/office365/api/calendar-rest-operations#GetEvent
        static let resource = "https://outlook.office365.com" // For meeting share: https://outlook.office.com/calendars.read
        static let clientId = "a2a8a356-0919-41d9-84c1-f964e892e297"
        static let redirectUri = URL(string: "http://localhost/comeet")
        static let authCookies = ["MSISAuth", "MSISAuthenticated", "MSISLoopDetectionCookie"]
    }
    
    static var authority = getAuthority()
    
    private class func getAuthority() -> String {
        if let val = UserDefaults.standard.string(forKey: "oauth_authority") {
            return val
        }
        return Constants.authority
    }
    
    static var resource = getResource()
    
    private class func getResource() -> String {
        if let val = UserDefaults.standard.string(forKey: "oauth_scope") {
            return val
        }
        return Constants.resource
    }
    
    static var clientId = getClientId()
    
    private class func getClientId() -> String {
        if let val = UserDefaults.standard.string(forKey: "oauth_clientid") {
            return val
        }
        return Constants.clientId
    }
    
    static var redirectUri = getRedirectUri()
    
    private class func getRedirectUri() -> URL {
        return Constants.redirectUri!
    }
    
    static var authCookies = getAuthCookies()
    
    private class func getAuthCookies() -> [String] {
        return Constants.authCookies
    }
}
