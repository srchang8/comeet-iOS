//
//  RoomsListViewController.swift
//  comeet
//
//  Created by Ricardo Contreras on 3/6/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import UIKit
import SDWebImage
import DateTimePicker

class RoomsListViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var viewModel: RoomsListViewModel?
    internal struct Constants {
        static let roomCellIdentifier = "RoomCell"
        static let placeholderImage = "RoomsListPlaceholder"
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
}

private extension RoomsListViewController {
    
    func setup() {
        
        title = viewModel?.title()
        
        viewModel?.reloadBinding = { [weak self] (rooms) in
            self?.tableView.reloadData()
        }
        viewModel?.fetchRooms()
    }
    
    func showPicker() {
        let now = Date()
        let maxInterval = viewModel?.maxTimeInterval() ?? 0
        let nextYear = Date().addingTimeInterval(maxInterval)
        let picker = DateTimePicker.show(selected: now, minimumDate: now, maximumDate: nextYear)
        picker.highlightColor = .blue
        picker.doneButtonTitle = "Show Rooms"
        picker.todayButtonTitle = "Today"
        picker.completionHandler = { [weak self] date in
            self?.viewModel?.selected(date: date)
        }
    }
}

extension RoomsListViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.roomsCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.roomCellIdentifier, for: indexPath)
        cell.textLabel?.text = viewModel?.roomName(index: indexPath.row)
        cell.detailTextLabel?.text = viewModel?.roomDescription(index: indexPath.row)
        cell.imageView?.contentMode = .scaleAspectFill
        cell.imageView?.clipsToBounds = true
        if let roomPicture = viewModel?.roomPicture(index: indexPath.row) {
            cell.imageView?.sd_setImage(with: roomPicture, placeholderImage: UIImage(named: Constants.placeholderImage))
        } else {
            cell.imageView?.image = nil
        }
        
        return cell
    }
}

extension RoomsListViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        showPicker()
        if let room = viewModel?.room(index: indexPath.row) {
            Router.selectedRoom = room
//            performSegue(withIdentifier: Router.Constants.roomDetailSegue, sender: self)
        }
    }
}
