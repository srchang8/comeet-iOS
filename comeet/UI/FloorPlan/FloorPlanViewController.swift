//
//  FloorPlanViewController.swift
//  comeet
//
//  Created by Ricardo Contreras on 4/26/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import UIKit
import SDWebImage
import ImageScrollView

class FloorPlanViewController: UIViewController {

    @IBOutlet weak var floorPlanImage: UIImageView!
    
    var floorPlanImageURL: URL?
    @IBOutlet weak var imageScrollView: ImageScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        floorPlanImage.sd_setImage(with: floorPlanImageURL, placeholderImage: nil, options: SDWebImageOptions.highPriority) { (image, error, type, url) in
            if let image = image {
                self.imageScrollView.display(image: image)
            }
        }
        
    }
    
    @IBAction func dismiss(sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
