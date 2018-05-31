//
//  NewsTableViewController.swift
//  UL Timetable
//
//  Created by Andrew on 16/8/9.
//  Copyright © 2016年 Andrew Design. All rights reserved.
//

import UIKit
import SystemConfiguration
import AFNetworking

class NewsTableViewController: UITableViewController, XMLParserDelegate{
    
    // MARK: Properties
    var news = [NewsItem]()
    var events = [NewsItem]()
    
    @IBOutlet var newsToggle: UISegmentedControl!
    
    var xmlParser: XMLParser!
    
    var newsTitle: String = ""
    var newsDate: String = ""
    var newsPhoto: String = ""
    var newsImage: UIImage?
    var newsText: String = ""
    var newsLink: String = ""
    var currentParsedElement: String = String()
    let errorMessage = "Error happened, please mail to ulapp@ul.ie to report the incident!"
    let internetMessage = "Please make sure there is internet connection and try again!";
    
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
    
    func loadData() {
        guard let config = AppDelegate.getRemoteConfig() else {
            return
        }
        self.request(requestURL: URL.init(string: "\(config.serverHost)/\(config.getServiceName(ULRemoteConfigurationKey.serviceEvents.rawValue, defaultValue: "events.php"))")!, completion: {
            (data, response, error) in
            if(!(error != nil)) {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:AnyObject]
                    
                    self.news.removeAll()
                    self.events.removeAll()
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        
                    }
                    
                    if let results = json["body"] as? [[String: String]] {
                        for result in results {
                            self.events.append(NewsItem(type: "Events", title: result["text"]!, date: result["date"]!, photo: result["img"]!, text: "", link: result["link"]!)!)
                            
                        }
                    }
                    
                    let url = URL(string: "http://www.ul.ie/site/rssfeed_news")
                    let urlRequest = URLRequest(url: url!)
                    
                    let task = URLSession.shared.dataTask(with: urlRequest as URLRequest){ data, response, error in
                        
                        guard let newsData = data else {
                            return
                        }
                        self.xmlParser = XMLParser(data: newsData)
                        self.xmlParser.delegate = self
                        self.xmlParser.parse()
                    }
                    task.resume()
                    
                } catch {
                    print("error serializing JSON: \(error)")
                    let alertController = UIAlertController(title: "Message", message: self.errorMessage, preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction) in Thread.sleep(forTimeInterval: 0.5); exit(0)}))
                    self.present(alertController, animated: true) {
                    }
                }
            } else {
                let alertController = UIAlertController(title: "Message", message: self.internetMessage, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction) in Thread.sleep(forTimeInterval: 0.5); exit(0)}))
                self.present(alertController, animated: true) {
                }
            }
        })
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if let mainVc = self.tabBarController as? MainViewController {
            mainVc.clearBadge(tabIndex: .news)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize the refresh control.
        self.refreshControl = UIRefreshControl.init()
        self.refreshControl?.addTarget(self, action: #selector(reloadData), for: UIControlEvents.valueChanged)
        loadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //        self.news.removeAll()
        //        self.tableView.reloadData()
        super.viewWillAppear(true)
        //        loadData()
        
    }
    
    @objc func reloadData() {
        self.news.removeAll()
        self.events.removeAll()
        DispatchQueue.main.async {
            self.tableView.reloadData()
            
        }
        loadData()
        
        //        if((self.refreshControl) != nil){
        //            DispatchQueue.main.async() {
        //                self.tableView.reloadData()
        //            }
        //            self.refreshControl?.endRefreshing()
        //        }
    }
    
    
    // MARK: NSXMLParserDelegate
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        if elementName == "item" {
            currentParsedElement = "item"
        }
        if elementName == "title"{
            newsTitle = String()
            currentParsedElement = "title"
        }
        
        if elementName == "dc:date" {
            newsDate = String()
            currentParsedElement = "dc:date"
        }
        
        if elementName == "image" {
            newsPhoto = String()
            currentParsedElement = "image"
        }
        
        if elementName == "description" {
            newsText = String()
            currentParsedElement = "description"
        }
        
        if elementName == "link" {
            newsLink = String()
            currentParsedElement = "link"
        }
        if (elementName == "guid"){
            currentParsedElement = "guid"
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if(currentParsedElement == "title"){
            newsTitle = newsTitle + string
        }
        if(currentParsedElement == "dc:date"){
            newsDate = newsDate + string
        }
        if(currentParsedElement == "image"){
            newsPhoto = newsPhoto + string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
        if(currentParsedElement == "description"){
            if (string.components(separatedBy: "<br/>").count > 1){
                newsText = newsText + string.components(separatedBy:"<br/>")[1].replacingOccurrences(of: "<p>", with: "").replacingOccurrences(of: "</p>", with: "")
            }
            else{
                newsText = newsText + string.components(separatedBy: "<br/>")[0]
            }
        }
        if(currentParsedElement == "guid"){
        }
        if(currentParsedElement == "link"){
            newsLink = newsLink + string
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if(elementName == "item"){
            
            news.append(NewsItem(type: "UL News", title: newsTitle, date: newsDate, photo: newsPhoto, text: newsText, link: newsLink)!)
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        DispatchQueue.main.async() {
            self.tableView.reloadData()
            if((self.refreshControl) != nil){
                self.refreshControl?.endRefreshing()
            }
        }
    }
    
    
    @IBAction func newsToggleValueChanged(_ sender: Any) {
        self.tableView.reloadData()

    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if (news.count > 0) {
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
        
        return 0;
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.newsToggle.selectedSegmentIndex == 0) {
            return news.count
        } else {
            return events.count
        }
        //return news.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "NewsTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath as IndexPath) as! NewsTableViewCell
        var newsItem: NewsItem
        if(self.newsToggle.selectedSegmentIndex == 0){
            newsItem = news[(indexPath as NSIndexPath).row]

        } else {
            newsItem = events[(indexPath as NSIndexPath).row]

        }
        
        var temp = newsItem.title
        temp = temp.replacingOccurrences(of: "&nbsp;", with: " ")
        temp = temp.replacingOccurrences(of: "&#45;", with: "-")
        temp = temp.replacingOccurrences(of: "&amp;", with: "&")
        temp = temp.replacingOccurrences(of: "&amp;", with: "&")
        temp = temp.replacingOccurrences(of: "&#8217;", with: "'")
        temp = temp.replacingOccurrences(of: "&#8220;", with: "\"")
        temp = temp.replacingOccurrences(of: "&#8221;", with: "\"")
        
        cell.newsTitle.text = temp
        cell.newsType.text = newsItem.type
        if(newsItem.type.contains("Events")) {
            cell.newsType.backgroundColor = UIColor.blue
        } else {
            cell.newsType.backgroundColor = UIColor.brown
        }
        cell.newsDate.text = newsItem.date.components(separatedBy: "T")[0].replacingOccurrences(of: "-", with: "/")

        
        let url = URL(string: newsItem.photo.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        let urlRequest = URLRequest(url: url!)
        
        let task = URLSession.shared.dataTask(with: urlRequest as URLRequest){ data, response, error in
            if((data) != nil) {
                let image = UIImage.init(data: data!)
                if((image) != nil) {
                    DispatchQueue.main.async() {
                        if let updateCell = tableView.cellForRow(at: indexPath as IndexPath) as? NewsTableViewCell {
                            updateCell.newsPhoto.contentMode = UIViewContentMode.scaleAspectFill
                            updateCell.newsPhoto.clipsToBounds = true
                            updateCell.newsPhoto.image = image
                        }
                    }
                }
            }
        }
        task.resume()
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var newsItem: NewsItem
        if(self.newsToggle.selectedSegmentIndex == 0) {
            newsItem = news[(indexPath as NSIndexPath).row]

        } else {
            newsItem = events[(indexPath as NSIndexPath).row]

        }
        let urlEncoded = newsItem.link.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let linkURL = URL(string: urlEncoded!)
//        UIApplication.shared.open(linkURL!, options: [:], completionHandler: nil)
        WebBrowserVC.openBroswer(self, url: linkURL, title: nil, showCloseButton: true)
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
    }
}
