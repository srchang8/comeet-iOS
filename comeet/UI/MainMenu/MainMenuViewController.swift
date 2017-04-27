//
//  MainMenuViewController.swift
//  comeet
//
//  Created by stephen chang on 3/9/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import UIKit
import WWCalendarTimeSelector

class MainMenuViewController: BaseViewController {
    
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var guideView: UIView!
    
    
    var viewModel: MainMenuViewModel?
    
    var agendaVC: MyAgendaViewController?
    var roomListVC: RoomsListViewController?
    internal struct Constants {
        static let roomsBookedNotification = "RoomsBooked"
    }
    
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
        
        let calendarVC = createCalendar()
        calendarVC.popoverPresentationController?.sourceView = sender as? UIButton
        present(calendarVC, animated: true, completion: nil)
    }
    
    func containerViewSwiped(gesture: UISwipeGestureRecognizer) {
        switch gesture.direction {
        case UISwipeGestureRecognizerDirection.left:
            showAgenda()
        case UISwipeGestureRecognizerDirection.right:
            showRoomsList()
        default:
            break
        }
    }
    
    func roomBooked(sender: Any) {
        self.agendaVC?.reloadAgenda()
        self.roomListVC?.reloadRooms()
        showAgenda()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension MainMenuViewController : WWCalendarTimeSelectorProtocol {

    //callback from WWCalendar library when a date is selected and done button is pressed
    func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, date: Date) {
        updateDateButton(date: date)
        roomListVC?.change(date: date)
        agendaVC?.change(date: date)
    }
}

private extension MainMenuViewController {
    func setup() {
        
        title = viewModel?.title()
        navigationItem.setHidesBackButton(true, animated: false)
        
        addGestureRecognizers()
        dateButton.setTitle(viewModel?.selectedDate.displayStringDate(), for: .normal)
        
        addRoomsList()
        addAgendaView()
        
        NotificationCenter.default.addObserver(self, selector: #selector (roomBooked(sender:)), name: NSNotification.Name(rawValue: Constants.roomsBookedNotification), object: nil)
    }
    
    func addGestureRecognizers() {
        //add swipe gesture recognizer to container view
        let swipeGestureLeft = UISwipeGestureRecognizer(target: self, action: #selector(containerViewSwiped(gesture:)))
        swipeGestureLeft.direction = UISwipeGestureRecognizerDirection.left
        let swipeGestureRight = UISwipeGestureRecognizer(target: self, action: #selector(containerViewSwiped(gesture:)))
        swipeGestureRight.direction = UISwipeGestureRecognizerDirection.right
        containerView.addGestureRecognizer(swipeGestureLeft)
        containerView.addGestureRecognizer(swipeGestureRight)
    }
    
    func addAgendaView() {
        if let agendaVC = getAgendaVC() {
            addChild(viewController: agendaVC, inView: containerView)
            self.agendaVC = agendaVC
            //hide agenda view initially
            agendaVC.view.isHidden = true
        }
    }
    
    func addRoomsList() {
        if let roomsListVC = getRoomsListVC() {
            // have a reference to the rooms list view controller
            self.roomListVC = roomsListVC
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
    
    //create a reference of Agenda VC
    func getAgendaVC() -> MyAgendaViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "MyAgendaViewController")
        guard let agendaVC = viewController as? MyAgendaViewController else {
            return nil
        }
        if let agendaViewModel = getMyAgendaViewModel() {
            agendaVC.viewModel = agendaViewModel
        }
        
        return agendaVC
    }
    
    func getRoomsListViewModel() -> RoomsListViewModel? {
        guard let viewModel = viewModel else {
            return nil
        }
        let roomsListViewModel = RoomsListViewModel(authenticator: viewModel.authenticator, fetcher: viewModel.fetcher, persistor: viewModel.persistor, selectedDate: viewModel.selectedDate, metroarea: nil, roomsList: nil)
        return roomsListViewModel
    }
    
    func getMyAgendaViewModel() -> MyAgendaViewModel? {
        guard let viewModel = viewModel else {
            return nil
        }
        let agendaViewModel = MyAgendaViewModel(authenticator: viewModel.authenticator, fetcher: viewModel.fetcher, persistor: viewModel.persistor, selectedDate: viewModel.selectedDate)
        return agendaViewModel
    }
    
    func createCalendar() -> WWCalendarTimeSelector {
        let calendarVC = WWCalendarTimeSelector.instantiate()
        calendarVC.optionTopPanelBackgroundColor = UIConstants.Colors.blue
        calendarVC.optionCalendarBackgroundColorTodayHighlight = UIConstants.Colors.blue
        calendarVC.optionSelectorPanelBackgroundColor = UIConstants.Colors.blue
        calendarVC.optionButtonFontColorDone = UIConstants.Colors.blue
        calendarVC.optionCalendarBackgroundColorFutureDatesHighlight = UIConstants.Colors.blue
        calendarVC.optionCalendarBackgroundColorPastDatesHighlight = UIConstants.Colors.blue
        calendarVC.delegate = self
        calendarVC.modalPresentationStyle = .popover
        return calendarVC
    }
    
    //helper function to convert the date into a string and use that string to update the title of the date button
    func updateDateButton(date: Date) {
        let df = DateFormatter()
        df.dateStyle = .medium
        let title = df.string(from: date)
        
        dateButton.setTitle(title, for: .normal)
    }
    
    func showAgenda() {
        if agendaVC?.view.isHidden ?? true {
            //animate fade in of agenda VC
            agendaVC?.view.alpha = 0.0
            agendaVC?.view.isHidden = false
            UIView.animate(withDuration: 0.5, animations: {
                self.agendaVC?.view.alpha = 1.0
                self.roomListVC?.view.alpha = 0.0
                let userDefault = UserDefaults.standard
                userDefault.set(false, forKey: "isAgendaGuideShown")
                let isGuideShown = userDefault.bool(forKey: "isAgendaGuideShown")
                if (!isGuideShown) {
                    let when = DispatchTime.now() + 3
                    DispatchQueue.main.asyncAfter(deadline: when) {
                        if ( self.agendaVC?.guideView.isHidden == false) {
                            self.agendaVC?.guideView.isHidden = true
                        }
                        userDefault.set(true, forKey: "isAgendaGuideShown")
                    }
                } else {
                    self.agendaVC?.guideView.isHidden = true
                }
            }, completion: { (success) in
                self.roomListVC?.view.isHidden = true
                
            })
        }
    }
    
    func showRoomsList() {
        if roomListVC?.view.isHidden ?? true {
            
            //animate fade in of agenda VC
            roomListVC?.view.alpha = 0.0
            roomListVC?.view.isHidden = false
            UIView.animate(withDuration: 0.5, animations: {
                self.roomListVC?.view.alpha = 1.0
                self.agendaVC?.view.alpha = 0.0
            }, completion: { (success) in
                self.agendaVC?.view.isHidden = true
                
            })
        }
    }
}
