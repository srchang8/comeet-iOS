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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.meetingsCount() ?? 0;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.agendaCellIdentifier, for: indexPath)
        
        guard let agendaCell = cell as? MyAgendaTableViewCell else {
            return cell
        }

        agendaCell.meetingSubject.text = viewModel?.meetingSubject(index: indexPath.row)
        agendaCell.meetingTime.text = viewModel?.meetingTime(index: indexPath.row)
//        agendaCell.meetingRoom.text = viewModel?.meetingRoom(index: indexPath.row)
        
        return agendaCell
    }
}

extension MyAgendaViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: Go to meeting detail
    }
}
