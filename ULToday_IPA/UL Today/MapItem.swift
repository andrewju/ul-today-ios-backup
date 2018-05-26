//
//  MapItem.swift
//  UL Today
//
//  Created by Andrew on 8/24/16.
//  Copyright © 2016 Andrew Design. All rights reserved.
//

import UIKit
import MapKit

class MapItem: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
    }
}
