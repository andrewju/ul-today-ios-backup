//
//  UsefulNumbers.swift
//  UL Today
//
//  Created by Andrew on 8/23/16.
//  Copyright © 2016 Andrew Design. All rights reserved.
//

import UIKit

class UsefulNumbers: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let defaultphoneURL = URL(string: "tel:061202700")
        switch (indexPath as NSIndexPath).section {
        case 0:
            let numbers = AppData.shared.usefulNumbers["emergency"] as! [String]
            switch  (indexPath as NSIndexPath).row {
            case 0:
                let phoneURL = URL(string: numbers[0])
                UIApplication.shared.open(phoneURL!, options: [:], completionHandler: nil)
            case 1:
                let phoneURL = URL(string: numbers[1])
                UIApplication.shared.open(phoneURL!, options: [:], completionHandler: nil)
            case 2:
                let phoneURL = URL(string: numbers[2])
                UIApplication.shared.open(phoneURL!, options: [:], completionHandler: nil)
            case 3:
                let phoneURL = URL(string: numbers[3])
                UIApplication.shared.open(phoneURL!, options: [:], completionHandler: nil)
            case 4:
                let phoneURL = URL(string: numbers[4])
                UIApplication.shared.open(phoneURL!, options: [:], completionHandler: nil)
            default:
                UIApplication.shared.open(defaultphoneURL!, options: [:], completionHandler: nil)
            }
        case 1:
            let numbers = AppData.shared.usefulNumbers["faculty_directories"] as! [String]
            switch  (indexPath as NSIndexPath).row {
            case 0:
                let phoneURL = URL(string: numbers[0])
                UIApplication.shared.open(phoneURL!, options: [:], completionHandler: nil)
            case 1:
                let phoneURL = URL(string: numbers[1])
                UIApplication.shared.open(phoneURL!, options: [:], completionHandler: nil)
            case 2:
                let phoneURL = URL(string: numbers[2])
                UIApplication.shared.open(phoneURL!, options: [:], completionHandler: nil)
            case 3:
                let phoneURL = URL(string: numbers[3])
                UIApplication.shared.open(phoneURL!, options: [:], completionHandler: nil)
            default:
                UIApplication.shared.open(defaultphoneURL!, options: [:], completionHandler: nil)
            }
        case 2:
            let numbers = AppData.shared.usefulNumbers["others"] as! [String]
            switch  (indexPath as NSIndexPath).row {
            case 0:
                let phoneURL = URL(string: numbers[0])
                UIApplication.shared.open(phoneURL!, options: [:], completionHandler: nil)
            case 1:
                let phoneURL = URL(string: numbers[1])
                UIApplication.shared.open(phoneURL!, options: [:], completionHandler: nil)
            case 2:
                let phoneURL = URL(string: numbers[2])
                UIApplication.shared.open(phoneURL!, options: [:], completionHandler: nil)
            default:
                UIApplication.shared.open(defaultphoneURL!, options: [:], completionHandler: nil)
            }
            
        default:
            UIApplication.shared.open(defaultphoneURL!, options: [:], completionHandler: nil)
            
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
