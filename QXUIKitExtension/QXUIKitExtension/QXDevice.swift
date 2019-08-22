//
//  QXDevice.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/8/19.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

public struct QXDevice {
    
    public static var isLiuHaiScreen: Bool {
        switch UIApplication.shared.statusBarOrientation {
        case .landscapeLeft, .landscapeRight:
            return UIScreen.main.bounds.width / UIScreen.main.bounds.height > 1.8
        default:
            return UIScreen.main.bounds.height / UIScreen.main.bounds.width > 1.8
        }
    }
    
    public static var statusBarHeight: CGFloat {
        switch UIApplication.shared.statusBarOrientation {
        case .landscapeLeft, .landscapeRight:
            return 0
        default:
            if isLiuHaiScreen {
                return 34
            } else {
                return 20
            }
        }
    }
    
    public static var navigationBarHeight: CGFloat {
        switch UIApplication.shared.statusBarOrientation {
        case .landscapeLeft, .landscapeRight:
            return 32
        default:
            return 44
        }
    }
    
    public static var tabBarHeight: CGFloat {
        return 49
    }
    
}
