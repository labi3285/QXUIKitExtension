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
    
    public var size: CGSize?
    
    public var renderingMode: UIImage.RenderingMode?

    public init(_ named: String, _ size: CGSize? = nil) {
        let image = UIImage(named: named)
        self.uiImage = image
        self.size = size ?? image?.size
    }
    
    public init(_ uiImage: UIImage?) {
        self.uiImage = uiImage
        self.size = uiImage?.size
    }
    
    public init(_ color: QXColor, _ size: CGSize = CGSize(width: 1, height: 1)) {
        self.uiImage = UIImage.qxCreate(color.uiColor, size)
        self.size = size
    }
    
    public init(_ size: CGSize, _ render: (_ ctx: CGContext, _ rect: CGRect) -> ()) {
        self.uiImage = UIImage.qxCreate(size, render)
        self.size = size
    }
    
}
