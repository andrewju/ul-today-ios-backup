//
//  ClassesTableViewCell.swift
//  UL Timetable
//
//  Created by Andrew on 8/9/16.
//  Copyright © 2016 Andrew Design. All rights reserved.
//

import UIKit

class ClassesTableViewCell: UITableViewCell {
    
    // MARK: Properties
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var locPhoto: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var seqLabel: UILabel!
    @IBOutlet weak var roomLabel: UILabel!
    @IBOutlet weak var buildingLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
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
        timeLabel.layer.masksToBounds = true
        timeLabel.layer.cornerRadius = 3
        
        locPhoto.layer.masksToBounds = true
        locPhoto.layer.cornerRadius = 3
        
        titleLabel.layer.masksToBounds = true
        titleLabel.layer.cornerRadius = 3
    }

}
