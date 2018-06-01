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
    
    func updateBadge(tabIndex: TabIndex, number: Int) {
        switch tabIndex {
        case .home:
            if number > 0 {
                self.tabBar.items?[0].badgeValue = "\(number)"
            } else {
                self.tabBar.items?[0].badgeValue = nil
            }
        case .news:
            if number > 0 {
                self.tabBar.items?[1].badgeValue = "\(number)"
            } else {
                self.tabBar.items?[1].badgeValue = nil
            }
        case .classes:
            if showingClassTab {
                if number > 0 {
                    self.tabBar.items?[2].badgeValue = "\(number)"
                } else {
                    self.tabBar.items?[2].badgeValue = nil
                }
            }
        case .map:
            if showingClassTab {
                if number > 0 {
                    self.tabBar.items?[3].badgeValue = "\(number)"
                } else {
                    self.tabBar.items?[3].badgeValue = nil
                }
            } else {
                if number > 0 {
                    self.tabBar.items?[2].badgeValue = "\(number)"
                } else {
                    self.tabBar.items?[2].badgeValue = nil
                }
            }
        case .more:
            if number > 0 {
                self.tabBar.items?.last?.badgeValue = "\(number)"
            } else {
                self.tabBar.items?.last?.badgeValue = nil
            }
        }
    }
    
    func clearBadge(tabIndex: TabIndex) {
        self.updateBadge(tabIndex: tabIndex, number: 0)
    }
}
