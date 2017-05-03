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
    @IBOutlet weak var roomBookTime: UILabel!
    @IBOutlet weak var subjectInput: UITextField!
    @IBOutlet weak var bodyInput: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var viewModel: RoomDetailViewModel?
    internal struct Constants {
        static let roomsBookedNotification = "RoomsBooked"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    @IBAction func book (_ sender: Any) {
        guard let subjectText = subjectInput.text, !subjectText.isEmpty else {
            subjectInput.backgroundColor = UIConstants.Colors.red
            return
        }
        
        view.endEditing(true)
        viewModel?.bookRoom(subject: subjectText, body: bodyInput.text)
    }
    
    @IBAction func cancel(_ sender: Any) {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func map(sender: Any) {
        if let (lat, long) = viewModel?.roomLatLong() {
            showMapDirections(lat: lat, long: long, name: viewModel?.roomname())
        }
    }
    
    @IBAction func floorPlan(sender: Any) {
        if let floorPlan = viewModel?.roomFloorPlan() {
            Router.floorPlan = floorPlan
            performSegue(withIdentifier: Router.Constants.floorPlanSegue, sender: nil)
        }
    }
    
    func keyboardWillShow(notification:NSNotification){
        //give room at the bottom of the scroll view, so it doesn't cover up anything the user needs to tap
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        scrollView.contentInset = contentInset
    }
    
    func keyboardWillHide(notification:NSNotification){
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier,
            let viewModel = viewModel else {
                return
        }
        Router.prepare(identifier: identifier, destination: segue.destination, sourceViewModel: viewModel)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

private extension RoomDetailViewController {
    
    func setup() {

        roomPicture.sd_setImage(with: viewModel?.roomPicture())
        roomName.text = viewModel?.roomname()
        roomBookTime.text = viewModel?.roomBookText()
        
        viewModel?.bookRoomBinding = { [weak self] (success: Bool) in
            if (success) {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.roomsBookedNotification), object: nil)
                self?.goBackToMenu()
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)

    }
    
    func goBackToMenu() {
        dismiss(animated: true, completion: nil)
    }
}
