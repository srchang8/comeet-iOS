//
//  MainMenuViewController.swift
//  comeet
//
//  Created by stephen chang on 3/9/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import UIKit
import SSCalendar

class MainMenuViewController: BaseViewController {
    
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    var viewModel: MainMenuViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier,
            let viewModel = viewModel else {
                print("")
                return
        }
        Router.prepare(identifier: identifier, destination: segue.destination, sourceViewModel: viewModel)
    }

    @IBAction func logOut(_ sender: Any) {
        viewModel?.logout()
        _=navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func changeDate(_ sender: Any) {
        
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "calendarPopUp") as! CalendarViewController
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
        
    }
    
    
}

private extension MainMenuViewController {
    func setup() {
        
        title = viewModel?.title()
        navigationItem.setHidesBackButton(true, animated: false)
        
        dateButton.setTitle(viewModel?.selectedDate.displayStringDate(), for: .normal)
        addRoomsList()
    }
    
    func addRoomsList() {
        if let roomsListVC = getRoomsListVC() {
            addChild(viewController: roomsListVC, inView: containerView)
        }
    }
    
    func addChild(viewController: UIViewController, inView: UIView) {
        addChildViewController(viewController)
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        inView.addSubview(viewController.view)
        viewController.didMove(toParentViewController: self)
        
        let views = ["viewControllerView" : viewController.view]
        let vflVertical = "V:|[viewControllerView]|"
        let vflHorizontall = "H:|[viewControllerView]|"
        
        inView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: vflVertical, options: [], metrics: nil, views: views))
        inView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: vflHorizontall, options: [], metrics: nil, views: views))
    }
    
    func getRoomsListVC() -> RoomsListViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "RoomsListViewController")
        guard let roomsListVC = viewController as? RoomsListViewController else {
            return nil
        }
        if let roomsListViewModel = getRoomsListViewModel() {
            roomsListVC.viewModel = roomsListViewModel
        }
        
        return roomsListVC
    }
    
    func getRoomsListViewModel() -> RoomsListViewModel? {
        guard let viewModel = viewModel else {
            return nil
        }
        let roomsListViewModel = RoomsListViewModel(authenticator: viewModel.authenticator, fetcher: viewModel.fetcher, persistor: viewModel.persistor, selectedDate: viewModel.selectedDate, metroarea: nil, roomsList: nil)
        return roomsListViewModel
    }

}
