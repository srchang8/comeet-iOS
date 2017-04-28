//
//  RoomTableViewCell.swift
//  comeet
//
//  Created by Ricardo Contreras on 4/15/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import UIKit

class RoomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var roomImage: UIImageView!
    @IBOutlet weak var roomName: UILabel!
    @IBOutlet weak var roomCapacity: UILabel!
    @IBOutlet weak var bookButton: UIButton!
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var floorPlanButton: UIButton!

    @IBOutlet weak var amenityImageView1: UIImageView!
    @IBOutlet weak var amenityImageView2: UIImageView!
    @IBOutlet weak var amenityImageView3: UIImageView!
    @IBOutlet weak var amenityImageView4: UIImageView!
    
    var amenityImageViews = [UIImageView]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        amenityImageViews = [amenityImageView1, amenityImageView2, amenityImageView3, amenityImageView4]
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
