//
//  OthersTableViewController.swift
//  UL Timetable
//
//  Created by Andrew on 8/11/16.
//  Copyright © 2016 Andrew Design. All rights reserved.
//

import UIKit

class OthersTableViewController: UITableViewController {
    
    // MARK: Properties
    var id: String = ""
    var role: String = ""
    

    @IBOutlet var userRoleCell: UILabel!
    @IBOutlet var userIDCell: UILabel!
    
    // MARK: Customized Functions
    func loadUserInfo() -> UserInfo? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: UserInfo.ArchiveURL.path) as? UserInfo
    }
    
    @objc func reloadUserData() {
        if let savedUser = loadUserInfo() {
            id = savedUser.id
            role = savedUser.role
            
            userRoleCell.text = role
            userIDCell.text = id
            
        }
        else{
            userRoleCell.text = "Not added"
            userIDCell.text = "Not added"
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch (indexPath as NSIndexPath).section {
        case 0:
            break;
        case 1:
            break
        case 2:
            switch  (indexPath as NSIndexPath).row {
            case 0:
                let links = AppData.shared.morePage["facebook"] as! [String]
                let facebookURL = URL(string: links[0])!
                if UIApplication.shared.canOpenURL(facebookURL) {
//                    UIApplication.shared.open(facebookURL, options: [:], completionHandler: nil)
                    WebBrowserVC.openBroswer(self, url: facebookURL, title: nil, showCloseButton: true)
                } else {
//                    UIApplication.shared.open(URL(string: links[1])!, options: [:], completionHandler: nil)
                    if let url = URL(string: links[1]) {
                        WebBrowserVC.openBroswer(self, url: url, title: nil, showCloseButton: true)
                    }
                }
            case 1:
                let links = AppData.shared.morePage["twitter"] as! [String]
                let twitterURL = URL(string: links[0])!
                if UIApplication.shared.canOpenURL(twitterURL) {
//                    UIApplication.shared.open(twitterURL, options: [:], completionHandler: nil)
                    WebBrowserVC.openBroswer(self, url: twitterURL, title: nil, showCloseButton: true)
                } else {
//                    UIApplication.shared.open(URL(string: links[1])!, options: [:], completionHandler: nil)
                    if let url = URL(string: links[1]) {
                        WebBrowserVC.openBroswer(self, url: url, title: nil, showCloseButton: true)
                    }
                }
            case 2:
                let links = AppData.shared.morePage["instgram"] as! [String]
                let twitterURL = URL(string: links[0])!
                if UIApplication.shared.canOpenURL(twitterURL) {
//                    UIApplication.shared.open(twitterURL, options: [:], completionHandler: nil)
                    WebBrowserVC.openBroswer(self, url: twitterURL, title: nil, showCloseButton: true)
                } else {
//                    UIApplication.shared.open(URL(string: links[1])!, options: [:], completionHandler: nil)
                    if let url = URL(string: links[1]) {
                        WebBrowserVC.openBroswer(self, url: url, title: nil, showCloseButton: true)
                    }
                }
            default:
                let linkURL = URL(string: AppData.shared.defaultURL!)
//                UIApplication.shared.open(linkURL!, options: [:], completionHandler: nil)
                WebBrowserVC.openBroswer(self, url: linkURL, title: nil, showCloseButton: true)
            }
        case 3:
            switch  (indexPath as NSIndexPath).row {
            case 0:
                let linkURL = URL(string: AppData.shared.defaultURL!)
//                UIApplication.shared.open(linkURL!, options: [:], completionHandler: nil)
                WebBrowserVC.openBroswer(self, url: linkURL, title: nil, showCloseButton: true)
            case 1:
                let linkURL = URL(string: AppData.shared.morePage["feedback"] as! String)
//                UIApplication.shared.open(linkURL!, options: [:], completionHandler: nil)
                WebBrowserVC.openBroswer(self, url: linkURL, title: nil, showCloseButton: true)
            default:
                let linkURL = URL(string: AppData.shared.defaultURL!)
//                UIApplication.shared.open(linkURL!, options: [:], completionHandler: nil)
                WebBrowserVC.openBroswer(self, url: linkURL, title: nil, showCloseButton: true)
            }
            
        default:
            let linkURL = URL(string: AppData.shared.defaultURL!)
//            UIApplication.shared.open(linkURL!, options: [:], completionHandler: nil)
            WebBrowserVC.openBroswer(self, url: linkURL, title: nil, showCloseButton: true)
            
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if let mainVc = self.tabBarController as? MainViewController {
            mainVc.clearBadge(tabIndex: .more)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadUserData), name: NSNotification.Name(rawValue: "reload"), object: nil)
        if let savedUser = loadUserInfo() {
            id = savedUser.id
            role = savedUser.role
 
            userRoleCell.text = role
            userIDCell.text = id
            
        }
        else{
            userRoleCell.text = "Not added"
            userIDCell.text = "Not added"
            //id = "09003523"
            //role = "STUDENT"
            //data = ""
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

}
