//
//  MyAgendaViewController.swift
//  comeet
//
//  Created by stephen chang on 3/28/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//


import UIKit

class MyAgendaViewController: BaseViewController {
    
    var viewModel: MainMenuViewModel?
    
    @IBOutlet weak var tableView: UITableView!
    
    var rows = -1
    var meetingLabels = [String]()
    
    func reloadMeetingData()->Bool{
        
        if (viewModel?.meetings) != nil {
            
            if let meetings = viewModel?.meetings{
                
                meetingLabels = [String]()
                
                for meeting in meetings{
                    meetingLabels.append((meeting.start?.displayString())! + " " + meeting.subject!)
                    
                }
                
                tableView.reloadData()
                return true
                
            }
        }
        
        return false
        
    }
    
    var selectedDate: Date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel?.fetchMeetings()
        
        tableView.delegate = self;
        tableView.dataSource = self;
        
        //tableView.reloadData()
        
        print("INPUT DATE" + selectedDate.displayString())
        
    }
    @IBAction func reloadTableData(_ sender: Any) {
        reloadMeetingData()
    }

}

extension MyAgendaViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meetingLabels.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuse", for: indexPath)
        
        cell.textLabel?.text = meetingLabels[indexPath.row]
        
        return cell
    }
}

extension MyAgendaViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //tableView.reloadData()
        
    }
}
