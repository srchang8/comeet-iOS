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

    @IBOutlet weak var roomPicture: UIImageView!
    @IBOutlet weak var roomName: UILabel!
    @IBOutlet weak var roomAddress: UILabel!
    @IBOutlet weak var roomAmenities: UILabel!
    @IBOutlet weak var bookButton: UIButton!
    var viewModel: RoomDetailViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    @IBAction func book (_ sender: Any) {
        viewModel?.bookRoom()
    }
}

private extension RoomDetailViewController {
    
    func setup() {
        title = viewModel?.title()
        roomPicture.sd_setImage(with: viewModel?.roomPicture())
        roomName.text = viewModel?.roomname()
        roomAddress.text = viewModel?.roomAddress()
        roomAmenities.text = viewModel?.roomAmenities()
        bookButton.setTitle(viewModel?.roomBookText(), for: .normal)
        
        viewModel?.bookRoomBinding = { [weak self] (success: Bool) in
            if (success) {
                self?.goBackToMenu()
            }
        }
    }
    
    func goBackToMenu() {
        guard let viewControllers = navigationController?.viewControllers else {
            return
        }
        for controller in viewControllers {
            if controller is MainMenuViewController {
                _ = navigationController?.popToViewController(controller, animated: true)
            }
        }
    }
}
