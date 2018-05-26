//
//  ClassesTableViewController.swift
//  UL Timetable
//
//  Created by Andrew on 8/9/16.
//  Copyright © 2016 Andrew Design. All rights reserved.
//

import UIKit
import UserNotifications

class ClassesTableViewController: UITableViewController {
    // MARK: Properties
    var id: String = ""
    var role: String = ""
    
    var classTime: String = ""
    var classType: String = ""
    var classCode: String = ""
    var classDay: Int = 0
    var classTitle: String = ""
    var classSeq: String = ""
    var classRoom: String = ""
    var holiday: Bool = false
    var displayExam: Bool = false
    var examAvailable: Bool = false
    
    var errorHappened: Bool = false
    
    var classDataRequested: Bool = false
    
    let errorMessage = "Error happened, please mail to ulapp@ul.ie to report the incident!"
    let serviceUnavailableMessage = "The service is currently unavailable, please try again later!"
    let internetMessage = "Please make sure there is internet connection and try again!"
    
    let disclaimer = "Disclaimer: UL Today App assumes no responsibility or liability for any errors or omissions in the content of this page. The app uses data from www.timetable.ul.ie. Please check with your lecturer for accurate timetable."
    
    var fullClassList = [ClassesItem]()
    var examList = [ExamItem]()
    var classList = [ClassesItem]()
    let days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    
    
    @IBOutlet var loadingView: UIView!
    
    @IBOutlet var disclaimerView: UIView!
    @IBOutlet var examButton: UIBarButtonItem!
    @IBOutlet var dayButton: UIBarButtonItem!
    @IBAction func dayButtonClicked(_ sender: Any) {
        self.displayExam = false
        let daysList:UIAlertController = UIAlertController(title: "Check another day", message: nil, preferredStyle: .actionSheet)
        for i in 0...6 {
            if(i == self.today) {
                let act:UIAlertAction = UIAlertAction(title: days[i]+"(Today)", style: .default) { UIAlertAction in
                    self.selectedDay = i
                    self.dayButton.title = "Today"
                    self.updateTimetable()
                }
                daysList.addAction(act)
            } else {
                let act:UIAlertAction = UIAlertAction(title: days[i], style: .default) { UIAlertAction in
                    self.selectedDay = i
                    self.dayButton.title = self.days[i]
                    self.updateTimetable()
                }
                daysList.addAction(act)
            }
        }
        daysList.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(daysList, animated: true, completion: nil)
    }
    
    @IBAction func examButtonClicked(_ sender: Any) {
        self.displayExam = !self.displayExam
        if(self.displayExam) {
            self.examButton.title = "CLASSES"
            //self.navigationItem.title = "EXAM TIMETABLE"
            self.dayButton.isEnabled = false
            self.dayButton.title = nil
        } else {
            self.examButton.title = "EXAMS"
            //self.navigationItem.title = self.role + " TIMETABLE"
            self.dayButton.isEnabled = true
            self.dayButton.title = "Today"
        }
        //self.examList.removeAll()
        self.tableView.reloadData()
        // Update data based on user selection
        if((self.refreshControl) != nil){
            self.refreshControl?.endRefreshing()
        }
        self.tableView.backgroundView = nil
        self.tableView.reloadData()
    }
    
    var selectedDay = 0
    var today = 0
    
    func updateTimetable() {
        if(self.displayExam) {
            //self.examList.removeAll()
            self.tableView.reloadData()
            // Update data based on user selection
            if((self.refreshControl) != nil){
                self.refreshControl?.endRefreshing()
            }
            self.tableView.backgroundView = nil
            self.tableView.reloadData()
        } else {
            self.classList.removeAll()
            self.tableView.reloadData()
            // Update data based on user selection
            self.classList.removeAll()
            let day = self.selectedDay
            for result in self.fullClassList {
                if(result.classDay == (day+1)) {
                    self.classList.append(result)
                }
            }
            if((self.refreshControl) != nil){
                self.refreshControl?.endRefreshing()
            }
            self.tableView.backgroundView = nil
            self.tableView.reloadData()
        }
    }
    
