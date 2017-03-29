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
        
      
        
        let monthViewController = SSCalendarMonthlyViewController(events: generateEvents())
        //let weekViewController = SSCalendarDailyViewController(events: generateEvents())
        let navigationController = UINavigationController(rootViewController: monthViewController!)
        
        navigationController.navigationBar.isTranslucent = false
        
        self.present(navigationController, animated: true, completion: nil)
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
        customEvent.name = "Example Meeting"
        customEvent.desc = "Details of the user meeting"
        
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
        event.name = "Example Meeting"
        event.desc = "Details of the meeting"
        
        return event
    }
}

private extension MainMenuViewController {
    func setup() {
        
        self.title = viewModel?.title()
        self.navigationItem.setHidesBackButton(true, animated: false)
    }
}
