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
    
    public var uiImage: UIImage? {
        set {
            _uiImage = newValue
        }
        get {
            if let e = renderingMode {
                return _uiImage?.withRenderingMode(e)
            } else {
                return _uiImage
            }
        }
    }
    public func setUIImage(_ e: UIImage?) -> QXImage { uiImage = e; return self }
    
    public var thumbUrl: QXURL? {
        didSet {
            if url == nil {
                url = thumbUrl
            }
        }
    }
    public func setThumbUrl(_ e: QXURL?) -> QXImage { thumbUrl = e; return self }
    
    public var url: QXURL? {
        didSet {
            if thumbUrl == nil {
                thumbUrl = url
            }
        }
    }
    public func setUrl(_ e: QXURL?) -> QXImage { url = e; return self }

    public var phAsset: PHAsset?
    public func setPhAsset(_ e: PHAsset?) -> QXImage { phAsset = e; return self }

    public var data: Data?
    public func setData(_ e: Data?) -> QXImage { data = e; return self }

    public var size: CGSize? {
        set {
            _size = newValue
        }
        get {
            if let e = _size {
                return e
            } else {
                if let e = uiImage {
                    return e.size
                }
            }
            return nil
        }
    }
    public func setSize(_ e: CGSize?) -> QXImage { size = e; return self }

    public var renderingMode: UIImage.RenderingMode?
    public func setRenderingMode(_ e: UIImage.RenderingMode?) -> QXImage { renderingMode = e; return self }
    
    public init(url: String?) {
        if let e = url {
            self.url = QXURL.url(e)
        }
    }
    
    public init(_ named: String) {
        let image = UIImage(named: named)
        self._uiImage = image
    }
    public init(_ url: QXURL?) {
        self.url = url
    }
    public init(_ uiImage: UIImage?) {
        self._uiImage = uiImage
    }
    
    public init(_ color: QXColor, size: CGSize = CGSize(width: 1, height: 1)) {
        self.uiImage = UIImage.qxCreate(color: color.uiColor, size: size)
        self.size = size
    }
    
    public init(size: CGSize, render: (_ ctx: CGContext, _ rect: CGRect) -> ()) {
        self.uiImage = UIImage.qxCreate(size: size, render: render)
        self.size = size
    }
    
    
    private var _uiImage: UIImage?
    private var _size: CGSize?

}
