//
//  ServiceUnavailableVC.swift
//  UL Today
//
//  Created by Shilei Mao on 01/06/2018.
//  Copyright © 2018 Andrew Design. All rights reserved.
//

import UIKit

class ServiceUnavailableVC: UIViewController {

    @IBOutlet weak var lbNotice: UILabel!
    var strMessage: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.lbNotice.text = strMessage
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
