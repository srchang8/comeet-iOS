//
//  RoomsListViewModel.swift
//  comeet
//
//  Created by Ricardo Contreras on 3/6/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import Foundation
import ALLoadingView

class RoomsListViewModel : BaseViewModel {
    
    let authenticator: AuthenticatorProtocol
    let fetcher: FetcherProtocol
    let persistor: PersistorProtocol
    internal let loader = DataSimpleBridge.getLoader()
    var reloadBinding: ReloadBinding?
    internal var selectedDate: Date
    private var metroarea: String?
    private(set) var roomsList: User?
    internal var rooms: [Room] = []
    internal var startDate : Date
    internal var endDate : Date
    internal var testing = false
    
    init(authenticator: AuthenticatorProtocol, fetcher: FetcherProtocol, persistor: PersistorProtocol, selectedDate: Date, metroarea: String?, roomsList: User?) {
        self.metroarea = metroarea
        self.roomsList = roomsList
        self.persistor = persistor
        self.authenticator = authenticator
        self.fetcher = fetcher
        self.selectedDate = selectedDate
        self.startDate = selectedDate
        self.endDate = selectedDate
    }
    
    struct Constants {
        static let startDateText = "Select Start"
        static let endDateText = "Select End"
        static let loadingText = "Loading Rooms"
        static let genericTitleText = "Select a Room"
        static let titleText = "Rooms in "
        static let capacityText = "Capacity: "
    }
    
    func newLocation(metroarea: String?, roomsList: User?) {
        self.metroarea = metroarea
        self.roomsList = roomsList
        fetchRooms()
    }
    
    func title() -> String {
        guard let name = roomsList?.name else {
            return Constants.genericTitleText
        }
        return Constants.titleText + name
    }

    
    func change(date: Date) {
        selectedDate = date
        startDate = startDate.changeYearMonthDay(newDate: date)
        endDate = endDate.changeYearMonthDay(newDate: date)
        fetchRooms()
    }
    
    func fetchRooms() {
        guard let email = roomsList?.email else {
            return
        }
    
        removeRooms()
        showLoading()
        
        fetcher.getRooms(organization: authenticator.getOrganization(), roomlist: email, start: startDateForRequest(), end: endDateForRequest()) { [weak self] (rooms, error) in
            
            self?.hideLoading()
            guard error == nil else {
                // TODO: surface error in UI?
                print(error!)
                return
            }
            if let rooms = rooms {
                DispatchQueue.main.async {
                    self?.rooms = rooms
                    self?.reloadBinding?()
                }
            } else {
                print("fetcher.getRooms returned nil")
            }
        }
    }
    
    func roomsCount() -> Int {
        return availableRooms().count
    }
    
    func roomName(index: Int) -> String {
        guard availableRooms().count > index else {
            return ""
        }
        let room = availableRooms()[index]
        return room.name
    }
    
    func roomDescription(index: Int) -> String {
        guard availableRooms().count > index else {
            return ""
        }
        let room = availableRooms()[index]
        if let capacity = room.capacity {
            return Constants.capacityText + "\(capacity)"
        }
        return room.email
    }
    
    func roomAmenities(index: Int) -> [Amenity] {
        guard availableRooms().count > index else {
            return []
        }
        let room = availableRooms()[index]
        return room.amenities ?? []
    }

    func roomLatLong(index: Int) -> (Double, Double)? {
        guard availableRooms().count > index else {
            return nil
        }
        let room = availableRooms()[index]
        if let lat = room.latitude,
            let long = room.longitude {
            return (lat, long)
        }
        return nil
    }
    
    func roomPicture(index: Int) -> URL? {
        guard availableRooms().count > index else {
            return nil
        }
        guard let picture = availableRooms()[index].picture else {
            return nil
        }
        return URL(string: picture)
    }
    
    func roomFloorPlan(index: Int) -> URL? {
        guard availableRooms().count > index else {
            return nil
        }
        guard let picture = availableRooms()[index].navigation else {
            return nil
        }
        return URL(string: picture)
    }
    
    func room(index: Int) -> Room? {
        guard availableRooms().count > index else {
            return nil
        }
        return availableRooms()[index]
    }

    func startTime(value: CGFloat) -> String {
        let rooms = availableRooms()
        startDate = Date.dateFrom(sliderValue: Float(value), date: selectedDate)
        if rooms != availableRooms() {
            reloadBinding?()
        }
        return startDate.displayStringHourMinute()
    }
    
    func endTime(value: CGFloat) -> String {
        let rooms = availableRooms()
        endDate = Date.dateFrom(sliderValue: Float(value), date: selectedDate)
        if rooms != availableRooms() {
            reloadBinding?()
        }
        return endDate.displayStringHourMinute()
    }
    
    func locationPersisted() -> Bool {
        if let metroarea = persistor.getMetroArea(),
            let roomlist = persistor.getRoomlist() {
            Router.selectedMetroarea = metroarea
            Router.selectedRoomsList = roomlist
            self.metroarea = metroarea
            self.roomsList = roomlist
            newLocation(metroarea: metroarea, roomsList: roomlist)
            return true
        } else {
            return false
        }
    }
}

private extension RoomsListViewModel {
    
    func startDateForRequest() -> String {
        let start = selectedDate.startOfDay()
        return start.stringISO8601()
    }
    
    func endDateForRequest() -> String {
        guard let end = selectedDate.endOfDay() else {
            return selectedDate.stringISO8601()
        }
        return end.stringISO8601()
    }
    
    func availableRooms() -> [Room] {
        return rooms.filter({ (room) -> Bool in
            guard let freebusy = room.freebusy, freebusy.count > 0 else {
                return true
            }
            return freebusy.isFree(start: startDate, end: endDate)
        })
    }
    
    func removeRooms() {
        if (!testing) {
            rooms = []
            reloadBinding?()
        }
    }
    
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
