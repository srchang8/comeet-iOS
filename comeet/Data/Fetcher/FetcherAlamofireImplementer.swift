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
    
    internal static let X_RestApiError = "X-com.comeet.RestApiError"
    
    private let sessionManager = SessionManager()
    private var endpoints = Endpoints(environment: .Production)
    
    func set(environment: Environment) {
        endpoints = Endpoints(environment: environment)
    }
    
    func set(accessToken: String, type: AuthType) {
        sessionManager.adapter = AlamofireAccessTokenAdapter(accessToken: accessToken, type: type)
    }
    
    func getSearchCriteria(organization: String, completion:@escaping FetchSearchCriteriaCompletion) {
        let request = sessionManager.request(endpoints.getSeatchCriteria(organization: organization))
        request.responseJSON { (response) in
            var searchCriteria: [SearchCriteria]?
            if let array = FetcherAlamofireImplementer.getArray(response: response) {
                searchCriteria = SearchCriteriaParser.parseSearchCriteria(searchCriteriaArray: array)
            }
            completion(searchCriteria, response.detailedError(request))
        }
    }
    
    func getRooms(organization: String, roomlist: String, start: String, end: String, completion:@escaping FetchRoomsCompletion) {
        let request = sessionManager.request(endpoints.getRooms(organization: organization, roomlist: roomlist, start: start, end: end))
        request.responseJSON { (response) in
            var rooms: [Room]?
            if let array = FetcherAlamofireImplementer.getArray(response: response) {
                rooms = RoomParser.parseRooms(roomsArray: array)
            }
            completion(rooms, response.detailedError(request))
        }
    }
    
    func bookRoom(organization: String, roomrecipient: String, params: [String: Any], completion:@escaping BookRoomCompletion) {
        let endpoint = endpoints.bookRoom(organization: organization, roomrecipient: roomrecipient)
        let request = sessionManager.request(endpoint, method: .post, parameters: params, encoding: URLEncoding.httpBody)
        request.responseJSON { (response) in
            guard let json = response.result.value as? [String : Bool],
                let success = json["success"] else {
                    completion(false, response.error)
                    return;
            }
            completion(success, response.error)
        }
    }
    
    func bookRoomParams(start: String, end: String, subject: String, body: String, requiredAttendees: String) -> [String: Any] {
        let params: [String: Any] = ["start": start,
                                     "end": end,
                                     "subject": subject,
                                     "body": body,
                                     "required": requiredAttendees]
        return params
    }
    
    func getMeetings(organization: String, user: String, start: String, end: String, completion:@escaping FetchMeetingsCompletion) {
        let endpoint = endpoints.getMeetings(organization: organization, start: start, end: end)
        let request = sessionManager.request(endpoint)
        request.responseJSON { (response) in
            var meetings: [Meeting]?
            if let array = FetcherAlamofireImplementer.getArray(response: response) {
                meetings = MeetingParser.parseMeetings(meetingsArray: array)
            }
            completion(meetings, response.detailedError(request))
        }
    }
    
    func getMeetingData(organization: String, id: String, completion:@escaping FetchMeetingCompletion) {
        let endpoint = endpoints.getMeetingData(organization: organization, id: id)
        let request = sessionManager.request(endpoint)
        request.responseJSON { (response) in
            if let meetingDict = response.result.value as? [AnyHashable : Any],
                let meeting = MeetingParser.parseMeeting(meetingDict: meetingDict) {
                completion(meeting, response.detailedError(request))
            } else {
                completion(nil, response.detailedError(request))
            }
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

private extension DataResponse {
    
    func detailedError(_ request: DataRequest) -> Error? {
        
        guard self.error != nil else {
            return nil
        }
        
        
        if let httpResponse = self.response {
            NSLog("HTTP Response:\(httpResponse.statusCode)")
            
            if let headers = httpResponse.allHeaderFields as? HTTPHeaders {
                if let error:String = headers[FetcherAlamofireImplementer.X_RestApiError] {
                    // Log the error we got in the header.
                    NSLog(error)
                }
                else if httpResponse.statusCode == .HTTP_STATUS_INTERNAL_SERVER_ERROR
                {
                    // No error in headers for HTTP 500.  Log entire message body.
                    request.responseString() { (response) in
                        if let body = response.result.value as String! {
                            NSLog(body)
                        }
                    }
                }
            }
        }
        return self.error
    }
    
}

fileprivate extension NSInteger {
    static let HTTP_STATUS_OK = 200
    static let HTTP_STATUS_INTERNAL_SERVER_ERROR = 500
}

