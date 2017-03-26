//
//  Router.swift
//  comeet
//
//  Created by Ricardo Contreras on 3/12/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import Foundation
import UIKit

class Router {
    
    static var selectedMetroarea: String?
    static var selectedRoomsLists: [String]?
    static var selectedRoomsList: String?
    static var selectedRoom: Room?
    
    struct Constants {
        static let mainMenuSegue = "MainMenuSegue"
        static let metroareaSegue = "MetroareaSegue"
        static let roomsListsSegue = "RoomsListsSegue"
        static let roomsListSegue = "RoomsListSegue"
        static let roomDetailSegue = "RoomDetailSegue"
        static let incorrectRouteMessage = "Incorrect route"
    }
    
    static func prepare(identifier: String, destination: UIViewController, sourceViewModel: BaseViewModel) {
        switch identifier {
        case Constants.mainMenuSegue:
            prepareMainMenu(identifier: identifier, destination: destination, sourceViewModel: sourceViewModel)
            break
        case Constants.metroareaSegue:
            prepareMetroarea(identifier: identifier, destination: destination, sourceViewModel: sourceViewModel)
            break
        case Constants.roomsListsSegue:
            prepareRoomsLists(identifier: identifier, destination: destination, sourceViewModel: sourceViewModel)
            break
        case Constants.roomsListSegue:
            prepareRoomsList(identifier: identifier, destination: destination, sourceViewModel: sourceViewModel)
            break
        case Constants.roomDetailSegue:
            prepareRoomDetail(identifier: identifier, destination: destination, sourceViewModel: sourceViewModel)
        default:
            return
        }
    }
    
    private static func prepareMainMenu(identifier: String, destination: UIViewController, sourceViewModel: BaseViewModel) {
        guard identifier == Constants.mainMenuSegue,
            let toVC = destination as? MainMenuViewController,
            let fromVM = sourceViewModel as? LoginViewModel else {
                assert(false, Constants.incorrectRouteMessage)
                return
        }
        
        let toVM = MainMenuViewModel(authenticator: fromVM.authenticator, fetcher: fromVM.fetcher)
        toVC.viewModel = toVM
    }
    
    private static func prepareMetroarea(identifier: String, destination: UIViewController, sourceViewModel: BaseViewModel) {
        guard identifier == Constants.metroareaSegue,
            let toVC = destination as? MetroareaViewController,
            let fromVM = sourceViewModel as? MainMenuViewModel else {
                assert(false, Constants.incorrectRouteMessage)
                return
        }
        
        let toVM = MetroareaViewModel(authenticator: fromVM.authenticator, fetcher: fromVM.fetcher)
        
        toVC.viewModel = toVM
    }
    
    private static func prepareRoomsLists(identifier: String, destination: UIViewController, sourceViewModel: BaseViewModel) {
        guard identifier == Constants.roomsListsSegue,
            let toVC = destination as? RoomsListsViewController,
            let fromVM = sourceViewModel as? MetroareaViewModel,
            let metroarea = Router.selectedMetroarea,
            let roomsLists = Router.selectedRoomsLists else {
                assert(false, Constants.incorrectRouteMessage)
                return
        }
        
        let toVM = RoomsListsViewModel(authenticator: fromVM.authenticator, fetcher: fromVM.fetcher, metroarea: metroarea , roomsLists: roomsLists)
        
        toVC.viewModel = toVM
    }
    
    private static func prepareRoomsList(identifier: String, destination: UIViewController, sourceViewModel: BaseViewModel) {
        guard identifier == Constants.roomsListSegue,
            let toVC = destination as? RoomsListViewController,
            let fromVM = sourceViewModel as? RoomsListsViewModel,
            let metroarea = Router.selectedMetroarea,
            let roomsList = Router.selectedRoomsList else {
                assert(false, Constants.incorrectRouteMessage)
                return
        }
        
        let toVM = RoomsListViewModel(authenticator: fromVM.authenticator, fetcher: fromVM.fetcher, metroarea: metroarea, roomsList: roomsList)
        toVC.viewModel = toVM
    }
    
    private static func prepareRoomDetail(identifier: String, destination: UIViewController, sourceViewModel: BaseViewModel) {
        guard identifier == Constants.roomDetailSegue,
            let toVC = destination as? RoomDetailViewController,
            let fromVM = sourceViewModel as? RoomsListViewModel,
            let metroarea = Router.selectedMetroarea,
            let roomsList = Router.selectedRoomsList,
            let room = Router.selectedRoom else {
                assert(false, Constants.incorrectRouteMessage)
                return
        }
        
        let toVM = RoomDetailViewModel(authenticator: fromVM.authenticator, fetcher: fromVM.fetcher, metroarea: metroarea, roomsList: roomsList, room: room)
        toVC.viewModel = toVM
    }
}
