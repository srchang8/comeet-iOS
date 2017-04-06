//
//  MetroAreaViewModel.swift
//  comeet
//
//  Created by Ricardo Contreras on 3/25/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import Foundation

class MetroareaViewModel : BaseViewModel {
    
    let authenticator: AuthenticatorProtocol
    let fetcher: FetcherProtocol
    let persistor: PersistorProtocol
    var reloadBinding: ReloadBinding?
    let selectedDate: Date
    private var searchCriteria: [SearchCriteria] = []
    
    init(authenticator: AuthenticatorProtocol, fetcher: FetcherProtocol, selectedDate: Date, persistor: PersistorProtocol) {
        self.authenticator = authenticator
        self.fetcher = fetcher
        self.selectedDate = selectedDate
        self.persistor = persistor
    }
    
    func title() -> String {
        return "Metropolitan areas"
    }
    
    func fetchSearchCriteria() {
        fetcher.getSearchCriteria(organization: authenticator.getOrganization()) { [weak self] (searchCriteria, error) in
            guard error == nil else {
                print(error!)
                return
            }
            if let searchCriteria = searchCriteria {
                DispatchQueue.main.async {
                    self?.searchCriteria = searchCriteria
                    self?.reloadBinding?()
                }
            } else {
                print("getSearchCriteria returned nil")
            }
        }
    }
    
    func metroareaCached() -> String? {
        return persistor.getMetroArea()
    }
    
    func save(metroarea: String?) {
        persistor.save(metroArea: metroarea)
    }
    
    func metroareaCount() -> Int {
        return searchCriteria.count
    }
    
    func metroareaName(index: Int) -> String {
        guard searchCriteria.count > index else {
            return ""
        }
        return searchCriteria[index].metroarea
    }
    
    func roomsLists(index: Int) -> [RoomList] {
        guard searchCriteria.count > index else {
            return []
        }
        return searchCriteria[index].roomsLists
    }
    
    func roomsLists(metroarea: String) -> [RoomList]? {
        for searchCriterion in searchCriteria {
            if searchCriterion.metroarea == metroarea {
                return searchCriterion.roomsLists
            }
        }
        return nil
    }
}
