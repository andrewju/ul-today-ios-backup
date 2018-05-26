//
//  TwitterItemTableViewCell.swift
//  UL Timetable
//
//  Created by Andrew on 8/14/16.
//  Copyright © 2016 Andrew Design. All rights reserved.
//

import UIKit

class TwitterItemTableViewCell: UITableViewCell {


    @IBOutlet weak var tweetContent: UILabel!
    @IBOutlet weak var tweetDate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tweetDate.layer.masksToBounds = true
        tweetDate.layer.cornerRadius = 3
    }

}
