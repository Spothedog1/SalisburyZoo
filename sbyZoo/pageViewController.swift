//
//  pageViewController.swift
//  sbyZoo
//
//  Created by Ron Basumallik on 4/19/17.
//  Copyright © 2017 RonCorp. All rights reserved.
//

import Foundation
import UIKit

class pageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    let pages = ["pageOneController", "pageTwoController", "pageThreeController"]
    
    override func viewDidAppear(_ animated: Bool) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "pageOneController")
        setViewControllers([vc!], // Has to be a single item array, unless you're doing double sided stuff I believe
            direction: .forward,
            animated: true,
            completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let identifier = viewController.restorationIdentifier {
            if let index = pages.index(of: identifier) {
                if index > 0 {
                    return self.storyboard?.instantiateViewController(withIdentifier: pages[index-1])
                }
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let identifier = viewController.restorationIdentifier {
            if let index = pages.index(of: identifier) {
                if index < pages.count - 1 {
                    return self.storyboard?.instantiateViewController(withIdentifier: pages[index+1])
                }
            }
        }
        return nil
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pages.count
 
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        if let identifier = viewControllers?.first?.restorationIdentifier {
            if let index = pages.index(of: identifier) {
                return index
            }
        }
        return 0
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        for view in self.view.subviews {
            if view is UIScrollView {
                view.frame = UIScreen.main.bounds
            } else if view is UIPageControl {
                view.backgroundColor = UIColor(red: 140.0/255, green: 198.0/255, blue: 62.0/255, alpha: 1.0)
            }
        }
    }
}
