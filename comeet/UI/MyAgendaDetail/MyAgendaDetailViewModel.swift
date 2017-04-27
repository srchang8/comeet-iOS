//
//  MyAgendaDetailViewModel.swift
//  comeet
//
//  Created by Ricardo Contreras on 4/26/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import Foundation

class MyAgendaDetailViewModel: BaseViewModel {
    
    let authenticator: AuthenticatorProtocol
    let fetcher: FetcherProtocol
    let persistor: PersistorProtocol
    internal let loader = DataSimpleBridge.getLoader()
    var reloadBinding: ReloadBinding?
    internal var selectedDate: Date
    internal var testing = false
    internal var selectedMeeting: Meeting
    internal var selectedMeetingData: Meeting?
    
    init(authenticator: AuthenticatorProtocol, fetcher: FetcherProtocol, persistor: PersistorProtocol, selectedDate: Date, selectedMeeting: Meeting) {
        self.persistor = persistor
        self.authenticator = authenticator
        self.fetcher = fetcher
        self.selectedDate = selectedDate
        self.selectedMeeting = selectedMeeting
    }
    
    struct Constants {
        static let loadingText = "Loading Meeting"
        static let attendeesText = "Attendees:"
    }
    
    func fetchMeetingData() {
        
        showLoading()
        fetcher.getMeetingData(organization: authenticator.getOrganization(), id: selectedMeeting.id) { [weak self] (meeting, error) in
            
            self?.hideLoading()
            guard error == nil else {
                // TODO: surface error in UI?
                print(error!)
                return
            }
            if let meeting = meeting {
                DispatchQueue.main.async {
                    self?.selectedMeetingData = meeting
                    self?.reloadBinding?()
                }
            }

        }
    }
    
    func titleText() -> String {
        if let subject = selectedMeetingData?.subject,
            let room = selectedMeetingData?.room {
            return "\(subject) in \(room.name)"
        } else {
            return selectedMeetingData?.subject ?? ""
        }
    }
    
    func timeText() -> String {
        if let meeting = selectedMeetingData {
            return "\(meeting.start.displayString()) \(meeting.start.displayStringHourMinute()) - \(meeting.end.displayStringHourMinute())"
        } else {
            return ""
        }
    }
    
    func detailText() -> String {
        
        guard let body = selectedMeetingData?.body else {
            return ""
        }
        
        let bodyStart = body.range(of: "<body>")
        let bodyEnd = body.range(of: "</body>")
        if let bodyStart = bodyStart,
            let bodyEnd = bodyEnd {
            let bodyRange = Range(uncheckedBounds: (lower: bodyStart.upperBound, upper: bodyEnd.lowerBound))
            return body.substring(with: bodyRange)
        } else {
            return body
        }
    }
    
    func attendeesText() -> String {
        var attendeesText = "  \(Constants.attendeesText)"
        if let required = selectedMeetingData?.requiredattendees {
            for user in required {
                if user.email != selectedMeetingData?.room?.email {
                    attendeesText += "\n  \(user.name)"
                }
            }
        }
        if let optional = selectedMeetingData?.optionalattendees {
            for user in optional {
                if user.email != selectedMeetingData?.room?.email {
                    attendeesText += "\n  \(user.name)"
                }
            }
        }
        
        return attendeesText
    }
    
    func roomPicture() -> URL? {
        if let picture = selectedMeetingData?.room?.picture {
            return URL(string: picture)
        } else {
            return nil
        }
    }
    
    func roomLatLong() -> (Double, Double)? {
        guard let room = selectedMeetingData?.room else {
            return nil
        }
        if let lat = room.latitude,
            let long = room.longitude {
            return (lat, long)
        }
        return nil
    }
    
    func roomName() -> String? {
        guard let room = selectedMeetingData?.room else {
            return nil
        }
        return room.name
    }
}

private extension MyAgendaDetailViewModel {
    
    func showLoading() {
        if (!testing) {
            loader.show(text: Constants.loadingText)
        }
    }
    
    func hideLoading() {
        if (!testing) {
            loader.hide()
        }
    }
}
