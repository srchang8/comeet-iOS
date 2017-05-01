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

    @IBOutlet weak var imageScrollView: ImageScrollView!
    
    var floorPlanImageURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let floorPlanImageURL = floorPlanImageURL {
            let session = URLSession(configuration: .default)
            
            
            let downloadPicTask = session.dataTask(with: floorPlanImageURL) { (data, response, error) in
             
                if let e = error {
                } else {
                                        if let res = response as? HTTPURLResponse {
                        if let imageData = data {
                            
                            if let image = UIImage(data:  imageData){
                            DispatchQueue.main.async {
                                self.imageScrollView.display(image: image)
                                }
                            }
                            
                        } else {
                            print("Couldn't get image: Image is nil")
                        }
                    } else {
                        print("Couldn't get response code for some reason")
                    }
                }
            }
            
            downloadPicTask.resume()
        }
    }
    
    @IBAction func dismiss(sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
