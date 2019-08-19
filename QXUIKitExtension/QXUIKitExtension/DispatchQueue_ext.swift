//
//  DispatchQueue_ext.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/7/5.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

extension DispatchQueue {
    
    public func qxAsyncWait(_ secs: Double, _ todo: @escaping (() -> ())) {
        let win = UIWindow.qxOneNormalWindow
        win?.rootViewController?.view.isUserInteractionEnabled = false
        qxAsyncAfter(secs) {
            win?.rootViewController?.view.isUserInteractionEnabled = true
            todo()
        }
    }

    public func qxAsyncAfter(_ secs: Double, _ todo: @escaping (() -> ())) {
        asyncAfter(deadline: DispatchTime.now() + secs) {
            todo()
        }
    }
    
}
