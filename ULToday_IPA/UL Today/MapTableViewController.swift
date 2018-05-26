//
//  CampusMapViewController.swift
//  UL Today
//
//  Created by Andrew on 8/21/16.
//  Copyright © 2016 Andrew Design. All rights reserved.
//

import UIKit

class CampusMapViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    // MARK: Variables
    var searchActive : Bool = false
    var data = AppData.shared.campusMap
    var filtered:[[String: Any]] = []
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /* Setup delegates */
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
    }
    @IBAction func mapButton(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filtered = data.filter({
            let title = (($0 as! Dictionary<String, String>)["name"])! as NSString
            return title.contains(searchText)
    
            }) as! [[String : Any]]
        if(filtered.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.tableView.reloadData()
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive) {
            return filtered.count
        }
        return data.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MapTableViewItemCell")! as! MapItemTableViewCell
        if(searchActive && filtered.count > 0){
            cell.mapItemPhoto.image = UIImage(named: (filtered[(indexPath as NSIndexPath).row]["code"] as! NSString).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))
            cell.titleLabel?.text = (filtered[(indexPath as NSIndexPath).row]["name"] as! String)
        } else {
            cell.mapItemPhoto.image = UIImage(named: (data[(indexPath as NSIndexPath).row]["code"] as! NSString).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))
            cell.titleLabel?.text = (data[(indexPath as NSIndexPath).row]["name"] as! String)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var cellData:[String: Any]
        if(searchActive) {
            cellData = filtered[(indexPath as NSIndexPath).row]
        } else {
            cellData = data[(indexPath as NSIndexPath).row] as! [String : Any]
        }
        let location = cellData["loc"] as! NSString
        let url = String(format: "http://maps.apple.com/?ll=%@,%@&z=15&q=%@", location.components(separatedBy: ",")[0].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines), location.components(separatedBy: ",")[1].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines), (cellData["name"] as! NSString).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).replacingOccurrences(of: " ", with: "+"))
        let linkURL = URL(string: url)
        UIApplication.shared.open(linkURL!, options: [:], completionHandler: nil)
        
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
}
