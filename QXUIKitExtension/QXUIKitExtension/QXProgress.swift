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
    
    public init(_ current: Int, _ total: Int) {
        self.current = CGFloat(current)
        self.total = CGFloat(total)
    }
    
    public var progress: CGFloat {
        if total == 0 {
            return 1
        }
        return current / total
    }
}
