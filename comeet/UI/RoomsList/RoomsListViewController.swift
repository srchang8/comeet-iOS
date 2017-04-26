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
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    func newLocation(sender: Any) {
        viewModel?.newLocation(metroarea: Router.selectedMetroarea, roomsList: Router.selectedRoomsList)
        selectLocationButton.setTitle(viewModel?.roomsList?.name, for: .normal)
        
        let userDefault = UserDefaults.standard
        userDefault.set(false, forKey: "isRoomsGuideShown")
        self.guideView.isHidden = false
        let isGuideShown = userDefault.bool(forKey: "isRoomsGuideShown")
        if (!isGuideShown) {
            let when = DispatchTime.now() + 3 // change 2 to desired number of seconds
            DispatchQueue.main.asyncAfter(deadline: when) {
                // Your code with delay
                if ( self.guideView.isHidden == false) {
                    self.guideView.isHidden = true
                }
                userDefault.set(true, forKey: "isRoomsGuideShown")
            }
        } else {
            self.guideView.isHidden = true
        }
        
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
    
    func map(sender: Any) {
        guard let button = sender as? UIButton else {
            return
        }
        
        if let (lat, long) = viewModel?.roomLatLong(index: button.tag) {
            let latitude: CLLocationDegrees = lat
            let longitude: CLLocationDegrees = long
            
            let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
            let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, Constants.regionDistance, Constants.regionDistance)
            let options = [
                MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
                MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
            ]
            let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.name = viewModel?.roomName(index: button.tag)
            mapItem.openInMaps(launchOptions: options)
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
            self?.tableView.reloadData()
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
    
    func setupSlider() {
        let twentyFourHours: Int = 60 * 24 - 1
        
        let hour: Int = Calendar.current.component(.hour, from: Date())
        let minutes: Int = Calendar.current.component(.minute, from: Date())
        let startValue: Int = 0
        let endValue: Int = startValue + twentyFourHours
        let startAutoSelect: Int = (hour * 60) + minutes
        let endAutoSelect: Int = startAutoSelect + 120
        
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
