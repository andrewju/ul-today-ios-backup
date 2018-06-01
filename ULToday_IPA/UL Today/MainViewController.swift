//
//  MainViewController.swift
//  UL Today
//
//  Created by Shilei Mao on 26/05/2018.
//  Copyright © 2018 Andrew Design. All rights reserved.
//

import UIKit

public enum TabIndex: String {
    case home
    case news
    case classes
    case map
    case more
}

class MainViewController: UITabBarController {
    
    var showingClassTab: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func showClassTab(_ show: Bool, animated: Bool) {
        if show {
            if self.childViewControllers.count <= 4 { // here is not good, we need to judge by diffent method
                if let classesVc = storyboard?.instantiateViewController(withIdentifier: "TabClasses") {
                    var childVc = self.childViewControllers
                    let index = childVc.count > 3 ? 2 : childVc.count - 1
                    childVc.insert(classesVc, at: index)
                    self.setViewControllers(childVc, animated: animated)
                }
            }
            self.showingClassTab = true
        } else {
            if self.childViewControllers.count >= 5 {
                let classesIndex = 2 // hardcode is not good
                var childVc = self.childViewControllers
                childVc.remove(at: classesIndex)
                self.setViewControllers(childVc, animated: animated)
            }
            self.showingClassTab = false
        }
    }
    func updateBadge(tabIndex: TabIndex, badgeValue: String?) {
        switch tabIndex {
        case .home:
           self.tabBar.items?[0].badgeValue = badgeValue
        case .news:
            self.tabBar.items?[1].badgeValue = badgeValue
        case .classes:
            if showingClassTab {
                self.tabBar.items?[2].badgeValue = badgeValue
            }
        case .map:
            if showingClassTab {
                self.tabBar.items?[3].badgeValue = badgeValue
                
            } else {
                self.tabBar.items?[2].badgeValue = badgeValue
            }
        case .more:
            self.tabBar.items?.last?.badgeValue = badgeValue
        }
    }
    
    func updateBadge(tabIndex: TabIndex, number: Int) {
        if number > 0 {
            self.updateBadge(tabIndex: tabIndex, badgeValue: "\(number)")
        } else {
            self.updateBadge(tabIndex: tabIndex, badgeValue: nil)
        }
    }
    
    func clearBadge(tabIndex: TabIndex) {
        self.updateBadge(tabIndex: tabIndex, number: 0)
    }
}
