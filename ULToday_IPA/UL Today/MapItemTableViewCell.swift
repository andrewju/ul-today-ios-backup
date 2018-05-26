//
//  MapItemTableViewCell.swift
//  UL Today
//
//  Created by Andrew on 8/21/16.
//  Copyright © 2016 Andrew Design. All rights reserved.
//

import UIKit

class MapItemTableViewCell: UITableViewCell {


    @IBOutlet var mapItemPhoto: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
