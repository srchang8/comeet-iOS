//
//  MyAgendaViewModel.swift
//  comeet
//
//  Created by stephen chang on 3/28/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import Foundation

class MyAgendaViewModel : BaseViewModel {let authenticator: AuthenticatorProtocol
    
    let fetcher: FetcherProtocol
    let persistor: PersistorProtocol
    internal let loader = DataSimpleBridge.getLoader()
    var reloadBinding: ReloadBinding?
    internal var selectedDate: Date
    internal var meetings: [Meeting] = []
    internal var testing = false
    
    init(authenticator: AuthenticatorProtocol, fetcher: FetcherProtocol, persistor: PersistorProtocol, selectedDate: Date) {
        self.persistor = persistor
        self.authenticator = authenticator
        self.fetcher = fetcher
        self.selectedDate = selectedDate
    }
    
    struct Constants {
        static let loadingText = "Loading Meetings"
    }
    
    func change(date: Date) {
        selectedDate = date
        // TODO: Go to date or fetchMeetings()
    }
    
    func fetchMeetings() {
        
        fetcher.getMeetings(organization: authenticator.getOrganization(), user: "", start: "", end: "") { [weak self] (meetings: [Meeting]?, error: Error?) in
            
            guard error == nil else {
                // TODO: surface error in UI?
                print(error!)
                return
            }
            if let meetings = meetings {
                DispatchQueue.main.async {
                    self?.meetings = meetings
                    self?.reloadBinding?()
                }
            } else {
                print("fetcher.getRooms returned nil")
            }
        }
    }
    
    func meetingsCount() -> Int {
        return meetings.count
    }
    
    func meetingSubject(index: Int) -> String {
        guard meetings.count > index else {
            return ""
        }
        let meeting = meetings[index]
        return meeting.subject ?? ""
    }
    
    func meetingTime(index: Int) -> String {
        guard meetings.count > index else {
            return ""
        }
        let meeting = meetings[index]
        
        if let start = meeting.start {
            return "\(start.displayStringDate()) \(start.displayStringHourMinute())"
        } else {
            return ""
        }
        
    }
    
    func meetingRoom(index: Int) -> String {
        guard meetings.count > index else {
            return ""
        }
        let meeting = meetings[index]
        return meeting.room?.name ?? ""
    }
}

private extension MyAgendaViewModel {

}
