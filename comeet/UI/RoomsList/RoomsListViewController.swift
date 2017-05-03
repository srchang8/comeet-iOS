//
//  RoomsListViewController.swift
//  comeet
//
//  Created by Ricardo Contreras on 3/6/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage
import MARKRangeSlider
import MapKit

class RoomsListViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sliderView: MARKRangeSlider!
    @IBOutlet weak var startTimelabel: UILabel!
    @IBOutlet weak var endTimelabel: UILabel!
    @IBOutlet weak var selectLocationButton: UIButton!
    @IBOutlet weak var guideView: UIView!
    
   
    var viewModel: RoomsListViewModel?
    internal struct Constants {
        static let roomCellIdentifier = "RoomCell"
        static let placeholderImage = "RoomsListPlaceholder"
        static let selectDateText = "Done"
        static let regionDistance:CLLocationDistance = 10000
        static let roomsListNewLocationNotification = "RoomsListNewLocation"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setup()
    }
    
    @IBAction func goToMetro(_ sender: Any) {
        performSegue(withIdentifier: Router.Constants.metroareaSegue, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier,
            let viewModel = viewModel else {
                return
        }
        
        if segue.identifier == Router.Constants.metroareaSegue {
            prepareForPopUp(controller: segue.destination)
        }
        
        Router.prepare(identifier: identifier, destination: segue.destination, sourceViewModel: viewModel)
    }
    
    func sliderChange(slider: MARKRangeSlider) {
        
        guard let start = viewModel?.startTime(value: slider.leftValue),
            let end = viewModel?.endTime(value: slider.rightValue) else {
                return
        }
        
        startTimelabel.text = "Start " + start
        endTimelabel.text = "End " + end
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    func reloadRooms() {
        viewModel?.fetchRooms()
    }
    
    func newLocation(sender: Any) {
        viewModel?.newLocation(metroarea: Router.selectedMetroarea, roomsList: Router.selectedRoomsList)
        selectLocationButton.setTitle(viewModel?.roomsList?.name, for: .normal)
    }
    
    func book(sender: Any) {
        guard let button = sender as? UIButton else {
            return
        }
        
        if let room = viewModel?.room(index: button.tag) {
            Router.selectedRoom = room
            performSegue(withIdentifier: Router.Constants.roomDetailSegue, sender: nil)
        }
    }
    
    func floorPlan(sender: Any) {
        guard let button = sender as? UIButton else {
            return
        }
        
        if let floorPlan = viewModel?.roomFloorPlan(index: button.tag) {
            Router.floorPlan = floorPlan
            performSegue(withIdentifier: Router.Constants.floorPlanSegue, sender: nil)
        }
    }
    
    func map(sender: Any) {
        guard let button = sender as? UIButton else {
            return
        }
        
        if let (lat, long) = viewModel?.roomLatLong(index: button.tag) {
            showMapDirections(lat: lat, long: long, name: viewModel?.roomName(index: button.tag))
        }
    }
    
    func change(date: Date) {
        viewModel?.change(date: date)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

private extension RoomsListViewController {
    
    func setup() {
        
        guard let viewModel = viewModel else {
            return
        }
        
        
        title = viewModel.title()
        
        viewModel.reloadBinding = { [weak self] in
            self?.showSwipeGuide()
            self?.tableView.reloadSections([0], with: UITableViewRowAnimation.fade)
        }
        viewModel.fetchRooms()
        
        setupSlider()
        
        NotificationCenter.default.addObserver(self, selector: #selector (newLocation(sender:)), name: NSNotification.Name(rawValue: Constants.roomsListNewLocationNotification), object: nil)
        
        if (viewModel.locationPersisted()) {
            selectLocationButton.setTitle(viewModel.roomsList?.name, for: .normal)
        } else {
            performSegue(withIdentifier: Router.Constants.metroareaSegue, sender: self)
        }
    }
    
    func showSwipeGuide() {
        guideView.isHidden = true
        guard let showGuide = viewModel?.showSwipeGuide(), showGuide == true else {
            return
        }
        showTemporarily(view: guideView)
    }
    
    func setupSlider() {
        let twentyFourHours: Int = 60 * 24 - 1
        
        let hour: Int = Calendar.current.component(.hour, from: Date())
        let minutes: Int = Calendar.current.component(.minute, from: Date())
        let startValue: Int = 0
        let endValue: Int = startValue + twentyFourHours
        let startAutoSelect: Int = (hour * 60) + minutes
        let endAutoSelect: Int = startAutoSelect + 60
        
        sliderView.setMinValue(CGFloat(startValue), maxValue: CGFloat(endValue))
        sliderView.setLeftValue(CGFloat(startAutoSelect), rightValue: CGFloat(endAutoSelect))
        sliderView.addTarget(self, action: #selector(sliderChange(slider:)), for: .valueChanged)
        
        sliderChange(slider: sliderView)
    }
    
    func prepareForPopUp(controller: UIViewController) {
        controller.modalPresentationStyle = UIModalPresentationStyle.popover
        controller.popoverPresentationController?.delegate = self
        controller.popoverPresentationController?.sourceRect = CGRect(x: 0, y: 0, width: selectLocationButton.bounds.width, height: selectLocationButton.bounds.height)
    }
}

extension RoomsListViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.roomsCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.roomCellIdentifier, for: indexPath)
        
        guard let roomCell = cell as? RoomTableViewCell else {
            return cell
        }
        
        roomCell.bookButton.tag = indexPath.row
        roomCell.mapButton.tag = indexPath.row
        roomCell.floorPlanButton.tag = indexPath.row
        roomCell.roomName.text = viewModel?.roomName(index: indexPath.row)
        roomCell.roomCapacity.text = viewModel?.roomDescription(index: indexPath.row)
        roomCell.bookButton.addTarget(self, action: #selector(book(sender:)), for: .touchUpInside)
        
        if let roomPicture = viewModel?.roomPicture(index: indexPath.row) {
            roomCell.roomImage.sd_setImage(with: roomPicture)
        } else {
            roomCell.roomImage.image = nil
        }
        
        if viewModel?.roomLatLong(index: indexPath.row) == nil {
            roomCell.mapButton.isHidden = true
        } else {
            roomCell.mapButton.isHidden = false
            roomCell.mapButton.addTarget(self, action: #selector(map(sender:)), for: .touchUpInside)
        }
        
        if viewModel?.roomFloorPlan(index: indexPath.row) == nil {
            roomCell.floorPlanButton.isHidden = true
        } else {
            roomCell.floorPlanButton.isHidden = false
            roomCell.floorPlanButton.addTarget(self, action: #selector(floorPlan(sender:)), for: .touchUpInside)
        }
        
        let amenities = viewModel?.roomAmenities(index: indexPath.row) ?? []
        //clear images first
        for imageView in roomCell.amenityImageViews {
            imageView.image = nil
        }

        //fill amenity image views
        var i = 0
        for amenity in amenities {
            roomCell.amenityImageViews[i].image = UIImage(named: amenity.name)
            i += 1
        }
        
        return cell
    }
}

extension RoomsListViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

extension RoomsListViewController : UIPopoverPresentationControllerDelegate {

}
