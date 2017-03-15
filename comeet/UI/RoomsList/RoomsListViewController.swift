//
//  RoomsListViewController.swift
//  comeet
//
//  Created by Ricardo Contreras on 3/6/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import UIKit

class RoomsListViewController: UIViewController {
    
    @IBOutlet weak var table: UITableView!

    var viewModel: RoomsListViewModel?
    
    internal struct Constants {
        static let roomCellIdentifier = "RoomCell"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

private extension RoomsListViewController {
    
    func setup() {
        
        title = "Book a Room"
        
        viewModel?.roomsBinding = { [weak self] (rooms) in
            self?.table.reloadData()
        }
        viewModel?.fetchRooms()
    }
}

extension RoomsListViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.roomsCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: Constants.roomCellIdentifier, for: indexPath)
        cell.textLabel?.text = viewModel?.roomName(index: indexPath.row)
        cell.detailTextLabel?.text = viewModel?.roomDescription(index: indexPath.row)
        return cell
    }
}

extension RoomsListViewController : UITableViewDelegate {
    
}
