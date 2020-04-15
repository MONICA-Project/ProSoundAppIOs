//
//  PinAnnotation.swift
//  SmartCity
//
//  Created by Daniel Eriksson on 27/06/16.
//  Copyright © 2016 CNet. All rights reserved.
//

import UIKit
import MapKit

class PinAnnotation: NSObject, MKAnnotation {
    
    var id: Int
    var name: String
    var desc: String
    var type: String
    var value: Double
    var coordinate: CLLocationCoordinate2D
    
    override init() {
        self.id = 0
        self.name = ""
        self.desc = ""
        self.type = ""
        self.value = 0
        self.coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        super.init()
    }
    /*override init() {
        super.init()
    }
   
    init(id: String, name: String, value: String, unit: String, type: String, date: NSDate?, coordinate: CLLocationCoordinate2D) {
        self.id = id
        self.name = name
        self.value = value
        self.unit = unit
        self.dateTime = date
        self.type = type
        self.coordinate = coordinate
        super.init()
        
    }*/
    
    var title: String? {
        return name
    }
    var subtitle: String? {
        return desc
    }
}
