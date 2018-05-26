//
//  MainViewController.swift
//  UL Today
//
//  Created by Shilei Mao on 26/05/2018.
//  Copyright © 2018 Andrew Design. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

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
        } else {
            if self.childViewControllers.count >= 5 {
                let classesIndex = 2 // hardcode is not good
                var childVc = self.childViewControllers
                childVc.remove(at: classesIndex)
                self.setViewControllers(childVc, animated: animated)
            }
        }
    }

}
