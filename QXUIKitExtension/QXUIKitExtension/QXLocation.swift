//
//  QXLocation.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/6/22.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import Foundation
import CoreLocation

open class QXLocation {
    
    public var adCode: String = ""

    public var name: String = ""
    
    public var address: String = ""

    public var province: String = ""
    public var city: String = ""
    public var district: String = ""
    public var street: String = ""
        
    public var longitude: String = "0"
    public var latitude: String = "0"
    
    public var coordinate: CLLocationCoordinate2D {
        set {
            longitude = "\(newValue.longitude)"
            latitude = "\(newValue.latitude)"
        }
        get {
            let lng = (longitude as NSString).doubleValue
            let lat = (latitude as NSString).doubleValue
            return CLLocationCoordinate2D(latitude: lat, longitude: lng)
        }
    }
    
    public var clLocation: CLLocation {
        let lng = (longitude as NSString).doubleValue
        let lat = (latitude as NSString).doubleValue
        return CLLocation(latitude: lat, longitude: lng)
    }
    
    public var appleCoordinate2D: CLLocationCoordinate2D {
        return QXLocation.bd_decrypt(bd_loc: self).coordinate
    }
    
    private static let x_pi = 3.14159265358979324 * 3000.0 / 180.0;
    // 高德 -> 百度
    public static func bd_encrypt(gg_Loc: QXLocation) -> QXLocation {
        let x = gg_Loc.coordinate.longitude
        let y = gg_Loc.coordinate.latitude
        let z = sqrt(x * x + y * y) + 0.00002 * sin(y * x_pi)
        let theta = atan2(y, x) + 0.000003 * cos(x * x_pi)
        let bdlon = z * cos(theta) + 0.0065
        let bdlat = z * sin(theta) + 0.006
        let location = QXLocation()
        location.coordinate = CLLocationCoordinate2D(latitude: bdlat, longitude: bdlon)
        return location
    }
    // 百度 -> 谷歌
    public static func bd_decrypt(bd_loc: QXLocation) -> QXLocation {
        let x = bd_loc.coordinate.longitude - 0.0065
        let y = bd_loc.coordinate.latitude - 0.006
        let z = sqrt(x * x + y * y) - 0.00002 * sin(y * x_pi)
        let theta = atan2(y, x) - 0.000003 * cos(x * x_pi)
        let gglon = z * cos(theta)
        let gglat = z * sin(theta)
        let location = QXLocation()
        location.coordinate = CLLocationCoordinate2D(latitude: gglat, longitude: gglon)
        return location
    }
}


