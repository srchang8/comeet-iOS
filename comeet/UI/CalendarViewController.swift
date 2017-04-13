//
//  CalendarPopUpCollectionViewController.swift
//  comeet
//
//  Created by stephen chang on 4/13/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import UIKit


class CalendarViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)

      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //close calendar pop up
    @IBAction func done(_ sender: UIButton) {
        self.view.removeFromSuperview()
    }
    

}
