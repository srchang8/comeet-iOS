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
        static let roomsListIdentifier = "GoToRoomsList"
        static let incorrectRouteMessage = "Incorrect route"
    }
    
    static func prepare(identifier: String, destination: UIViewController, sourceViewModel: BaseViewModel) {
        switch identifier {
        case Constants.roomsListIdentifier:
            prepareRoomsList(identifier: identifier, destination: destination, sourceViewModel: sourceViewModel)
            break
        default:
            return
        }
    }
    
    private static func prepareRoomsList(identifier: String, destination: UIViewController, sourceViewModel: BaseViewModel) {
        guard identifier == Constants.roomsListIdentifier,
            let roomsListViewController = destination as? RoomsListViewController,
            let loginViewModel = sourceViewModel as? LoginViewModel else {
                assert(false, Constants.incorrectRouteMessage)
                return
        }
        
        let roomsListViewModel = RoomsListViewModel(authenticator: loginViewModel.authenticator,
                                                    fetcher: loginViewModel.fetcher)
        roomsListViewController.viewModel = roomsListViewModel
    }
}
