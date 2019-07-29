//
//  QXProgress.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/7/19.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

public struct QXProgress {
    
    public var current: CGFloat = 0
    public var total: CGFloat = 1
    
    public init(_ current: CGFloat, _ total: CGFloat) {
        self.current = current
        self.total = total
    }
    
    public init(_ current: UInt32, _ total: UInt32) {
        self.current = CGFloat(current)
        self.total = CGFloat(total)
    }
    public init(_ current: Int32, _ total: Int32) {
        self.current = CGFloat(current)
        self.total = CGFloat(total)
    }
    
    public var progress: CGFloat {
        if total == 0 {
            return QXDebugFatalError("error progress", 0)
        }
        return current / total
    }
}
