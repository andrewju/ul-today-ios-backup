//
//  NewsTableViewCell.swift
//  UL Timetable
//
//  Created by Andrew on 16/8/9.
//  Copyright © 2016年 Andrew Design. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var newsDate: UILabel!
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var newsPhoto: UIImageView!
    @IBOutlet weak var newsType: UILabel!
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
        newsPhoto.layer.masksToBounds = true
        newsPhoto.layer.cornerRadius = 3
        newsDate.layer.masksToBounds = true
        newsDate.layer.cornerRadius = 3
        newsType.layer.masksToBounds = true
        newsType.layer.cornerRadius = 3
    }

}
