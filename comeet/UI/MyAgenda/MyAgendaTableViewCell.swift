//
//  MyAgendaTableViewCell.swift
//  comeet
//
//  Created by Ricardo Contreras on 4/23/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import UIKit

class MyAgendaTableViewCell: UITableViewCell {

    @IBOutlet weak var meetingSubject: UILabel!
    @IBOutlet weak var meetingTime: UILabel!
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var floorPlanButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
