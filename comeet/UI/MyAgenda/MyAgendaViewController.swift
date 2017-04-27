//
//  MyAgendaViewController.swift
//  comeet
//
//  Created by stephen chang on 3/28/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//


import UIKit

class MyAgendaViewController: BaseViewController {
    
    var viewModel: MyAgendaViewModel?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var guideView: UIView!
    
    internal struct Constants {
        static let agendaCellIdentifier = "AgendaCell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier,
            let viewModel = viewModel else {
                return
        }
        Router.prepare(identifier: identifier, destination: segue.destination, sourceViewModel: viewModel)
    }
    
    func change(date: Date) {
        viewModel?.change(date: date)
    }
}

private extension MyAgendaViewController {
    
    func setup() {
        guard let viewModel = viewModel else {
            return
        }
        
        viewModel.reloadBinding = { [weak self] in
            self?.tableView.reloadData()
        }
        viewModel.fetchMeetings()
        
        
    }
}

extension MyAgendaViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.sectionsCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.meetingsCount(section: section) ?? 0;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.agendaCellIdentifier, for: indexPath)
        
        guard let agendaCell = cell as? MyAgendaTableViewCell else {
            return cell
        }

        agendaCell.meetingSubject.text = viewModel?.meetingSubject(section: indexPath.section, index: indexPath.row)
        agendaCell.meetingTime.text = viewModel?.meetingTime(section: indexPath.section, index: indexPath.row)
        
        return agendaCell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel?.sectionTitle(section: section)
    }
}

extension MyAgendaViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let meeting = viewModel?.meeting(section: indexPath.section, index: indexPath.row) {
            Router.selectedMeeting = meeting
            performSegue(withIdentifier: Router.Constants.agendaDetailSegue, sender: nil)
        }
    }
}
