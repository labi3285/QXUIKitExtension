//
//  UIApplication.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/7/5.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

extension UIApplication {
    
    private static var qxActivityIndicatorActiveCount: Int = 0
    func qxActivieIndicator(_ show: Bool) {
        if show {
            UIApplication.qxActivityIndicatorActiveCount += 1
            self.isNetworkActivityIndicatorVisible = true
        } else {
            UIApplication.qxActivityIndicatorActiveCount -= 1
            if UIApplication.qxActivityIndicatorActiveCount <= 0 {
                self.isNetworkActivityIndicatorVisible = false
            }
        }
    }
    
}
