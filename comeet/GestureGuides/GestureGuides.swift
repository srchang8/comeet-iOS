//
//  GestureGuides.swift
//  comeet
//
//  Created by stephen chang on 4/25/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import Foundation

let RCH_SCREEN_ANIMATION_DELAY = 0.15
let RCH_GESTURE_ON_SCREEN = 1.25
let RCH_GESTURE_ANIMATION_DURATION_FADE_IN = 0.3
let RCH_GESTURE_ANIMATION_DURATION_FADE_OUT = 0.2
let RCHGestureGuideDefaults: String = "RCHGestureGuideDefaults"
let RCHGesturePinch: String = "RCHGesturePinch"
let RCHGestureSwipe: String = "RCHGestureSwipe"
let RCHGestureSpread: String = "RCHGestureSpread"
let RCHGestureTap: String = "RCHGestureTap"
let RCHGestureRotate: String = "RCHGestureRotate"


class RCHGestureGuide: NSObject {
    var dismissButtonTitle: String = ""
    var screenAnimationDelayDuration: CGFloat = 0.0
    var gestureOnScreenDuration: CGFloat = 0.0
    var gestureAnimationDurationIn: CGFloat = 0.0
    var gestureAnimationDurationOut: CGFloat = 0.0
    
    private var isPresenting: Bool = false
    private var shouldCancelPresenting: Bool = false
    private var shouldRestart: Bool = false
    private var backdropType = RCHGestureGuideBackdropType()
    private var orientation = UIDeviceOrientation(rawValue: 0)!
    
    var view: UIView?
    var applicationTopMostView: UIView?
    var overlayWindow: UIWindow?
    var stopButton: UIButton?
    var interfaceKey: String = ""
    var requestedGestures = [Any]()
    var animations = [Any]()
    var currentGestureView: UIImageView?
    
    /**
     Show the gesture guides on screen one by one if they are enabled for the key passed.
     @param gestures An array of the available string constants representing types of gesture, eg. @[RCHGesturePinch, RCHGestureTap]
     @param key This should be a unique key for the name of the interface eg. @"ProductViewController"
     */
    class func showGestures(_ gestures: [Any], forKey key: String) {
    }
    
    /**
     Resets all gestures so they will all be shown again until the user dismisses them, by pressing the stop showing button.
     */
    class func reset() {
    }
    
    class func shared() -> RCHGestureGuide {
        var once: Int
        var shared: RCHGestureGuide?
        if (once == 0) {
            /* TODO: move below code to a static variable initializer (dispatch_once is deprecated) */
            shared = RCHGestureGuide()
        }
        once = 1
        return shared!
    }
    
    class func showGestures(_ gestures: [Any], forKey key: String) {
        RCHGestureGuide.shared().show(withGestures: gestures, forInterfaceKey: key)
    }
    
    class func reset() {
        RCHGestureGuide.shared().reset()
    }
    
    func restart() {
        shouldRestart = true
        cancel()
    }
    
    func willRestart() {
        shouldRestart = false
        show(with: requestedGestures, for: interfaceKey)
    }
    
    // MARK: - Instance Methods
    override init() {
        super.init()
        
        defaults()
        notifications()
        
    }
    
    //  The converted code is limited by 2 KB.
    //  Upgrade your plan to remove this limitation.
    
    //  Converted with Swiftify v1.0.6314 - https://objectivec2swift.com/
    func defaults() {
        backdropType = RCHGestureGuideBackdropGradient
        shouldCancelPresenting = false
        isPresenting = false
        dismissButtonTitle = "Stop showing these gestures"
        screenAnimationDelayDuration = RCH_SCREEN_ANIMATION_DELAY
        gestureOnScreenDuration = RCH_GESTURE_ON_SCREEN
        gestureAnimationDurationIn = RCH_GESTURE_ANIMATION_DURATION_FADE_IN
        gestureAnimationDurationOut = RCH_GESTURE_ANIMATION_DURATION_FADE_OUT
    }
    
