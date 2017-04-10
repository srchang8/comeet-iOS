//
//  MainMenuViewController.swift
//  comeet
//
//  Created by stephen chang on 3/9/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import UIKit
import SSCalendar

class MainMenuViewController: SSCalendarDailyViewController {
    
    var viewModel: MainMenuViewModel?
    
    required init(coder: NSCoder) {
        super.init(coder: coder)!
        self.addEvents([])
        self.day = SSDayNode(value: 10, month: 4, year: 2017, weekday: 0)
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
    
    @IBAction func logOut(_ sender: Any) {
        viewModel?.logout()
        _=navigationController?.popViewController(animated: true)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier,
            let viewModel = viewModel else {
                print("")
                return
        }
        Router.prepare(identifier: identifier, destination: segue.destination, sourceViewModel: viewModel)
    }

    @IBAction func bookAction(_ sender: Any) {
        performSegue(withIdentifier: Router.Constants.metroareaSegue, sender: self)
    }
    
//    static func generateEvents() -> [SSEvent] {
//        return [MainMenuViewController.demoEventA(),
//                MainMenuViewController.demoEventB(),
//                MainMenuViewController.demoEventC()]
//    }
//    
//    static func demoEventA() -> SSEvent {
//        let event = SSEvent()
//        event.startDate = SSCalendarUtils.date(withYear: 2017, month: 04, day: 07)
//        event.startTime = "09:30"
//        event.name = "Review design for upcoming features."
//        return event
//    }
//    
//    static func demoEventB() -> SSEvent {
//        let event = SSEvent()
//        event.startDate = SSCalendarUtils.date(withYear: 2017, month: 04, day: 07)
//        event.startTime = "10:00"
//        event.name = "Sprint 2 retrospective."
//        return event
//    }
//    
//    static func demoEventC() -> SSEvent {
//        let event = SSEvent()
//        event.startDate = SSCalendarUtils.date(withYear: 2017, month: 04, day: 07)
//        event.startTime = "12:30"
//        event.name = "Prepare sprint 3 demo."
//        return event
//    }
}

private extension MainMenuViewController {
    func setup() {
        
        title = viewModel?.title()
        navigationItem.setHidesBackButton(true, animated: false)
        
        dateChanged = { [weak self] (date: Date?) in
            if let date = date {
                self?.viewModel?.selectedDate = date
            }
        }
        
        viewModel?.reloadBinding = { [weak self] in
            self?.addEvents(self?.viewModel?.events())
        }
        
        viewModel?.fetchMeetings()
    }
}
