//
//  FetcherAlamofireImplementer.swift
//  comeet
//
//  Created by Ricardo Contreras on 3/11/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import Foundation
import Alamofire

class FetcherAlamofireImplementer : FetcherProtocol {
    
    private let sessionManager = SessionManager()
    private var endpoints = Endpoints(environment: .Mocked)
    
    func set(environment: Environment) {
        endpoints = Endpoints(environment: environment)
    }
    
    func set(accessToken: String) {
        sessionManager.adapter = AlamofireAccessTokenAdapter(accessToken: accessToken)
    }
    
    func getRooms(organization: String,completion:@escaping FetchRoomsCompletion) {
        sessionManager.request(endpoints.getRooms(organization: organization)).responseJSON { (response) in
            var rooms: [Room]?
            if let array = FetcherAlamofireImplementer.getArray(response: response) {
                rooms = RoomParser.parseRooms(roomsArray: array)
            }
            completion(rooms, response.error)
        }
    }
    
    func getSearchCriteria(organization: String, completion:@escaping FetchSearchCriteriaCompletion) {
        sessionManager.request(endpoints.getSeatchCriteria(organization: organization)).responseJSON { (response) in
            var searchCriteria: [SearchCriteria]?
            if let array = FetcherAlamofireImplementer.getArray(response: response) {
                searchCriteria = SearchCriteriaParser.parseSearchCriteria(searchCriteriaArray: array)
            }
            completion(searchCriteria, response.error)
        }
    }
}

private extension FetcherAlamofireImplementer {
    
    static func getArray(response: DataResponse<Any>) -> [Any]? {
        guard let array = response.result.value as? [Any] else {
                return nil;
        }
        return array
    }
}
