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
    
    struct Constants {
        static let mainMenudentifier = "MainMenuSegue"
        static let roomsListIdentifier = "RoomsListSegue"
        static let incorrectRouteMessage = "Incorrect route"
    }
    
    static func prepare(identifier: String, destination: UIViewController, sourceViewModel: BaseViewModel) {
        switch identifier {
        case Constants.mainMenudentifier:
            prepareMainMenu(identifier: identifier, destination: destination, sourceViewModel: sourceViewModel)
            break
        case Constants.roomsListIdentifier:
            prepareRoomsList(identifier: identifier, destination: destination, sourceViewModel: sourceViewModel)
            break
        default:
            return
        }
    }
    
    private static func prepareMainMenu(identifier: String, destination: UIViewController, sourceViewModel: BaseViewModel) {
        guard identifier == Constants.mainMenudentifier,
            let mainMenuViewController = destination as? MainMenuViewController,
            let loginViewModel = sourceViewModel as? LoginViewModel else {
                assert(false, Constants.incorrectRouteMessage)
                return
        }
        
        let mainMenuViewModel = MainMenuViewModel(authenticator: loginViewModel.authenticator,
                                                  fetcher: loginViewModel.fetcher)
        mainMenuViewController.viewModel = mainMenuViewModel
    }
    
    private static func prepareRoomsList(identifier: String, destination: UIViewController, sourceViewModel: BaseViewModel) {
        guard identifier == Constants.roomsListIdentifier,
            let roomsListViewController = destination as? RoomsListViewController,
            let mainMenuViewModel = sourceViewModel as? MainMenuViewModel else {
                assert(false, Constants.incorrectRouteMessage)
                return
        }
        
        let roomsListViewModel = RoomsListViewModel(authenticator: mainMenuViewModel.authenticator,
                                                    fetcher: mainMenuViewModel.fetcher)
        roomsListViewController.viewModel = roomsListViewModel
    }
}