    func loadUserInfo() -> UserInfo? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: UserInfo.ArchiveURL.path) as? UserInfo
    }
    
    func saveUserInfo() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(UserInfo(role:role, id: id)!, toFile: UserInfo.ArchiveURL.path)
        if !isSuccessfulSave {
            print("Failed to save user...")
        }
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
    
    func requestTimetable() {
        guard let config = AppDelegate.getRemoteConfig() else {
            return
        }
        self.classDataRequested = false
        self.request(requestURL: URL.init(string: "\(config.serverHost)/\(config.getServiceName(ULRemoteConfigurationKey.serviceControl.rawValue, defaultValue: "control.php"))")!, completion: {
            (data, response, error) in
            self.classDataRequested = true
            if(!(error != nil)) {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:AnyObject]
                    self.holiday = !(json["classes"] as! Bool)
                    if(/*!self.holiday*/true) {
                        let type = (self.role == "STAFF" ? "true" : "false")
                        let params = "/id/"+self.id+"/staff/"+type+"/today/false"
                        self.request(requestURL: URL.init(string: "\(config.serverHost)/\(config.getServiceName(ULRemoteConfigurationKey.serviceTimeTable.rawValue, defaultValue: "id-timetable-v2.php"))"+params)!, completion: {
                            (data, response, error) in
                            if(!(error != nil)) {
                                do {
                                    self.fullClassList.removeAll()
//                                    DispatchQueue.main.async {
//                                        self.tableView.reloadData()
//                                        let messageLabel: UILabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
//                                        messageLabel.textColor = UIColor.gray
//                                        messageLabel.text = "LOADING...\n"
//                                        messageLabel.numberOfLines = 0
//                                        messageLabel.textAlignment = NSTextAlignment.center
//                                        messageLabel.font = UIFont.init(name: "Avenir-Medium", size: 15)
//                                        messageLabel.sizeToFit()
//
//                                        self.tableView.backgroundView = messageLabel
//                                        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
//                                    }
                                    
                                    let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:AnyObject]
                                    if let results = json["classes"] as? [[String: AnyObject]] {
                                        for result in results {
                                            self.fullClassList.append(ClassesItem(time: result["time"] as! String, type: result["type"] as! String, code: result["type"] as! String, title: result["name"] as! String, seq: result["weeks"] as! String, room: result["room"] as! String, day: result["day"] as! Int)!)
                                        }
                                    }
                                    
                                    // Process exam list
                                    self.examAvailable = false
                                    if(json["exam"] as! Bool && self.role == "STUDENT") {
                                        self.examAvailable = true
                                        if(json["exams"]!["count"] as! Int > 0) {
                                            self.examList.removeAll()
                                            if let results = json["exams"]!["payload"] as? [[String: AnyObject]] {
                                                for result in results {
                                                    self.examList.append(ExamItem(module: result["module"] as! String, title: result["title"] as! String, timelabel: result["timelabel"] as! String, datelabel: result["datelabel"] as! String, utimestamp: result["utimestamp"] as! Int, datetime: result["datetime"] as! String, day: result["day"] as! String, building: result["building"] as! String, location: result["location"] as! String, otherinformation: result["otherinformation"] as! String)!)
                                                }
                                            }
                                        }
                                    }

                                    DispatchQueue.main.async {
                                        self.errorHappened = false
                                        self.classList.removeAll()
                                        let day = self.selectedDay
                                        for result in self.fullClassList {
                                            if(result.classDay == (day+1)) {
                                                self.classList.append(result)
                                            }
                                        }
                                        if((self.refreshControl) != nil){
                                            self.refreshControl?.endRefreshing()
                                        }
//                                        self.tableView.backgroundView = nil
                                        self.tableView.reloadData()
                                    }
       
                                } catch {
                                    print("error serializing JSON: \(error)")
                                    let alertController = UIAlertController(title: "Message", message: self.errorMessage, preferredStyle: .alert)
                                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction) in Thread.sleep(forTimeInterval: 0.5); exit(0)}))
                                    self.present(alertController, animated: true) {
                                    }
                                    
                                }
                            } else {
                                if((error! as NSError).code == -1009) {
                                    // NSURLErrorNotConnectedToInternet = -1009
                                    
                                    let alertController = UIAlertController(title: "Message", message: self.internetMessage, preferredStyle: .alert)
                                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction) in Thread.sleep(forTimeInterval: 0.5); exit(0)}))
                                    self.present(alertController, animated: true) {
                                    }
                                } else if ([-1001, -1003, -1004].contains((error! as NSError).code)) {
                                    // NSURLErrorTimedOut = -1001
                                    // NSURLErrorCannotFindHost = -1003
                                    // NSURLErrorCannotConnectToHost = -1004
                                    
                                    DispatchQueue.main.async {
                                        self.errorHappened = true
                                    }
                                    
                                }
                            }
                            
                        })
                    }
                    
                } catch {
                    print("error serializing JSON: \(error)")
                    let alertController = UIAlertController(title: "Message", message: self.errorMessage, preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction) in Thread.sleep(forTimeInterval: 0.5); exit(0)}))
                    self.present(alertController, animated: true) {
                    }
                }
            } else {
                if((error! as NSError).code == -1009) {
                    // NSURLErrorNotConnectedToInternet = -1009
                    
                    let alertController = UIAlertController(title: "Message", message: self.internetMessage, preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction) in Thread.sleep(forTimeInterval: 0.5); exit(0)}))
                    self.present(alertController, animated: true) {
                    }
                } else if ([-1001, -1003, -1004].contains((error! as NSError).code)) {
                    // NSURLErrorTimedOut = -1001
                    // NSURLErrorCannotFindHost = -1003
                    // NSURLErrorCannotConnectToHost = -1004
                    
                    DispatchQueue.main.async {
                        self.errorHappened = true
                    }
                    
                }
            }
        })
    }
    
    func getCode(_ code: String) -> String {
        if(code.hasPrefix("AD")) {
            return "(AD)"
        }
        else if(code.hasPrefix("CS")){
            return "(CS)"
        }
        else if(code.hasPrefix("GL")){
            return "(GL)"
        }
        else if(code.hasPrefix("HS")){
            return "(HS)"
        }
        else if(code.hasPrefix("LC")){
            return "(LC)"
        }
        else if(code.hasPrefix("GEMS")){
            return "(GEMS)"
        }
        else if(code.hasPrefix("P")){
            return "(PESS/P)"
        }
        else if(code.hasPrefix("SR")){
            return "(SR)"
        }
        else if(code.hasPrefix("S")){
            return "(S)"
        }
        else if(code.hasPrefix("KB")){
            return "(KBS)"
        }
        else if(code.hasPrefix("ER")){
            return "(ER)"
        }
        else if(code.hasPrefix("F")){
            return "(F)"
        }
        else if(code.hasPrefix("L")){
            return "(L)"
        }
        else if(code.hasPrefix("A")||code.hasPrefix("B")||code.hasPrefix("C")||code.hasPrefix("D")||code.hasPrefix("E")){
            return "(A/B/C/D/E)"
        }
        else if(code.hasPrefix("IW")){
            return "(IW)"
        }
        else if (code.contains("nbsp")) {
            return "NULL"
        }
        return "NULL"
        
    }
    
    func search(_ loc: String) -> [String: Any] {
        let mapData = AppData.shared.campusMap
        for index in 0 ..< mapData.count {
            let itemName = mapData[index]["name"] as! String
            if(itemName.contains(loc)) {
                return mapData[index] as! [String : Any]
                
            }
        }
        return [:]
    }
    
    
    func reloadTableData() {
        requestTimetable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if let savedUser = loadUserInfo() {
            id = savedUser.id
            role = savedUser.role
            
            classList.removeAll()
            
            self.navigationItem.titleView = UIImageView.init(image: UIImage(named:"ul-logo"))
            self.navigationItem.titleView?.widthAnchor.constraint(equalToConstant: 32.0).isActive = true
            self.navigationItem.titleView?.heightAnchor.constraint(equalToConstant: 142.0).isActive = true
            var day = Calendar.current.component(.weekday, from: Date()) - 2
            if (day < 0) {
                day = 6
            }
            self.selectedDay = day
            self.today = day
            if(!self.displayExam) {
                self.dayButton.title = "Today"
            }
            self.reloadTableData()
            self.tableView.reloadData()
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewDidLoad() {
        self.tableView.dataSource = self

        self.refreshControl = UIRefreshControl.init()
        self.refreshControl?.addTarget(self, action: #selector(reloadData), for: UIControlEvents.valueChanged)
    }
    
    @objc func reloadData() {
        classList.removeAll()
        examList.removeAll()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        if(id.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count < 6) {
            if((self.refreshControl) != nil){
                self.refreshControl?.endRefreshing()
            }
        } else {
            self.reloadTableData()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if(self.displayExam) {
            if (examList.count > 0 /*&& holiday*/) {
                self.disclaimerView.isHidden = false
                self.tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
                return 1;
                
            } else {
                self.disclaimerView.isHidden = true
                
                // Display a message when the table is empty
                let messageLabel: UILabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
                
                if(id.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count < 6) {
                    messageLabel.text = "Please add your account in 'More' page."
                    dayButton.isEnabled = false
                    dayButton.title = nil
                    examButton.isEnabled = false
                    examButton.title = nil
                } else {
                    if(!self.displayExam) {
                        dayButton.isEnabled = true
                        if(self.selectedDay != self.today) {
                            dayButton.title = self.days[self.selectedDay]
                        } else {
                            dayButton.title = "Today"
                        }                    }
                    
                    if(!self.examAvailable) {
                        examButton.isEnabled = false
                        examButton.title = nil
                    } else {
                        examButton.isEnabled = true
                        if(self.displayExam) {
                            examButton.title = "CLASSES"
                        } else {
                            examButton.title = "EXAMS"
                        }
                    }
                    if(errorHappened) {
                        messageLabel.text = self.serviceUnavailableMessage
                    } else {
                        if((self.refreshControl?.isRefreshing)!) {
                            messageLabel.text = "LOADING...\n"
                        } else {
                            if(self.displayExam) {
                                messageLabel.text = "No exam record found, check again later."
                                
                            } else {
                                messageLabel.text = "Sweet, you have no classes for today."
                                
                            }
                        }
                    }
                    
                    
                }
                
                messageLabel.textColor = UIColor.gray
                messageLabel.numberOfLines = 0
                messageLabel.textAlignment = NSTextAlignment.center
                messageLabel.font = UIFont.init(name: "Avenir-Medium", size: 15)
                messageLabel.sizeToFit()
                
                self.tableView.backgroundView = messageLabel
                self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
            }
        } else {
            if (classList.count > 0 /*&& holiday*/) {
                self.disclaimerView.isHidden = false
                self.tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
                return 1;
                
            } else {
                self.disclaimerView.isHidden = true
                
                // Display a message when the table is empty
                let messageLabel: UILabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
                
                if(id.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count < 6) {
                    messageLabel.text = "Please add your account in 'More' page."
                    dayButton.isEnabled = false
                    dayButton.title = nil
                    examButton.isEnabled = false
                    examButton.title = nil
                } else {
                    if(!self.displayExam) {
                        dayButton.isEnabled = true
                        if(self.selectedDay != self.today) {
                            dayButton.title = self.days[self.selectedDay]
                        } else {
                            dayButton.title = "Today"
                        }
                    }
                    
                    if(!self.examAvailable) {
                        examButton.isEnabled = false
                        examButton.title = nil
                    } else {
                        examButton.isEnabled = true
                        if(self.displayExam) {
                            examButton.title = "CLASSES"
                        } else {
                            examButton.title = "EXAMS"
                        }                    }
                    if((self.refreshControl?.isRefreshing)! || !self.classDataRequested) {
                        messageLabel.text = "LOADING...\n"
                        
                    } else {
//                        if(self.tableView.backgroundView == nil) {
                            if(self.displayExam) {
                                messageLabel.text = "No exam record found, check again later."
                                
                            } else {
                                messageLabel.text = "Sweet, you have no classes for today."
                                
                            }
//                        }
                    }
                    
                }
                
                messageLabel.textColor = UIColor.gray
                messageLabel.numberOfLines = 0
                messageLabel.textAlignment = NSTextAlignment.center
                messageLabel.font = UIFont.init(name: "Avenir-Medium", size: 15)
                messageLabel.sizeToFit()
                
                print("MessabeLabel: \(messageLabel)")
                    self.tableView.backgroundView = nil
                    self.tableView.backgroundView = messageLabel
                

                self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
            }
        }
        
        return 0;
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.displayExam) {
            return examList.count
        } else {
            return classList.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "ClassesTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ClassesTableViewCell
        
        var roomInfo: String = ""
        
        if(self.displayExam) {
            let exam = examList[(indexPath as NSIndexPath).row]
            
            cell.timeLabel.text = exam.datelabel
            cell.titleLabel.text = exam.module
            cell.nameLabel.text = exam.title
            cell.seqLabel.text = "from " + exam.timelabel
            cell.roomLabel.text = "@ Room "+exam.location
            cell.buildingLabel.text = exam.building
            roomInfo = exam.location
        } else {
            let classes = classList[(indexPath as NSIndexPath).row]
            
            cell.timeLabel.text = classes.classTime
            cell.titleLabel.text = classes.classCode
            cell.nameLabel.text = classes.classTitle
            cell.seqLabel.text = "in weeks "+classes.classSeq
            cell.roomLabel.text = "@ Room "+classes.classRoom
            cell.buildingLabel.text = classes.classRoom
            
            roomInfo = classes.classRoom
        }
        
        // Process image for each cell
        if(roomInfo.hasPrefix("AD")) {
            cell.buildingLabel.text = "Analog Devices Building"
            cell.locPhoto.image = UIImage.init(named: "ad")
        }
        else if(roomInfo.hasPrefix("CS")){
            cell.buildingLabel.text = "Computer Science Building"
            cell.locPhoto.image = UIImage.init(named: "cs")
        }
        else if(roomInfo.hasPrefix("HS")){
            cell.buildingLabel.text = "Health Sciences Building"
            cell.locPhoto.image = UIImage.init(named: "hs")
        }
        else if(roomInfo.hasPrefix("LC")){
            cell.buildingLabel.text = "Languages Building"
            cell.locPhoto.image = UIImage.init(named: "lc")
        }
        else if(roomInfo.hasPrefix("GEMS")){
            cell.buildingLabel.text = "Graduate Entry Medical School"
            cell.locPhoto.image = UIImage.init(named: "gem")
        }
        else if(roomInfo.hasPrefix("P")){
            cell.buildingLabel.text = "PESS Building"
            cell.locPhoto.image = UIImage.init(named: "p")
        }
        else if(roomInfo.hasPrefix("SR")){
            cell.buildingLabel.text = "Schrodinger Building"
            cell.locPhoto.image = UIImage.init(named: "sr")
        }
        else if(roomInfo.hasPrefix("S")){
            cell.buildingLabel.text = "Schuman Building"
            cell.locPhoto.image = UIImage.init(named: "s")
        }
        else if(roomInfo.hasPrefix("KB")){
            cell.buildingLabel.text = "Kemmy Business School"
            cell.locPhoto.image = UIImage.init(named: "kbs")
        }
        else if(roomInfo.hasPrefix("ER")){
            cell.buildingLabel.text = "Engineering Research Building";
            cell.locPhoto.image = UIImage.init(named: "er")
        }
        else if(roomInfo.hasPrefix("F")){
            cell.buildingLabel.text = "The Foundation Building";
            cell.locPhoto.image = UIImage.init(named: "f")
        }
        else if(roomInfo.hasPrefix("L")){
            cell.buildingLabel.text = "Lonsdale Building"
            cell.locPhoto.image = UIImage.init(named: "l")
        }
        else if(roomInfo.hasPrefix("A")||roomInfo.hasPrefix("B")||roomInfo.hasPrefix("C")||roomInfo.hasPrefix("D")||roomInfo.hasPrefix("E")){
            cell.buildingLabel.text = "Main Building"
            cell.locPhoto.image = UIImage.init(named: "m")
        }
        else if (roomInfo.contains("nbsp")) {
            cell.buildingLabel.text = "No room location available"
            cell.locPhoto.image = UIImage.init(named: "o")
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var loc: NSString = ""
        var title: NSString = ""
        if(self.displayExam) {
            let exam = examList[(indexPath as NSIndexPath).row]
            let result = search(getCode(exam.location))
            loc = result["loc"] as! NSString
            title = result["name"] as! NSString
        } else {
            let classes = classList[(indexPath as NSIndexPath).row]
            let result = search(getCode(classes.classRoom))
            loc = result["loc"] as! NSString
            title = result["name"] as! NSString
        }
        
        //        let classes = classList[(indexPath as NSIndexPath).row]
        //        let result = search(getCode(classes.classRoom))
        //        let loc = result["loc"] as! NSString
        //        let title = result["name"] as! NSString
        let url = String(format: "http://maps.apple.com/?ll=%@,%@&z=15&q=%@", loc.components(separatedBy: ",")[0].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines), loc.components(separatedBy: ",")[1].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines), title.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).replacingOccurrences(of: " ", with: "+"))
        let linkURL = URL(string: url)
        UIApplication.shared.open(linkURL!, options: [:], completionHandler: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
