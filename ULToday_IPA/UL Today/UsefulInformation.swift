//
//  UsefulInformation.swift
//  UL Today
//
//  Created by Andrew on 8/23/16.
//  Copyright © 2016 Andrew Design. All rights reserved.
//

import UIKit

class UsefulInformation: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch (indexPath as NSIndexPath).section {
        case 0:
            let links = AppData.shared.usefulInformation["list1"] as! [String]
            switch  (indexPath as NSIndexPath).row {
            case 0:
                let linkURL = URL(string: links[0])
                UIApplication.shared.open(linkURL!, options: [:], completionHandler: nil)
            case 1:
                let linkURL = URL(string: links[1])
                UIApplication.shared.open(linkURL!, options: [:], completionHandler: nil)
            case 2:
                let linkURL = URL(string: links[2])
                UIApplication.shared.open(linkURL!, options: [:], completionHandler: nil)
            case 3:
                let linkURL = URL(string: links[3])
                UIApplication.shared.open(linkURL!, options: [:], completionHandler: nil)
            case 4:
                let linkURL = URL(string: links[4])
                UIApplication.shared.open(linkURL!, options: [:], completionHandler: nil)
            case 5:
                let linkURL = URL(string: links[5])
                UIApplication.shared.open(linkURL!, options: [:], completionHandler: nil)
            case 6:
                let linkURL = URL(string: links[6])
                UIApplication.shared.open(linkURL!, options: [:], completionHandler: nil)
            default:
                let linkURL = URL(string: AppData.shared.defaultURL!)
                UIApplication.shared.open(linkURL!, options: [:], completionHandler: nil)
            }
        case 1:
            let links = AppData.shared.usefulInformation["list2"] as! [String]
            switch  (indexPath as NSIndexPath).row {
            case 0:
                let linkURL = URL(string: links[0])
                UIApplication.shared.open(linkURL!, options: [:], completionHandler: nil)
            case 1:
                let linkURL = URL(string: links[1])
                UIApplication.shared.open(linkURL!, options: [:], completionHandler: nil)
            case 2:
                let linkURL = URL(string: links[2])
                UIApplication.shared.open(linkURL!, options: [:], completionHandler: nil)
            case 3:
                let linkURL = URL(string: links[3])
                UIApplication.shared.open(linkURL!, options: [:], completionHandler: nil)
            case 4:
                let linkURL = URL(string: links[4])
                UIApplication.shared.open(linkURL!, options: [:], completionHandler: nil)
            case 5:
                let linkURL = URL(string: links[5])
                UIApplication.shared.open(linkURL!, options: [:], completionHandler: nil)
            default:
                let linkURL = URL(string: AppData.shared.defaultURL!)
                UIApplication.shared.open(linkURL!, options: [:], completionHandler: nil)
            }
            
        default:
            let linkURL = URL(string: AppData.shared.defaultURL!)
            UIApplication.shared.open(linkURL!, options: [:], completionHandler: nil)
            
        }
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
    }
    
}
