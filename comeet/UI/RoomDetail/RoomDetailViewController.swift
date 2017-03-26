//
//  RoomDetailViewController.swift
//  comeet
//
//  Created by Ricardo Contreras on 3/6/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import UIKit
import SDWebImage

class RoomDetailViewController: BaseViewController {

    @IBOutlet weak var roomName: UILabel!
    @IBOutlet weak var roomPicture: UIImageView!
    var viewModel: RoomDetailViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

private extension RoomDetailViewController {
    
    func setup() {
        title = viewModel?.title()
        roomName.text = viewModel?.roomname()
        roomPicture.sd_setImage(with: viewModel?.roomPicture())
    }
}
