//
//  BaseViewController.swift
//  comeet
//
//  Created by Ricardo Contreras on 3/25/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import UIKit
import MapKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func showMapDirections(lat: Double, long: Double, name: String?) {
        
        let latitude: CLLocationDegrees = lat
        let longitude: CLLocationDegrees = long
        
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, 10000, 10000)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = name
        mapItem.openInMaps(launchOptions: options)
    }
    
    func showTemporarily(view: UIView) {
        view.isHidden = false
        view.alpha = 1.0
        UIView.animate(withDuration: 0.5, delay: 3.0, options: [], animations: {
            view.alpha = 0.0
        }) { (completion: Bool) in
            if completion {
                view.isHidden = true
            }
        }
    }
}
