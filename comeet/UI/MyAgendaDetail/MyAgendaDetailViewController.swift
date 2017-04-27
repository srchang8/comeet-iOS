//
//  MyAgendaDetailViewController.swift
//  comeet
//
//  Created by Ricardo Contreras on 4/26/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import UIKit
import MapKit

class MyAgendaDetailViewController: UIViewController {

    var viewModel: MyAgendaDetailViewModel?
    
    @IBOutlet weak var roomPicture: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var attendeesLabel: UILabel!
    
    internal struct Constants {
        static let regionDistance:CLLocationDistance = 10000
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setup()
    }

    @IBAction func dismiss(sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func map(sender: Any) {
        if let (lat, long) = viewModel?.roomLatLong() {
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
            mapItem.name = viewModel?.roomName()
            mapItem.openInMaps(launchOptions: options)
        }
    }
    
    @IBAction func floorPlan(sender: Any) {
        
    }
    
    @IBAction func sendAttendeesMail(sender: Any) {
        
    }
}

private extension MyAgendaDetailViewController {
    
    func setup() {
        guard let viewModel = viewModel else {
            return
        }
        
        viewModel.reloadBinding = { [weak self] in
            self?.reloadData()
        }
        viewModel.fetchMeetingData()
    }
    
    func reloadData() {
        roomPicture.sd_setImage(with: viewModel?.roomPicture())
        titleLabel.text = viewModel?.titleText()
        detailLabel.text = viewModel?.detailText()
        timeLabel.text = viewModel?.timeText()
        attendeesLabel.text = viewModel?.attendeesText()
    }
}
