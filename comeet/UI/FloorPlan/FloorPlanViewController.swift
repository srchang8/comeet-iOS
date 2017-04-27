//
//  FloorPlanViewController.swift
//  comeet
//
//  Created by Ricardo Contreras on 4/26/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import UIKit
import SDWebImage

class FloorPlanViewController: UIViewController {

    @IBOutlet weak var floorPlanImage: UIImageView!
    
    var floorPlanImageURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        floorPlanImage.sd_setImage(with: floorPlanImageURL)
    }
    
    @IBAction func dismiss(sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
