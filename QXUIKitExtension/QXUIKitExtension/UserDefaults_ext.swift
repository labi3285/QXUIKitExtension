//
//  UserDefault_text.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/7/5.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    public func qxOnce(key: String, todo: (() -> ())) -> Bool {
        if let _ = self.value(forKey: key) {
            return false
        }
        self.set("kQXHasShown", forKey: key)
        todo()
        return true
    }
    
}
