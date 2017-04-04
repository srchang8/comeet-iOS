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
    
    var viewModel: MainMenuViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        setup()
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
    
    
    
    @IBAction func openAgenda(_ sender: Any) {
        
        let viewController = SSCalendarDailyViewController(events: generateEvents())!
        viewController.day = SSDayNode(date: Date())
        let navigationController = self.navigationController!
        navigationController.navigationBar.isTranslucent = false
        navigationController.pushViewController(viewController, animated: true);
    }
    
    
    
    
    
    //MARK: - SSCalendar setup
    fileprivate func generateEvents() -> [SSEvent] {
        var events: [SSEvent] = []
        for year in 2016...2021 {
            for _ in 1...100 {
                events.append(generateEvent(year));
            }
        }
        
        let customEvent : SSEvent = SSEvent()
        customEvent.startDate = SSCalendarUtils.date(withYear: 2017, month: 3, day: 27)
        customEvent.startTime = "11:30"
        customEvent.name = "Ex"
        customEvent.desc = "Details of the event"
        
        events.append(customEvent)
        
        return events
    }
    
    //
    fileprivate func generateEvent(_ year: Int) -> SSEvent {
        let month = Int(arc4random_uniform(12)) + 1
        let day = Int(arc4random_uniform(28)) + 1
        
        let event = SSEvent()
        event.startDate = SSCalendarUtils.date(withYear: year, month: month, day: day)
        event.startTime = "09:00"
        event.name = "Example Event"
        event.desc = "Details of the event"
        
        return event
    }
}

private extension MainMenuViewController {
    func setup() {
        
        self.title = viewModel?.title()
        self.navigationItem.setHidesBackButton(true, animated: false)
    }
}
