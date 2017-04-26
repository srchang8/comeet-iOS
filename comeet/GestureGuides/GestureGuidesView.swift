//
//  GestureGuidesView.swift
//  comeet
//
//  Created by stephen chang on 4/25/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit

class RCHGestureGuideView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.userInteractionEnabled = true
        self.backgroundColor = UIColor.clear
        self.alpha = 0
        
    }
    
    func didMoveToSuperview() {
        setTranslatesAutoresizingMaskIntoConstraints(false)
        let a: Any? = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: superview, attribute: .centerX, multiplier: 1, constant: 0)
        let b: Any? = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: superview, attribute: .centerY, multiplier: 1, constant: 0)
        let c: Any? = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: superview, attribute: .width, multiplier: 1, constant: 0)
        let d: Any? = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: superview, attribute: .height, multiplier: 1, constant: 0)
        superview?.addConstraints([a, b, c, d])
    }
    func draw(_ rect: CGRect) {
        let context: CGContext? = UIGraphicsGetCurrentContext()
        switch backdropType {
        case RCHGestureGuideBackdropBlack:
            Set<AnyHashable>()
            context.fill(bounds)
        case RCHGestureGuideBackdropGradient:
            let locationsCount: size_t = 2
            let locations: [CGFloat] = [0.0, 1.0]
            let colors: [CGFloat] = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.8]
            let colorSpace: CGColorSpace? = CGColorSpaceCreateDeviceRGB()
            let gradient: CGGradientRef = CGGradient(colorSpace: colorSpace, colorComponents: colors, locations: locations, count: locationsCount)
            let center = CGPoint(x: CGFloat(bounds.size.width / 2), y: CGFloat(bounds.size.height / 2))
            var radius: Float = min(bounds.size.width * 0.8, bounds.size.height * 0.8)
            if iPad() {
                radius = min(bounds.size.width * 0.7, bounds.size.height * 0.7)
            }
            CGContextDrawRadialGradient(context, gradient, center, 0, center, radius, kCGGradientDrawsAfterEndLocation)
        case RCHGestureGuideBackdropNone:
            break
        }
        
    }
    
    func iPad() -> Bool {
        let model: String = UIDevice.current.model
        if (model == "iPad") {
            return true
        }
        return false
    }
}
