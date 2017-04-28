//
//  LoaderALLoadingViewImplementer.swift
//  comeet
//
//  Created by Ricardo Contreras on 4/22/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import Foundation
import ALLoadingView

class LoaderALLoadingViewImplementer: LoaderProtocol {
    
    func show(text: String) {
        guard !ALLoadingView.manager.isPresented else {
            return
        }
        
        ALLoadingView.manager.showLoadingView(ofType: .messageWithIndicator, windowMode: .windowed, completionBlock: nil)
        ALLoadingView.manager.messageText = text
        ALLoadingView.manager.messageFont = UIFont.systemFont(ofSize: 15)
        ALLoadingView.manager.blurredBackground = true
        ALLoadingView.manager.backgroundColor = UIConstants.Colors.darkGray
    }
    
    func hide() {
        ALLoadingView.manager.hideLoadingView()
    }
}
