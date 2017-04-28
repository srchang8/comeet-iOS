//
//  Constants.swift
//  comeet
//
//  Created by Ricardo Contreras on 4/22/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import Foundation
import UIKit

internal struct UIConstants {
    
    internal struct Colors {
        static let blue = solidColor(r: 123, g: 175, b: 212)
        static let purple = solidColor(r: 204, g: 204, b: 255)
        static let darkGray = solidColor(r: 49, g: 52, b: 62)
    
        static func solidColor(r: Float, g: Float, b: Float) -> UIColor {
            return UIColor(colorLiteralRed: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)
        }
    }
}
