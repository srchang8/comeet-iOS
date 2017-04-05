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
//        super.init(events: MainMenuViewController.generateEvents())
        super.init(coder: coder)!
        self.addEvents(MainMenuViewController.generateEvents())
        self.day = SSDayNode(value: 5, month: 4, year: 2017, weekday: 0)
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
    
    //MARK: - SSCalendar setup
    static func generateEvents() -> [SSEvent] {
        var events: [SSEvent] = []
        for year in 2016...2021 {
            for _ in 1...100 {
                events.append(generateEvent(year));
            }
        }
        return events
    }
    
    static func generateEvent(_ year: Int) -> SSEvent {
        let month = Int(arc4random_uniform(12)) + 1
        let day = Int(arc4random_uniform(28)) + 1
        
        let event = SSEvent()
        event.startDate = SSCalendarUtils.date(withYear: year, month: month, day: day)
        event.startTime = "09:00"
        event.name = "Let's get together to discuss the architecture of the project."
        
        return event
    }
}

private extension MainMenuViewController {
    func setup() {
        
        self.title = viewModel?.title()
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        self.dateChanged = { [weak self] (date: Date?) in
            if let date = date {
                self?.viewModel?.selectedDate = date
            }
        }
    }
}
