//
//  HydrantUpdate.swift
//  Hydrants
//
//  Created by Guled Ali on 3/26/19.
//  Copyright © 2019 Guled Ali. All rights reserved.
//

import Foundation
import MapKit

class HydrantUpdate:NSObject,NSCoding {
  
    
    let coordinate: CLLocationCoordinate2D
    let imageKey: String
    let date: Date
    var comment: String?
    
    init(coordinate: CLLocationCoordinate2D,comment: String) {
        self.coordinate = coordinate
        self.imageKey = UUID().uuidString
        self.date = Date()
        self.comment = comment
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(coordinate.latitude, forKey:  constants.coordinateLatitude)
        aCoder.encode(coordinate.longitude, forKey:  constants.coordinateLongitude)
        aCoder.encode(imageKey, forKey:  constants.imageKey)
        aCoder.encode(date, forKey:  constants.dateKey)
        aCoder.encode(comment, forKey:  constants.commentKey)
    }
    
    required init?(coder aDecoder: NSCoder) {
        let latitude = aDecoder.decodeDouble(forKey: constants.coordinateLatitude)
        let longitude = aDecoder.decodeDouble(forKey: constants.coordinateLongitude)
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        imageKey = aDecoder.decodeDouble(forKey: constants.imageKey) as! String
        date = aDecoder.decodeDouble(forKey: constants.dateKey) as! Date
        comment = (aDecoder.decodeDouble(forKey: constants.commentKey) as? String)
        
    }
    
    struct constants {
        
        static let coordinateLatitude = "coordinate_latitude"
        static let coordinateLongitude = "coordinate_lonitude"
        static let imageKey = "imageKey"
        static let dateKey = "date"
        static let commentKey = "comment"
    }
}
