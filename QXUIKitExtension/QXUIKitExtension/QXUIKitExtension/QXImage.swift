//
//  QXImage.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/6/22.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit
import Photos

public class QXImage {
    
    public var uiImage: UIImage?
    
    public var thumbUrl: QXURL?
    public var url: QXURL?
    
    public var phAsset: PHAsset?
    public var data: Data?

    public init(_ named: String) {
        self.uiImage = UIImage(named: named)
    }
    
}
