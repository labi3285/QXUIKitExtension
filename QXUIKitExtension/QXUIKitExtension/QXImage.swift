//
//  QXImage.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/6/22.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit
import Photos
import Kingfisher

open class QXImage {
    
//    public var gifImage: Gif
    
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

    public var size: QXSize? {
        set {
            _size = newValue
        }
        get {
            if let e = _size {
                return e
            } else {
                if let e = uiImage {
                    return e.qxSize
                }
            }
            return nil
        }
    }
    public func setSize(_ e: QXSize?) -> QXImage { size = e; return self }
    public func setSize(_ w: CGFloat, _ h: CGFloat) -> QXImage { return setSize(QXSize(w, h)) }

    public var renderingMode: UIImage.RenderingMode?
    public func setRenderingMode(_ e: UIImage.RenderingMode?) -> QXImage { renderingMode = e; return self }

    public init(url: String?) {
        if let e = url {
            self.url = QXURL.url(e)
        }
    }
    
    public init(path: String) {
        let path = Bundle.main.path(forResource: path, ofType: nil) ?? ""
        self._kfResource = ImageResource(downloadURL:URL(fileURLWithPath: path))
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
    
    public init(_ color: QXColor, size: QXSize) {
        self.uiImage = UIImage.qxCreate(color: color.uiColor, size: size.cgSize)
        self.size = size
    }
    
    public init(_ color: QXColor) {
        let size = QXSize(1, 1)
        self.uiImage = UIImage.qxCreate(color: color.uiColor, size: size.cgSize)
        self.size = size
    }
    
    public init(size: QXSize, render: (_ ctx: CGContext, _ rect: CGRect) -> ()) {
        self.uiImage = UIImage.qxCreate(size: size.cgSize, render: render)
        self.size = size
    }
    
    public static let invalid: QXImage! = QXImage("QXUIKitExtensionResources/icon_invalid")
    
    fileprivate var _uiImage: UIImage?
    fileprivate var _size: QXSize?
    fileprivate var _kfResource: ImageResource?

}

extension UIImageView {
    
    public var qxImage: QXImage? {
        set {
            self.qxSetImage(newValue, placeHolder: nil)
        }
        get {
            return QXImage(image)
        }
    }
    
    public func qxSetImage(_ url: String?, _ placeHolderNamed: String?) {
        if let p = placeHolderNamed {
            if let u = url {
                self.qxSetImage(QXImage(url: u), placeHolder: QXImage(p))
            } else {
                self.qxSetImage(nil, placeHolder: QXImage(url: p))
            }
        } else {
            if let u = url {
                self.qxSetImage(QXImage(url: u), placeHolder: nil)
            } else {
                self.qxSetImage(nil, placeHolder: nil)
            }
        }
    }
    
    public func qxSetImage(_ image: QXImage?, placeHolder: QXImage?) {
        if let newValue = image {
            if let e = newValue.uiImage {
                if let r = newValue.renderingMode {
                    self.image = e.withRenderingMode(r)
                } else {
                    self.image = e
                }
            } else if let e = newValue._kfResource {
                weak var ws = self
                kf.setImage(with: e, placeholder: nil, options: nil, progressBlock: nil) { (image, err, cacheType, _) in
                    if let e = image {
                        if let r = newValue.renderingMode {
                            ws?.image = e.withRenderingMode(r)
                        } else {
                            ws?.image = e
                        }
                    } else {
                        ws?.image = placeHolder?.uiImage
                    }
                }
            } else {
                weak var ws = self
                if qxIsThumbnail {
                    if let e = newValue.thumbUrl?.nsUrl ?? newValue.url?.nsUrl  {
                        kf.setImage(with: e, placeholder: nil, options: nil, progressBlock: { (receive, total) in
                        }) { (image, err, cacheType, _) in
                            if let e = image {
                                if let r = newValue.renderingMode {
                                    ws?.image = e.withRenderingMode(r)
                                } else {
                                    ws?.image = e
                                }
                            } else {
                                ws?.image = placeHolder?.uiImage
                            }
                        }
                    } else {
                        self.image = placeHolder?.uiImage
                    }
                } else {
                    if let e = newValue.url?.nsUrl ?? newValue.thumbUrl?.nsUrl  {
                        kf.setImage(with: e, placeholder: nil, options: nil, progressBlock: { (receive, total) in
                        }) { (image, err, cacheType, _) in
                            if let e = image {
                                if let r = newValue.renderingMode {
                                    ws?.image = e.withRenderingMode(r)
                                } else {
                                    ws?.image = e
                                }
                            } else {
                                ws?.image = placeHolder?.uiImage
                            }
                        }
                    } else {
                        self.image = placeHolder?.uiImage
                    }
                }
            }
        } else {
            self.image = nil
        }
    }
    
    /// 请求缩率图，默认false
    public var qxIsThumbnail: Bool {
        set {
            objc_setAssociatedObject(self, &UIImageView.kUIImageViewQXIsThumbnailAssociateKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
        get {
            if let e = objc_getAssociatedObject(self, &UIImageView.kUIImageViewQXIsThumbnailAssociateKey) as? Bool {
                return e
            }
            return false
        }
    }
    private static var kUIImageViewQXIsThumbnailAssociateKey: Bool?
    
}