    // MARK: - Notifications
    func notifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.orientationDidChange), name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
    
    func orientationDidChange(_ notification: Notification) {
        let newOrientation: UIDeviceOrientation = UIDevice.current.orientation
        switch newOrientation {
        case .unknown, .faceDown, .faceUp:
            break
        default:
            if orientation != newOrientation {
                orientation = newOrientation
                restart()
            }
        }
        
    }
    
    // MARK: - Getters
    func applicationTopMostView() -> UIView? {
        if applicationTopMostView != nil {
            return applicationTopMostView
        }
        let window: UIWindow? = UIApplication.shared.keyWindow
        let viewController: UIViewController? = window?.rootViewController
        applicationTopMostView() = viewController?.view
        return applicationTopMostView
    }
    
    func view() -> UIView? {
        if view != nil {
            return view
        }
        view = RCHGestureGuideView()
        return view
    }
    
    // MARK: - Actions
    func reset() {
        UserDefaults.standard.removeObject(forKey: RCHGestureGuideDefaults)
        UserDefaults.standard.synchronize()
    }
    
    func cancel() {
        if !isPresenting {
            return
        }
        shouldCancelPresenting = true
        view.layer().removeAllAnimations()
        view.removeFromSuperview()
        currentGestureView.layer().removeAllAnimations()
        if !shouldRestart {
            interfaceKey = nil
            requestedGestures = nil
        }
    }
    
    //  Converted with Swiftify v1.0.6314 - https://objectivec2swift.com/
    func cancelDidComplete() {
        shouldCancelPresenting = false
        isPresenting = false
        if shouldRestart {
            willRestart()
        }
    }
    
    func dismiss() {
        view.removeFromSuperview()
        view = nil
        applicationTopMostView = nil
        stopButton = nil
        animations = nil
    }
    
    func show(withGestures gestures: [Any], forInterfaceKey key: String) {
        if gestures == nil {
            return
        }
        if isPresenting {
            return
        }
        if !shouldShowGestures(forKey: key) {
            return
        }
        interfaceKey = key
        requestedGestures = gestures
        isPresenting = true
        DispatchQueue.main.async(execute: {() -> Void in
            if !view.superview {
                applicationTopMostView.addSubview(view)
            }
            applicationTopMostView.isHidden = false
            stopButton.isHidden = false
            if view.alpha != 1 {
                UIView.animate(withDuration: screenAnimationDelayDuration, delay: 0, options: [.allowUserInteraction, .easeOut, .beginFromCurrentState], animations: {() -> Void in
                    view.alpha = 1
                }, completion: {(_ finished: Bool) -> Void in
                    self.animate(requestedGestures)
                })
            }
            view.setNeedsDisplay()
        })
    }
    
    //  Converted with Swiftify v1.0.6314 - https://objectivec2swift.com/
    // MARK: - Animate Gestures
    func animateGestures(_ gestures: [Any]) {
        if gestures != nil {
            animations = [Any](arrayLiteral: gestures)
        }
        let count: Int = animations.count
        if count > 0 {
            let key: String? = (animations[0] as? String)
            showGesture(forKey: key, withCompletion: {(_ finished: Bool) -> Void in
                if !shouldCancelPresenting {
                    animations.remove(at: 0)
                    self.animateGestures(nil)
                }
                else {
                    self.performSelector(#selector(self.dismiss), withObject: nil, afterDelay: 0.0)
                    self.cancelDidComplete()
                }
            })
            return
        }
        performSelector(#selector(self.dismiss), withObject: nil, afterDelay: 0.0)
        cancelDidComplete()
    }
    
    func showGesture(forKey key: String, withCompletion completion: @escaping (_ finished: Bool) -> Void) {
        DispatchQueue.main.async(execute: {() -> Void in
            let image = UIImage(named: "\(key).png")
            currentGestureView = UIImageView(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(image?.size?.width), height: CGFloat(image?.size?.height)))
            currentGestureView.image = image
            currentGestureView.center = view.center
            currentGestureView.layer().opacity = 0.0
            view.addSubview(currentGestureView)
            UIView.animate(withDuration: gestureAnimationDurationIn, delay: 0.0, options: [.easeOut, .beginFromCurrentState], animations: {() -> Void in
                currentGestureView.layer().opacity = 1.0
            }, completion: {(_ finished: Bool) -> Void in
                UIView.animate(withDuration: gestureAnimationDurationOut, delay: gestureOnScreenDuration, options: [.easeOut, .beginFromCurrentState], animations: {() -> Void in
                    currentGestureView.layer().opacity = 0.0
                }, completion: {(_ finished: Bool) -> Void in
                    completion(true)
                })
            })
        })
    }
    
    //  Converted with Swiftify v1.0.6314 - https://objectivec2swift.com/
    // MARK: - Getters
    func stopButton() -> UIButton {
        if stopButton != nil {
            return stopButton
        }
        stopButton() = RCHGestureGuideButton()
        stopButton.addTarget(self, action: #selector(self.stopAction), for: .touchUpInside)
        stopButton.setTitle(dismissButtonTitle, for: .normal)
        view.addSubview(stopButton)
        return stopButton
    }
    
    func shouldShowGestures(forKey key: String) -> Bool {
        var settings: [AnyHashable: Any]? = UserDefaults.standard.object(forKey: RCHGestureGuideDefaults)
        if settings == nil {
            return true
        }
        let setting = (settings?[key] as? NSNumber)
        if setting != nil {
            if setting != nil == false {
                return false
            }
        }
        return true
    }
    
    // MARK: - Actions
    func stopAction(_ sender: Any) {
        var savedSettings: [AnyHashable: Any]? = UserDefaults.standard.object(forKey: RCHGestureGuideDefaults)
        if savedSettings == nil {
            savedSettings = [AnyHashable: Any](minimumCapacity: 0)
        }
        var settings: [AnyHashable: Any]? = savedSettings?
        settings?[interfaceKey] = Int(false)
        UserDefaults.standard.set(settings, forKey: RCHGestureGuideDefaults)
        UserDefaults.standard.synchronize()
        cancel()
    }




}
