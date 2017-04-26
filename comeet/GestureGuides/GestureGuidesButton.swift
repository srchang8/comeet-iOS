//
//  GestureGuidesButton.swift
//  comeet
//
//  Created by stephen chang on 4/25/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import QuartzCore
import UIKit
class RCHGestureGuideButton: UIButton {
    
    
    //  Converted with Swiftify v1.0.6314 - https://objectivec2swift.com/
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.red
        titleLabel?.font = UIFont.boldSystemFont(ofSize: CGFloat(12.0))
        titleLabel?.textAlignment = .center
        setTitleColor(UIColor.white, for: .normal)
        setTitleColor(UIColor.lightGray, for: .highlighted)
        layer.cornerRadius = 5.0
        clipsToBounds = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        self.translatesAutoresizingMaskIntoConstraints = false
        let a: Any? = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: superview, attribute: .centerX, multiplier: 1, constant: 0)
        let b: Any? = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: superview, attribute: .bottom, multiplier: 1, constant: -64)
        let c: Any? = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: superview, attribute: .width, multiplier: 1, constant: -60)
        let d: Any? = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 44)
        superview?.addConstraints([a as! NSLayoutConstraint, b as! NSLayoutConstraint, c as! NSLayoutConstraint, d as! NSLayoutConstraint])
    }

}
