//
//  UIScrollView_ext.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/11/25.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

extension UIScrollView {
    
    public var qxIsScrollDown: Bool {
        return panGestureRecognizer.velocity(in: self).y > 5
    }
    public var qxIsScrollUp: Bool {
        return panGestureRecognizer.velocity(in: self).y < -5
    }
    
}
