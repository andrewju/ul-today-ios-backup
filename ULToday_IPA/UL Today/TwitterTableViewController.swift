//
//  TwitterTableViewController.swift
//  UL Today
//
//  Created by Andrew on 8/18/16.
//  Copyright © 2016 Andrew Design. All rights reserved.
//

import UIKit
import SystemConfiguration

class TwitterTableViewController: UITableViewController {
    var twitterData: String = ""
    var tweetsLit = [TwitterData]()
    
    let errorMessage = "Error happened, please mail to ulapp@ul.ie to report the incident!"
    let internetMessage = "Please make sure there is internet connection and try again!";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        getTweets()
        
        // Initialize the refresh control.
        self.refreshControl = UIRefreshControl.init()
        self.refreshControl?.addTarget(self, action: #selector(reloadData), for: UIControlEvents.valueChanged)
        
    }
    
    @objc func reloadData() {
        getTweets()
        if((self.refreshControl) != nil){
            self.refreshControl?.endRefreshing()
        }
    }
    
    @IBAction func doneButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    // URL:http://stackoverflow.com/questions/39558868/check-internet-connection-ios-10
    func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    func request(requestURL: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Swift.Void) {
        var request = URLRequest(url: requestURL)
        request.httpMethod = "GET"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request as URLRequest) {
            (
            data, response, error) in
            
            guard let data = data, let _:URLResponse = response, error == nil else {
                print("error")
                completion(nil, response, error)
                return
            }
            completion(data, response, error)
        }
        
        task.resume()
    }
    
    
    func getTweets() {
        guard let config = AppDelegate.getRemoteConfig() else {
            return
        }
        
        tweetsLit.removeAll()
        DispatchQueue.main.async {
            self.tableView.reloadData()
            
        }
        
        self.request(requestURL: URL.init(string: "\(config.serverHost)/\(config.getServiceName(ULRemoteConfigurationKey.serviceTwitter.rawValue, defaultValue: "twitter.php"))")!, completion: {
            (data, response, error) in
            if(!(error != nil)) {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:AnyObject]
                    if let results = json["payload"] as? [[String: AnyObject]] {
                        for result in results {
                            
                            self.tweetsLit.append(TwitterData(content: result["text"] as! String, date: result["date"] as! String, link: result["link"] as! String)!)
                            
                        }
                    }
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        
                    }
                } catch {
                    print("error serializing JSON: \(error)")
                    let alertController = UIAlertController(title: "Message", message: self.errorMessage, preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction) in Thread.sleep(forTimeInterval: 0.5); exit(0)}))
                    self.present(alertController, animated: true) {
                    }
                } // do
            } else {
                let alertController = UIAlertController(title: "Message", message: self.internetMessage, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction) in Thread.sleep(forTimeInterval: 0.5); exit(0)}))
                self.present(alertController, animated: true) {
                }
            }
        })
        
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if (tweetsLit.count > 0) {
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
            return 1;
            
        } else {
            
            // Display a message when the table is empty
            let messageLabel: UILabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
            
            if(isInternetAvailable()) {
                messageLabel.text = "LOADING..."
                
            } else {
                messageLabel.text = "Oops!\nThe Internet connection appears to be offline."
            }
            messageLabel.textColor = UIColor.gray
            messageLabel.numberOfLines = 0
            messageLabel.textAlignment = NSTextAlignment.center
            messageLabel.font = UIFont.init(name: "Avenir-Medium", size: 15)
            messageLabel.sizeToFit()
            
            self.tableView.backgroundView = messageLabel
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        }
        
        return 0;    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweetsLit.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "TwitterDataTableCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TwitterItemTableViewCell
        
        let tweet = tweetsLit[(indexPath as NSIndexPath).row]
        
        cell.tweetDate.text = tweet.date.replacingOccurrences(of: "+0000 ", with: "")
        
        //cell.textLabel?.text = tweet.date.replacingOccurrences(of: "+0000 ", with: "")
        
        var temp = tweet.content
        temp = temp.replacingOccurrences(of: "&nbsp;", with: " ")
        temp = temp.replacingOccurrences(of: "&#45;", with: "-")
        temp = temp.replacingOccurrences(of: "&amp;", with: "&")
        temp = temp.replacingOccurrences(of: "&amp;", with: "&")
        temp = temp.replacingOccurrences(of: "&#8217;", with: "'")
        temp = temp.replacingOccurrences(of: "&#8220;", with: "\"")
        temp = temp.replacingOccurrences(of: "&#8221;", with: "\"")
        
        //cell.detailTextLabel!.text = temp
        cell.tweetContent.text = temp
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let tweet = tweetsLit[(indexPath as NSIndexPath).row]
        let urlEncoded = tweet.link.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let linkURL = URL(string: urlEncoded!)
//        UIApplication.shared.open(linkURL!, options: [:], completionHandler: nil)
        WebBrowserVC.openBroswer(self, url: linkURL, title: nil, showCloseButton: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}
