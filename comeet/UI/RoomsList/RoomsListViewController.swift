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
    
    func sliderChange(slider: MARKRangeSlider) {
        startTimelabel.text = "Start \(displayTime(sliderValue: slider.leftValue, start: true))"
        endTimelabel.text = "End \(displayTime(sliderValue: slider.rightValue, start: false))"
    }
    
    func displayTime(sliderValue: CGFloat, start: Bool) -> String {
        var hours = Int(sliderValue / 60)
        if hours >= 24 {
            hours -= 24
        }
        let minutes = Int(sliderValue.truncatingRemainder(dividingBy: 60))
        if start {
            viewModel?.start(hours: hours, minutes: minutes)
        } else {
            viewModel?.end(hours: hours, minutes: minutes)
        }
        let startHoursString = hours > 9 ? "\(hours)" : "0\(hours)"
        let startMinutesString = minutes > 9 ? "\(minutes)" : "0\(minutes)"
        return "\(startHoursString):\(startMinutesString)"
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
        
        sliderView.setMinValue(CGFloat(startValue), maxValue: CGFloat(endValue))
        sliderView.setLeftValue(CGFloat(startValue), rightValue: CGFloat(endAutoSelect))
        sliderView.addTarget(self, action: #selector(sliderChange(slider:)), for: .valueChanged)
        
        sliderChange(slider: sliderView)
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
