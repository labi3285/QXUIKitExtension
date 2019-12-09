//
//  QXAlignment.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/7/19.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

public enum QXAlignmentX {
    case left
    case center
    case right
    
    public var nsTextAlignment: NSTextAlignment {
        switch self {
        case .left:
            return .left
        case .center:
            return .center
        case .right:
            return .right
        }
    }
}

public enum QXAlignmentY {
    case top
    case center
    case bottom
}
