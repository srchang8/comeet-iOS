//
//  MyAgendaDetailViewController.swift
//  comeet
//
//  Created by Ricardo Contreras on 4/26/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import UIKit

class MyAgendaDetailViewController: BaseViewController {

    var viewModel: MyAgendaDetailViewModel?
    
    @IBOutlet weak var roomPicture: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var attendeesLabel: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setup()
    }

    @IBAction func dismiss(sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func map(sender: Any) {
        if let (lat, long) = viewModel?.roomLatLong() {
            showMapDirections(lat: lat, long: long, name: viewModel?.roomName())
        }
    }
    
    @IBAction func floorPlan(sender: Any) {
        if let floorPlan = viewModel?.roomFloorPlan() {
            Router.floorPlan = floorPlan
            performSegue(withIdentifier: Router.Constants.floorPlanSegue, sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier,
            let viewModel = viewModel else {
                return
        }
        Router.prepare(identifier: identifier, destination: segue.destination, sourceViewModel: viewModel)
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
