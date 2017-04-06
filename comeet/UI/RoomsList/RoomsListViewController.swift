//
//  RoomsListViewController.swift
//  comeet
//
//  Created by Ricardo Contreras on 3/6/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import UIKit
import SDWebImage
import MARKRangeSlider

class RoomsListViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sliderView: MARKRangeSlider!
    @IBOutlet weak var startTimelabel: UILabel!
    @IBOutlet weak var endTimelabel: UILabel!
    
    var viewModel: RoomsListViewModel?
    internal struct Constants {
        static let roomCellIdentifier = "RoomCell"
        static let placeholderImage = "RoomsListPlaceholder"
        static let selectDateText = "Done"
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
    
    func startDateChanged(sender: UIDatePicker) {
        viewModel?.start(date: sender.date)
    }
    
    func endDateChanged(sender: UIDatePicker) {
        viewModel?.end(date: sender.date)
    }
    
    func sliderChange(slider: MARKRangeSlider) {
        changeTime(label: startTimelabel, sliderValue: slider.leftValue, displayText: "Start")
        changeTime(label: endTimelabel, sliderValue: slider.rightValue, displayText: "End")
    }
    
    func changeTime(label: UILabel, sliderValue: CGFloat, displayText: String) {
        let startHours = Int(sliderValue / 60)
        let startMinutes = Int(sliderValue.truncatingRemainder(dividingBy: 60))
        let startHoursString = startHours > 9 ? "\(startHours)" : "0\(startHours)"
        let startMinutesString = startMinutes > 9 ? "\(startMinutes)" : "0\(startMinutes)"
        label.text = "\(displayText) \(startHoursString):\(startMinutesString)"
    }
}

private extension RoomsListViewController {
    
    func setup() {
        
        title = viewModel?.title()
        
        viewModel?.reloadBinding = { [weak self] (rooms) in
            self?.tableView.reloadData()
        }
        viewModel?.fetchRooms()
        
        let tenHours: Int = 60 * 10
        
        let hour: Int = Calendar.current.component(.hour, from: Date())
        let minute: Int = Calendar.current.component(.minute, from: Date())
        let startValue: Int = (hour * 60) + minute
        let endValue: Int = startValue + tenHours
        let endAutoSelect: Int = startValue + 120
        
        changeTime(label: startTimelabel, sliderValue: CGFloat(startValue), displayText: "Start")
        changeTime(label: endTimelabel, sliderValue: CGFloat(endAutoSelect), displayText: "End")
        
        sliderView.setMinValue(CGFloat(startValue), maxValue: CGFloat(endValue))
        sliderView.setLeftValue(CGFloat(startValue), rightValue: CGFloat(endAutoSelect))
        sliderView.addTarget(self, action: #selector(sliderChange(slider:)), for: .valueChanged)
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
        
        

        cell.imageView?.contentMode = .scaleAspectFit
        //cell.imageView?.contentMode = UIViewContentMode.scaleAspectFill
        cell.imageView?.clipsToBounds = true
        
        if let roomPicture = viewModel?.roomPicture(index: indexPath.row) {
            cell.imageView?.sd_setImage(with: roomPicture, placeholderImage: UIImage(named: Constants.placeholderImage))
        } else {
            cell.imageView?.image = nil 
        }

        //NSLog("%@",cell)
        //NSLog("%@",cell.subviews)
        //NSLog("%@",cell.imageView)
        return cell
    }
}

extension RoomsListViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let room = viewModel?.room(index: indexPath.row) {
            Router.selectedRoom = room
            performSegue(withIdentifier: Router.Constants.roomDetailSegue, sender: self)
        }
    }
}
