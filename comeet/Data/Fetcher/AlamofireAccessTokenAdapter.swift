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
    private struct Constants {
        static let bearerKey = "Bearer"
        static let authorizationHeaderField = "Authorization"
    }
    
    
    init(accessToken: String) {
        self.accessToken = accessToken
    }
    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        
        urlRequest.setValue(Constants.bearerKey + " " + accessToken, forHTTPHeaderField: Constants.authorizationHeaderField)
        
        return urlRequest
    }
}
