//
//  GlucksmanLibrary.swift
//  UL Today
//
//  Created by Andrew on 8/23/16.
//  Copyright © 2016 Andrew Design. All rights reserved.
//

import UIKit

class GlucksmanLibrary: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch (indexPath as NSIndexPath).section {
        case 0:
            let links = AppData.shared.glucksmanLibrary["useful_links"] as! [String]
            switch  (indexPath as NSIndexPath).row {
            case 0:
                if let linkURL = URL(string: links[0]) {
//                UIApplication.shared.open(linkURL!, options: [:], completionHandler: nil)
                    WebBrowserVC.openBroswer(self, url: linkURL, title: nil, showCloseButton: true)
                }
            case 1:
                let linkURL = URL(string: links[1])
//                UIApplication.shared.open(linkURL!, options: [:], completionHandler: nil)
                WebBrowserVC.openBroswer(self, url: linkURL, title: nil, showCloseButton: true)
            case 2:
                let linkURL = URL(string: links[2])
//                UIApplication.shared.open(linkURL!, options: [:], completionHandler: nil)
                WebBrowserVC.openBroswer(self, url: linkURL, title: nil, showCloseButton: true)
            case 3:
                let linkURL = URL(string: links[3])
//                UIApplication.shared.open(linkURL!, options: [:], completionHandler: nil)
                WebBrowserVC.openBroswer(self, url: linkURL, title: nil, showCloseButton: true)
            default:
                let linkURL = URL(string: AppData.shared.defaultURL!)
//                UIApplication.shared.open(linkURL!, options: [:], completionHandler: nil)
                WebBrowserVC.openBroswer(self, url: linkURL, title: nil, showCloseButton: true)
            }
        case 1:
            let links = AppData.shared.glucksmanLibrary["contact"] as! [String]
            switch  (indexPath as NSIndexPath).row {
            case 0:
                if let linkURL = URL(string: links[0]) {
//                UIApplication.shared.open(linkURL!, options: [:], completionHandler: nil)
                    WebBrowserVC.openBroswer(self, url: linkURL, title: nil, showCloseButton: true)
                }
            case 1:
                if let linkURL = URL(string: links[1]) {
//                UIApplication.shared.open(linkURL!, options: [:], completionHandler: nil)
                    WebBrowserVC.openBroswer(self, url: linkURL, title: nil, showCloseButton: true)
                }
            case 2:
                if let linkURL = URL(string: links[2]) {
//                UIApplication.shared.open(linkURL!, options: [:], completionHandler: nil)
                    WebBrowserVC.openBroswer(self, url: linkURL, title: nil, showCloseButton: true)
                }
            default:
                if let linkURL = URL(string: AppData.shared.defaultURL!) {
//                UIApplication.shared.open(linkURL!, options: [:], completionHandler: nil)
                    WebBrowserVC.openBroswer(self, url: linkURL, title: nil, showCloseButton: true)
                }
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
