//
//  HomeViewController.swift
//  UL Timetable
//
//  Created by Andrew on 16/8/8.
//  Copyright © 2016年 Andrew Design. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: Properties
    var homeTitle: String = ""
    var homeLabel: String = ""
    var homeLabel2: String = "" // for swimming pool
    var callText: String = ""
    var busText: String = ""
    var type: Int = 0
    var text: String = ""
    let classErrorMessage = "Please add your account in Settings."
    let errorMessage = "Error happened, please mail to ulapp@ul.ie to report the incident!"
    let internetMessage = "Please make sure there is internet connection and try again!"
    let serviceUnavailableMessage = "The service is currently unavailable, please try again later!"
    
    var screenType: Int = 0
    var timer = Timer()
    
    var featureNewsList = [FeatureNewsItem]()
    var instagramList = [InstagramPhotoItem]()
    
    @IBOutlet var featureNewsTitle: UILabel!
    @IBOutlet var instagramPhotosTitle: UILabel!
    
    // MARK: Properties
    var id: String = ""
    var role: String = ""
    var data: String = ""
    
    @IBOutlet weak var homeInfoLabel: UILabel!
    @IBOutlet weak var homeTitleLabel: UILabel!
    @IBOutlet var noticeLabel: UILabel!
    
    @IBOutlet var infoSlideShow: ImageSlideshow!
    @IBOutlet var homeFeatureSlideShow: ImageSlideshow!
    @IBOutlet var instagramPhotosSlideShow: ImageSlideshow!
    
    let localSource = [ImageSource(imageString: "home-image")!, ImageSource(imageString: "library-image")!, ImageSource(imageString: "bookshop-image")!, ImageSource(imageString: "arena-image")!, ImageSource(imageString: "swim-image")!]
    var afNetworkingSource = [InputSource]()
    var afNetworkingSource2 = [InputSource]()
    
    func request(requestURL: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Swift.Void) {
        var request = URLRequest(url: requestURL)
        request.httpMethod = "GET"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request as URLRequest) {
            (
            data, response, error) in
            guard let data = data, let _:URLResponse = response, error == nil else {
                print("error "+requestURL.absoluteString)
                print(error! as NSError)
                completion(nil, response, error)
                return
            }
            completion(data, response, error)
        }
        
        task.resume()
    }
    
    func getLibDataNew() {
        
        self.homeLabel = "Loading..."
        
        self.request(requestURL: URL.init(string: "https://ul-today-app.appspot.com/library")!, completion: {
            (data, response, error) in
            if(!(error != nil)) {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:AnyObject]
                    self.homeLabel = json["text"]! as! String + "\n\n- source: www.ul.ie/library"
                    DispatchQueue.main.async {
                        if(self.infoSlideShow.currentPage == 1) {
                            self.homeInfoLabel.text = self.homeLabel
                        }
                    }
                } catch {
                    print("error serializing JSON: \(error)")
                    let alertController = UIAlertController(title: nil, message: self.errorMessage, preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction) in Thread.sleep(forTimeInterval: 0.5); exit(0)}))
                    self.present(alertController, animated: true) {
                    }
                }
            } else {
                if((error! as NSError).code == -1009) {
                    // NSURLErrorNotConnectedToInternet = -1009
                    
                    let alertController = UIAlertController(title: nil, message: self.internetMessage, preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction) in Thread.sleep(forTimeInterval: 0.5); exit(0)}))
                    self.present(alertController, animated: true) {
                    }
                } else if ([-1001, -1003, -1004].contains((error! as NSError).code)) {
                    // NSURLErrorTimedOut = -1001
                    // NSURLErrorCannotFindHost = -1003
                    // NSURLErrorCannotConnectToHost = -1004
                    
                    DispatchQueue.main.async {
                        self.noticeLabel.font = UIFont.init(name: "Avenir-Roman", size: 17)
                        self.noticeLabel.textAlignment = NSTextAlignment.center
                        self.noticeLabel.text = self.serviceUnavailableMessage
                    }
                    
                }
            }
        })
    }
    
    func getBookshop() {
        
        self.homeLabel = "Loading..."
        
        self.request(requestURL: URL.init(string: "https://ul-today-app.appspot.com/bookshop")!, completion: {
            (data, response, error) in
            if(!(error != nil)) {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:AnyObject]
                    self.homeLabel = (json["text"]! as! String) + " ("+(json["days"]! as! String) + ")\n\n- source: www.omahonys.ie"
                    DispatchQueue.main.async {
                        if(self.infoSlideShow.currentPage == 2) {
                            self.homeInfoLabel.text = self.homeLabel
                        }
                    }
                } catch {
                    print("error serializing JSON: \(error)")
                    let alertController = UIAlertController(title: nil, message: self.errorMessage, preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction) in Thread.sleep(forTimeInterval: 0.5); exit(0)}))
                    self.present(alertController, animated: true) {
                    }
                    
                }
            }else {
                if((error! as NSError).code == -1009) {
                    // NSURLErrorNotConnectedToInternet = -1009
                    
                    let alertController = UIAlertController(title: nil, message: self.internetMessage, preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction) in Thread.sleep(forTimeInterval: 0.5); exit(0)}))
                    self.present(alertController, animated: true) {
                    }
                } else if ([-1001, -1003, -1004].contains((error! as NSError).code)) {
                    // NSURLErrorTimedOut = -1001
                    // NSURLErrorCannotFindHost = -1003
                    // NSURLErrorCannotConnectToHost = -1004
                    
                    DispatchQueue.main.async {
                        self.noticeLabel.font = UIFont.init(name: "Avenir-Roman", size: 17)
                        self.noticeLabel.textAlignment = NSTextAlignment.center
                        self.noticeLabel.text = self.serviceUnavailableMessage
                    }
                    
                }
            }
        })
    }
    
    
    func getArena() {
        
        self.homeLabel = "Loading..."
        
        self.request(requestURL: URL.init(string: "https://ul-today-app.appspot.com/arena")!, completion: {
            (data, response, error) in
            if(!(error != nil)) {
                do {
                    var day = Calendar.current.component(.weekday, from: Date()) - 2
                    if (day < 0) {
                        day = 6
                    }
                    
                    let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:AnyObject]
                    if(json["updated"]! as! Bool) {
                        let days1 = json["days1"]! as! [String]
                        var text = (days1[day])
                        let bankholiday = json["bankholiday"]! as! String
                        text = text + "(" + bankholiday + "*)"
                        
                        self.homeLabel = text + "\n\n- source: www.ulsport.ie\n(*Bank holiday hour)"
                        let days2 = json["days2"]! as! [String]
                        self.homeLabel2 = days2[day] + "\n\n- source: www.ulsport.ie"
                    }
                    
                    DispatchQueue.main.async {
                        if(self.infoSlideShow.currentPage == 3) {
                            self.homeInfoLabel.text = self.homeLabel
                        } else if (self.infoSlideShow.currentPage == 4) {
                            self.homeInfoLabel.text = self.homeLabel2
                        }
                    }
                } catch {
                    print("error serializing JSON: \(error)")
                    let alertController = UIAlertController(title: nil, message: self.errorMessage, preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction) in Thread.sleep(forTimeInterval: 0.5); exit(0)}))
                    self.present(alertController, animated: true) {
                    }
                }
                
            }else {
                if((error! as NSError).code == -1009) {
                    // NSURLErrorNotConnectedToInternet = -1009
                    
                    let alertController = UIAlertController(title: nil, message: self.internetMessage, preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction) in Thread.sleep(forTimeInterval: 0.5); exit(0)}))
                    self.present(alertController, animated: true) {
                    }
                } else if ([-1001, -1003, -1004].contains((error! as NSError).code)) {
                    // NSURLErrorTimedOut = -1001
                    // NSURLErrorCannotFindHost = -1003
                    // NSURLErrorCannotConnectToHost = -1004
                    
                    DispatchQueue.main.async {
                        self.noticeLabel.font = UIFont.init(name: "Avenir-Roman", size: 17)
                        self.noticeLabel.textAlignment = NSTextAlignment.center
                        self.noticeLabel.text = self.serviceUnavailableMessage
                    }
                    
                }
                
            }
        })
    }
    
    func getHomeFeatures() {
        self.request(requestURL: URL.init(string: "https://ul-today-app.appspot.com/home-feature")!, completion: {
            (data, response, error) in
            if(!(error != nil)) {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:AnyObject]
                    if let results = json["payload"] as? [[String: AnyObject]] {
                        self.featureNewsList.removeAll()
                        for result in results {
                            self.featureNewsList.append(FeatureNewsItem(title: result["title"] as! String, text: result["text"] as! String, link: result["link"] as! String, img: result["img"] as! String)!)
                        }
                    }
                    
                    DispatchQueue.main.async {
                        self.afNetworkingSource.removeAll()
                        for news in self.featureNewsList {
                            self.afNetworkingSource.append(AFURLSource(urlString: news.img)!)
                            
                        }
                        self.homeFeatureSlideShow.setImageInputs(self.afNetworkingSource)
                        self.featureNewsTitle.text = self.featureNewsList[0].title.uppercased()
                        let recognizer = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.didTap))
                        self.homeFeatureSlideShow.addGestureRecognizer(recognizer)
                    }
                } catch {
                    print("error serializing JSON: \(error)")
                    let alertController = UIAlertController(title: nil, message: self.errorMessage, preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction) in Thread.sleep(forTimeInterval: 0.5); exit(0)}))
                    self.present(alertController, animated: true) {
                    }
                } // do
            } else {
                if((error! as NSError).code == -1009) {
                    // NSURLErrorNotConnectedToInternet = -1009
                    
                    let alertController = UIAlertController(title: nil, message: self.internetMessage, preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction) in Thread.sleep(forTimeInterval: 0.5); exit(0)}))
                    self.present(alertController, animated: true) {
                    }
                } else if ([-1001, -1003, -1004].contains((error! as NSError).code)) {
                    // NSURLErrorTimedOut = -1001
                    // NSURLErrorCannotFindHost = -1003
                    // NSURLErrorCannotConnectToHost = -1004
                    
                    DispatchQueue.main.async {
                        self.noticeLabel.font = UIFont.init(name: "Avenir-Roman", size: 17)
                        self.noticeLabel.textAlignment = NSTextAlignment.center
                        self.noticeLabel.text = self.serviceUnavailableMessage
                    }
                    
                }
            }
        })
    }
    
    //
    func getInstagrams() {
        self.request(requestURL: URL.init(string: "http://35.197.202.71/instagram.php")!, completion: {
            (data, response, error) in
            if(!(error != nil)) {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:AnyObject]
                    if let results = json["images"] as? [[String: AnyObject]] {
                        self.instagramList.removeAll()
                        for result in results {
                            self.instagramList.append(InstagramPhotoItem(text: result["caption"] as! String, link: result["link"] as! String, img: result["url"] as! String)!)
                        }
                    }
                    
                    DispatchQueue.main.async {
                        self.afNetworkingSource2.removeAll()
                        for photo in self.instagramList {
                            self.afNetworkingSource2.append(AFURLSource(urlString: photo.img)!)
                            
                        }
                        self.instagramPhotosSlideShow.setImageInputs(self.afNetworkingSource2)
                        self.instagramPhotosTitle.text = self.instagramList[0].text
                        let recognizer = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.didInstgramTap))
                        self.instagramPhotosSlideShow.addGestureRecognizer(recognizer)
                    }
                } catch {
                    print("error serializing JSON: \(error)")
                    let alertController = UIAlertController(title: nil, message: self.errorMessage, preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction) in Thread.sleep(forTimeInterval: 0.5); exit(0)}))
                    self.present(alertController, animated: true) {
                    }
                } // do
            } else {
                if((error! as NSError).code == -1009) {
                    // NSURLErrorNotConnectedToInternet = -1009
                    
                    let alertController = UIAlertController(title: nil, message: self.internetMessage, preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction) in Thread.sleep(forTimeInterval: 0.5); exit(0)}))
                    self.present(alertController, animated: true) {
                    }
                } else if ([-1001, -1003, -1004].contains((error! as NSError).code)) {
                    // NSURLErrorTimedOut = -1001
                    // NSURLErrorCannotFindHost = -1003
                    // NSURLErrorCannotConnectToHost = -1004
                    
                    DispatchQueue.main.async {
                        self.noticeLabel.font = UIFont.init(name: "Avenir-Roman", size: 17)
                        self.noticeLabel.textAlignment = NSTextAlignment.center
                        self.noticeLabel.text = self.serviceUnavailableMessage
                    }
                    
                }
            }
        })
    }
    
    
    func getAlerts() {
        
        self.homeLabel = "Loading..."
        
        self.request(requestURL: URL.init(string: "https://ul-today-app.appspot.com/alerts")!, completion: {
            (data, response, error) in
            if(!(error != nil)) {
                do {
                    
                    let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:AnyObject]
                    if(json["updated"]! as! Bool) {
                        let text = json["text"]! as! String
                        self.homeLabel = text + "\n\n- source: www.ul.ie/alerts"
                    }
                    
                    DispatchQueue.main.async {
                        if(self.infoSlideShow.currentPage == 0)
                        {
                            self.homeInfoLabel.text = self.homeLabel
                        }
                    }
                } catch {
                    print("error serializing JSON: \(error)")
                    let alertController = UIAlertController(title: nil, message: self.errorMessage, preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction) in Thread.sleep(forTimeInterval: 0.5); exit(0)}))
                    self.present(alertController, animated: true) {
                    }
                    
                }
            } else {
                if((error! as NSError).code == -1009) {
                    // NSURLErrorNotConnectedToInternet = -1009
                    
                    let alertController = UIAlertController(title: nil, message: self.internetMessage, preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction) in Thread.sleep(forTimeInterval: 0.5); exit(0)}))
                    self.present(alertController, animated: true) {
                    }
                } else if ([-1001, -1003, -1004].contains((error! as NSError).code)) {
                    // NSURLErrorTimedOut = -1001
                    // NSURLErrorCannotFindHost = -1003
                    // NSURLErrorCannotConnectToHost = -1004
                    
                    DispatchQueue.main.async {
                        self.noticeLabel.font = UIFont.init(name: "Avenir-Roman", size: 17)
                        self.noticeLabel.textAlignment = NSTextAlignment.center
                        self.noticeLabel.text = self.serviceUnavailableMessage
                    }
                    
                }
            }
        })
    }
    
    func getBusTimetable() {
        
        self.screenType = screenRange()
        self.homeLabel = "Loading..."
        var busText = ""
        
        self.request(requestURL: URL.init(string: AppData.shared.rtpiLink!)!, completion: {
            (data, response, error) in
            if(!(error != nil)) {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:AnyObject]
                    if let results = json["results"] as? [[String: AnyObject]] {
                        var count  = 0
                        for result in results {
                            var busDuetime = result["duetime"] as? String
                            if(!(busDuetime?.contains(":"))! && !(busDuetime?.contains("Due"))!){
                                busDuetime = busDuetime! + " Mins"
                            }
                            let busRoute = result["route"] as? String
                            let busOperator = result["operator"] as? String
                            let busDestination = result["destination"] as? String
                            
                            let part1 = (busRoute!+"("+busOperator!+")").padding(toLength: 11,
                                                                                 withPad: " ",
                                                                                 startingAt: 0)
                            let part2 = part1 + busDestination!.padding(toLength: 17,
                                                                        withPad: " ",
                                                                        startingAt: 0)
                            if (count < 3) {
                                busText += (part2+busDuetime!+"\n\n")
                            }
                            else {
                                break
                            }
                            count = count + 1
                        }
                        self.busText = busText
                    }
                    DispatchQueue.main.async {
                        if(busText.count < 5) {
                            self.noticeLabel.font = UIFont.init(name: "Avenir-Roman", size: 17)
                            self.noticeLabel.textAlignment = NSTextAlignment.center
                            self.noticeLabel.text = "There is no bus right now."
                        } else {
                            if(self.screenType == 0) {
                                self.noticeLabel.font = UIFont.init(name: "Courier", size: 17)
                                
                            } else if(self.screenType == 1) {
                                self.noticeLabel.font = UIFont.init(name: "Courier", size: 17)
                                
                            } else {
                                self.noticeLabel.font = UIFont.init(name: "Courier", size: 13)
                            }
                            self.noticeLabel.textAlignment = NSTextAlignment.left
                            self.noticeLabel.text = self.busText
                        }
                    }
                } catch {
                    print("error serializing JSON: \(error)")
                    DispatchQueue.main.async {
                        self.noticeLabel.font = UIFont.init(name: "Avenir-Roman", size: 17)
                        self.noticeLabel.textAlignment = NSTextAlignment.center
                        self.noticeLabel.text = self.errorMessage
                    }
                } // do
            } else {
                if((error! as NSError).code == -1009) {
                    // NSURLErrorNotConnectedToInternet = -1009
                    
                    let alertController = UIAlertController(title: nil, message: self.internetMessage, preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction) in Thread.sleep(forTimeInterval: 0.5); exit(0)}))
                    self.present(alertController, animated: true) {
                    }
                } else if ([-1001, -1003, -1004].contains((error! as NSError).code)) {
                    // NSURLErrorTimedOut = -1001
                    // NSURLErrorCannotFindHost = -1003
                    // NSURLErrorCannotConnectToHost = -1004
                    
                    DispatchQueue.main.async {
                        self.noticeLabel.font = UIFont.init(name: "Avenir-Roman", size: 17)
                        self.noticeLabel.textAlignment = NSTextAlignment.center
                        self.noticeLabel.text = self.serviceUnavailableMessage
                    }                
                    
                }
            }
        })
    }
    
    // This is the call button
    @IBAction func refreshButton(_ sender: UIBarButtonItem) {
        let callList:UIAlertController = UIAlertController(title: "Quick call", message: nil, preferredStyle: .actionSheet)
        let numbers = AppData.shared.usefulNumbers["emergency"] as! [String]
        
        let number1:UIAlertAction = UIAlertAction(title: "Campus Secuirty #1", style: .default) { UIAlertAction in
            let phoneURL = URL(string: numbers[1])
            UIApplication.shared.open(phoneURL!, options: [:], completionHandler: nil)
        }
        let number2:UIAlertAction = UIAlertAction(title: "Campus Secuirty #2", style: .default) { UIAlertAction in
            let phoneURL = URL(string: numbers[2])
            UIApplication.shared.open(phoneURL!, options: [:], completionHandler: nil)
        }
        let number3:UIAlertAction = UIAlertAction(title: "UL Reception", style: .default) { UIAlertAction in
            let phoneURL = URL(string: numbers[4])
            UIApplication.shared.open(phoneURL!, options: [:], completionHandler: nil)
        }
        
        callList.addAction(number1)
        callList.addAction(number2)
        callList.addAction(number3)

        callList.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(callList, animated: true, completion: nil)
    }
    
    // MARK: Customized Functions
    
    func loadUserInfo() -> UserInfo? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: UserInfo.ArchiveURL.path) as? UserInfo
    }
    
    func platform() -> String {
        var sysinfo = utsname()
        uname(&sysinfo) // ignore return value
        return String(bytes: Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN)), encoding: .ascii)!.trimmingCharacters(in: .controlCharacters)
    }
    
    func screenRange() -> Int {
        let deviceInfo = platform()
        if(deviceInfo.contains("iPhone7,2") || deviceInfo.contains("iPhone8,1") ||
            deviceInfo.contains("iPhone9,1") || deviceInfo.contains("iPhone9,3")) {  // iPhone 6, 6s, 7
            return 0
        } else if(deviceInfo.contains("iPhone7,2") || deviceInfo.contains("iPhone8,1") ||
            deviceInfo.contains("iPhone9,2") || deviceInfo.contains("iPhone9,4")) { // iPhone 6 plus, 6s plus, 7 plus
            return 1
            
        } else {
            return 2
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationItem.titleView = UIImageView.init(image: UIImage(named:"ul-logo"))
        getInstagrams()
        getHomeFeatures()
        getBusTimetable()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    }
    
    @objc func didHomeInfoTap() {

        if(self.infoSlideShow.currentPage == 0) {
            let linkURL = URL(string: "https://www.ul.ie/alerts/")
            UIApplication.shared.open(linkURL!, options: [:], completionHandler: nil)
        } else if(self.infoSlideShow.currentPage == 1) {
            let linkURL = URL(string: "https://www.ul.ie/library/about/opening-hours")
            UIApplication.shared.open(linkURL!, options: [:], completionHandler: nil)
        } else if(self.infoSlideShow.currentPage == 2) {
            let linkURL = URL(string: "https://www.omahonys.ie/v2/r_info.php?p=contact_ul")
            UIApplication.shared.open(linkURL!, options: [:], completionHandler: nil)
        } else if(self.infoSlideShow.currentPage == 3) {
            let linkURL = URL(string: "http://www.ulsport.ie/ularena/opening-hours/")
            UIApplication.shared.open(linkURL!, options: [:], completionHandler: nil)
        } else if(self.infoSlideShow.currentPage == 4) {
            let linkURL = URL(string: "http://www.ulsport.ie/ularena/opening-hours/")
            UIApplication.shared.open(linkURL!, options: [:], completionHandler: nil)
        }
    }
    
    @objc func didInstgramTap() {
        
        let urlEncoded = self.instagramList[instagramPhotosSlideShow.currentPage].link.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let linkURL = URL(string: urlEncoded!)
        UIApplication.shared.open(linkURL!, options: [:], completionHandler: nil)
    }
    
    @objc func didTap() {
        
        let urlEncoded = self.featureNewsList[homeFeatureSlideShow.currentPage].link.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let linkURL = URL(string: urlEncoded!)
        UIApplication.shared.open(linkURL!, options: [:], completionHandler: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getHomeFeatures()
        getBusTimetable()
        getInstagrams()
        
        homeTitle = "Home"
        //homeInfoLabel.font = UIFont.init(name: "Avenir-Roman", size: 17)
        homeTitleLabel.text = homeTitle
        //cardView.backgroundColor = UIColor.orange
        homeInfoLabel.sizeToFit()
        homeInfoLabel.textAlignment = NSTextAlignment.center
        getAlerts()
        
        infoSlideShow.backgroundColor = UIColor.white
        infoSlideShow.slideshowInterval = 5.0
        infoSlideShow.pageControlPosition = PageControlPosition.hidden
        infoSlideShow.pageControl.currentPageIndicatorTintColor = UIColor.lightGray
        infoSlideShow.pageControl.pageIndicatorTintColor = UIColor.black
        infoSlideShow.contentScaleMode = UIViewContentMode.scaleAspectFill
        infoSlideShow.setImageInputs(localSource)
        
        // optional way to show activity indicator during image load (skipping the line will show no activity indicator)
        infoSlideShow.activityIndicator = DefaultActivityIndicator()
        infoSlideShow.currentPageChanged = { page in
            if(page == 0) {
                self.homeTitleLabel.text = "Home"
                self.homeInfoLabel.text = "Loading..."
                self.getAlerts()
            } else if(page == 1) {
                self.homeTitleLabel.text = "Library Hours"
                self.homeInfoLabel.text = "Loading..."
                self.getLibDataNew()
            } else if (page == 2) {
                self.homeTitleLabel.text = "Bookshop"
                self.homeInfoLabel.text = "Loading..."
                self.getBookshop()
            } else if (page == 3) {
                self.homeTitleLabel.text = "UL Arena"
                self.homeInfoLabel.text = "Loading..."
                self.getArena()
            } else if (page == 4) {
                self.homeTitleLabel.text = "National 50M Swimming Pool"
                self.homeInfoLabel.text = "Loading..."
                self.getArena()
            }
        }
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.didHomeInfoTap))
        infoSlideShow.addGestureRecognizer(recognizer)
        
        
        
        homeFeatureSlideShow.backgroundColor = UIColor.white
        homeFeatureSlideShow.slideshowInterval = 7.0
        homeFeatureSlideShow.pageControlPosition = PageControlPosition.hidden
        homeFeatureSlideShow.pageControl.currentPageIndicatorTintColor = UIColor.lightGray
        homeFeatureSlideShow.pageControl.pageIndicatorTintColor = UIColor.black
        homeFeatureSlideShow.contentScaleMode = UIViewContentMode.scaleToFill
        
        // optional way to show activity indicator during image load (skipping the line will show no activity indicator)
        homeFeatureSlideShow.activityIndicator = DefaultActivityIndicator()
        homeFeatureSlideShow.currentPageChanged = { page in
            self.featureNewsTitle.text = self.featureNewsList[page].title.uppercased()
        }
        
        instagramPhotosSlideShow.backgroundColor = UIColor.white
        instagramPhotosSlideShow.slideshowInterval = 5.0
        instagramPhotosSlideShow.pageControlPosition = PageControlPosition.hidden
        instagramPhotosSlideShow.pageControl.currentPageIndicatorTintColor = UIColor.lightGray
        instagramPhotosSlideShow.pageControl.pageIndicatorTintColor = UIColor.black
        instagramPhotosSlideShow.contentScaleMode = UIViewContentMode.scaleAspectFill
        
        // optional way to show activity indicator during image load (skipping the line will show no activity indicator)
        instagramPhotosSlideShow.activityIndicator = DefaultActivityIndicator()
        instagramPhotosSlideShow.currentPageChanged = { page in
            self.instagramPhotosTitle.text = self.instagramList[page].text
        }
        
        //let recognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.didTap))
        //slideshow.addGestureRecognizer(recognizer)
    }
    
}

