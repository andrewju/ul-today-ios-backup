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
            let linkURL = URL(string: AppData.shared.first7Weeks[0])
            UIApplication.shared.open(linkURL!, options: [:], completionHandler: nil)
        case 1:
            let linkURL = URL(string: AppData.shared.first7Weeks[1])
            UIApplication.shared.open(linkURL!, options: [:], completionHandler: nil)
        case 2:
            let linkURL = URL(string: AppData.shared.first7Weeks[2])
            UIApplication.shared.open(linkURL!, options: [:], completionHandler: nil)
        case 3:
            let linkURL = URL(string: AppData.shared.first7Weeks[3])
            UIApplication.shared.open(linkURL!, options: [:], completionHandler: nil)
        case 4:
            let linkURL = URL(string: AppData.shared.first7Weeks[4])
            UIApplication.shared.open(linkURL!, options: [:], completionHandler: nil)
        default:
            let linkURL = URL(string: AppData.shared.defaultURL!)
            UIApplication.shared.open(linkURL!, options: [:], completionHandler: nil)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
}
