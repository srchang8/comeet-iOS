//
//  MainContentPageViewController.swift
//  comeet
//
//  Created by Kevin Burek on 4/29/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import Foundation

import UIKit

class MainContentPageViewController : UIPageViewController {
    
    var orderedChildViewControllers: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        
        if let firstViewController = self.orderedChildViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
    }
    
    func setChildViewControllers(_ orderedChildViewControllers: [UIViewController]) {
        self.orderedChildViewControllers = orderedChildViewControllers
    }
}

extension MainContentPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedChildViewControllers.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard orderedChildViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedChildViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedChildViewControllers.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedChildViewControllers.count
        
        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedChildViewControllers[nextIndex]
    }
}
