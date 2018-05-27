//
//  OpeningHours.swift
//  UL Today
//
//  Created by Andrew on 8/23/16.
//  Copyright © 2016 Andrew Design. All rights reserved.
//

import UIKit

class OpeningHours: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch  (indexPath as NSIndexPath).row {
        case 0:
            if let linkURL = URL(string: AppData.shared.first7Weeks[0]) {
//            UIApplication.shared.open(linkURL!, options: [:], completionHandler: nil)
                WebBrowserVC.openBroswer(self, url: linkURL, title: nil, showCloseButton: true)
            }
        case 1:
            if let linkURL = URL(string: AppData.shared.first7Weeks[1]) {
//                UIApplication.shared.open(linkURL!, options: [:], completionHandler: nil)
                WebBrowserVC.openBroswer(self, url: linkURL, title: nil, showCloseButton: true)
            }
        case 2:
            if let linkURL = URL(string: AppData.shared.first7Weeks[2]) {
//            UIApplication.shared.open(linkURL!, options: [:], completionHandler: nil)
                WebBrowserVC.openBroswer(self, url: linkURL, title: nil, showCloseButton: true)
            }
        case 3:
            if let linkURL = URL(string: AppData.shared.first7Weeks[3]) {
//            UIApplication.shared.open(linkURL!, options: [:], completionHandler: nil)
                WebBrowserVC.openBroswer(self, url: linkURL, title: nil, showCloseButton: true)
            }
        case 4:
            if let linkURL = URL(string: AppData.shared.first7Weeks[4]) {
//            UIApplication.shared.open(linkURL!, options: [:], completionHandler: nil)
                WebBrowserVC.openBroswer(self, url: linkURL, title: nil, showCloseButton: true)
            }
        default:
            if let linkURL = URL(string: AppData.shared.defaultURL!) {
//            UIApplication.shared.open(linkURL!, options: [:], completionHandler: nil)
                WebBrowserVC.openBroswer(self, url: linkURL, title: nil, showCloseButton: true)
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
}
