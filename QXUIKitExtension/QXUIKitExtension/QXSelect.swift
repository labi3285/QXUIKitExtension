//
//  QXSelect.swift
//  Project
//
//  Created by labi3285 on 2020/1/20.
//  Copyright © 2020 labi3285_lab. All rights reserved.
//

import UIKit

open class QXSelect<T> {
    open var isSelected: Bool
    public let model: T
    public init(_ model: T, isSelected: Bool) {
        self.model = model
        self.isSelected = isSelected
    }
}

open class QXPlaceHolder<T> {
    public let model: T?
    public init(_ model: T?) {
        self.model = model
    }
}
