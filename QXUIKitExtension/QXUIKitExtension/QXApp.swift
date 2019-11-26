//
//  QXApp.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/11/26.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

public struct QXApp {
    
    public static var isRelease: Bool {
        var e = true
        #if DEBUG
            e = false
        #endif
        return e
    }
    
}

