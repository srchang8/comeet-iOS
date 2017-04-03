//
//  AlamofireAccessTokenAdapter.swift
//  comeet
//
//  Created by Ricardo Contreras on 3/12/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import Foundation
import Alamofire

class AlamofireAccessTokenAdapter: RequestAdapter {
    private let accessToken: String
    private var authType: AuthType
    private struct Constants {
        static let bearerKey = "Bearer"
        static let basicKey = "Basic"
        static let authorizationHeaderField = "Authorization"
    }
    private var authValue: String {
        get {
            switch authType {
            case .basic:
                return Constants.basicKey + " " + accessToken
            case .oauth2:
                return Constants.bearerKey + " " + accessToken
            }
        }
    }
    
    init(accessToken: String, type: AuthType) {
        self.accessToken = accessToken
        self.authType = type
    }
    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        
        urlRequest.setValue(authValue, forHTTPHeaderField: Constants.authorizationHeaderField)
        
        return urlRequest
    }
}
