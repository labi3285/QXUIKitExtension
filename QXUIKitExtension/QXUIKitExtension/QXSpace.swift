//
//  QXSpace.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/11/8.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

public struct QXSpace {
    public let w: CGFloat
    public let h: CGFloat
    public init(_ space: CGFloat) {
        self.w = space
        self.h = space
    }
    public init(_ w: CGFloat, _ h: CGFloat) {
        self.w = w
        self.h = h
    }
}
public struct QXFlexSpace {
    public let ratio: CGFloat
    public init(_ ratio: CGFloat) {
        self.ratio = ratio
    }
    public init() {
        self.ratio = 1
    }
}

extension QXSpace: QXViewProtocol {
    
    public var natureSize: QXSize {
        return QXSize(w, h)
    }
    public var compressResistanceX: CGFloat {
        set { }
        get { return 9999 }
    }
    public var stretchResistanceX: CGFloat {
        set { }
        get { return 9999 }
    }
    public var compressResistanceY: CGFloat {
        set { }
        get { return 9999 }
    }
    public var stretchResistanceY: CGFloat {
        set { }
        get { return 9999 }
    }

}
extension QXFlexSpace: QXViewProtocol {
    
    public var compressResistanceX: CGFloat {
        set { }
        get { return 9999 }
    }
    public var stretchResistanceX: CGFloat {
        set { }
        get { return 9999 }
    }
    public var compressResistanceY: CGFloat {
        set { }
        get { return 9999 }
    }
    public var stretchResistanceY: CGFloat {
        set { }
        get { return 9999 }
    }
    
}
