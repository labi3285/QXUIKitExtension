//
//  QXImage.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/6/22.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit
import Photos
//import Kingfisher
import YYWebImage

open class QXImage {
        
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
    @discardableResult
    public func setUIImage(_ e: UIImage?) -> QXImage { uiImage = e; return self }
    
    public var thumbUrl: QXURL? {
        didSet {
            if url == nil {
                url = thumbUrl
            }
        }
    }
    @discardableResult
    public func setThumbUrl(_ e: QXURL?) -> QXImage { thumbUrl = e; return self }
    
    public var url: QXURL? {
        didSet {
            if thumbUrl == nil {
                thumbUrl = url
            }
        }
    }
    
    @discardableResult
    public func setUrl(_ e: QXURL?) -> QXImage { url = e; return self }

    public var phAsset: PHAsset?
    @discardableResult
    public func setPHAsset(_ e: PHAsset?) -> QXImage { phAsset = e; return self }

//    public var data: Data?
//    @discardableResult
//    public func setData(_ e: Data?) -> QXImage { data = e; return self }

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
    @discardableResult
    public func setSize(_ e: QXSize?) -> QXImage { size = e; return self }
    @discardableResult
    public func setSize(_ w: CGFloat, _ h: CGFloat) -> QXImage { return setSize(QXSize(w, h)) }

    public var renderingMode: UIImage.RenderingMode?
    @discardableResult
    public func setRenderingMode(_ e: UIImage.RenderingMode?) -> QXImage { renderingMode = e; return self }

    public init(url: String?) {
        if let e = url {
            self.url = QXURL.url(e)
        }
    }
    
    public init(gifPath: String, in bundle: Bundle) {
        let url = bundle.url(forResource: gifPath, withExtension: nil)!
        let data = try! Data(contentsOf: url)
        self._uiImage = UIImage.qxGifImageWithData(data, scale: 1)
    }
    public convenience init(gifPath: String) {
        self.init(gifPath: gifPath, in: Bundle.main)
    }
    
    public init(iconPath: String, in bundle: Bundle) {
        let path = bundle.path(forResource: iconPath, ofType: nil) ?? ""
        let image = UIImage(contentsOfFile: path)
        self._uiImage = image
    }
    public convenience init(iconPath: String) {
        self.init(iconPath: iconPath, in: Bundle.main)
    }
    
    public init(_ cacheIconNamed: String) {
        let image = UIImage(named: cacheIconNamed)
        self._uiImage = image
    }
    public init(_ cacheIconNamed: String, in bundle: Bundle) {
        let image = UIImage(named: cacheIconNamed, in: bundle, compatibleWith: nil)
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
        
    fileprivate var _uiImage: UIImage?
    fileprivate var _size: QXSize?
    
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
            } else {
                weak var ws = self
                if qxIsThumbnail {
                    if let e = newValue.thumbUrl?.nsUrl ?? newValue.url?.nsUrl  {
                        yy_setImage(with: e, placeholder: nil, options: [.showNetworkActivity, .ignorePlaceHolder, .avoidSetImage]) { (image, url, from, stage, err) in
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
                        yy_setImage(with: e, placeholder: nil, options: [.showNetworkActivity, .ignorePlaceHolder, .avoidSetImage]) { (image, url, from, stage, err) in
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
