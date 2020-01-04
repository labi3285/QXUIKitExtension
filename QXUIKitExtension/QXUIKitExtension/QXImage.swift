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
    
    public init(size: QXSize, render: (_ ctx: CGContext, _ rect: CGRect) -> Void) {
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
                    if let e = newValue.thumbUrl?.nsURL ?? newValue.url?.nsURL  {
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
                    if let e = newValue.url?.nsURL ?? newValue.thumbUrl?.nsURL  {
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


extension UIImage {
    
    public var qxImage: QXImage {
        return QXImage(self)
    }
    
    public var qxMainColor: UIColor? {
        let w = min(Int(size.width), 9)
        let h = min(Int(size.height), 9)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        if let ctx = CGContext(data: nil, width: w, height: h, bitsPerComponent: 8, bytesPerRow: w * 4, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue), let image = cgImage {
            let rect = CGRect(x: 0, y: 0, width: CGFloat(w), height: CGFloat(h))
            ctx.draw(image, in: rect)
            if let e = ctx.data {
                let data = e.assumingMemoryBound(to: CUnsignedChar.self)
                let set = NSCountedSet(capacity: w * h)
                for x in 0..<w {
                    for y in 0..<h {
                        let offset = (y * w + x) * 4
                        let R = (data + offset + 0).pointee
                        let G = (data + offset + 1).pointee
                        let B = (data + offset + 2).pointee
                        let A = (data + offset + 3).pointee
                        if A > 0 {
                           if (R != 255 || G != 255 || B != 255) {
                                set.add([CGFloat(R), CGFloat(G), CGFloat(B), CGFloat(A)])
                           }
                       }
                    }
                }
                var max: [CGFloat]?
                var maxCount: Int = 0
                for e in set {
                    let c = set.count(for: e)
                    if c >= maxCount {
                        maxCount = c
                        max = e as? [CGFloat]
                    } else {
                        continue
                    }
                }
                if let e = max {
                    return UIColor(red: e[0] / 255,
                                   green: e[1] / 255,
                                   blue: e[2] / 255,
                                   alpha: e[3] / 255)
                }
            }
                
        }
        return UIColor.white
    }
    
    public static func qxCreate(text: String, font: UIFont, color: UIColor) -> UIImage {
        return qxCreate(text: text, font: font, color: color, ext: nil)
    }
    public static func qxCreate(text: String, font: UIFont, color: UIColor, ext: [NSAttributedString.Key : Any]?) -> UIImage {
        var dic: [NSAttributedString.Key : Any] = [:]
        if let e = ext {
            for (k,v) in e {
                dic[k] = v
            }
        }
        dic[NSAttributedString.Key.font] = font
        dic[NSAttributedString.Key.foregroundColor] = color
        let attri = NSAttributedString(string: text, attributes: dic)
        return qxCreate(size: attri.size(), render: { (ctx, rect) in
            attri.draw(at: CGPoint.zero)
        })
    }
    
    public static func qxCreate(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        return qxCreate(size: size, render: { (ctx, rect) in
            ctx.setFillColor(color.cgColor)
            ctx.setLineWidth(0)
            ctx.fill(rect)
        })
    }
    
    public static func qxCreate(size: CGSize, render: (_ ctx: CGContext, _ rect: CGRect) -> Void) -> UIImage {
        UIGraphicsBeginImageContext(size)
        let ctx = UIGraphicsGetCurrentContext()!
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        render(ctx, rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
}

extension QXImage {
    
    public static func image(text: String, font: UIFont, color: UIColor) -> QXImage {
        return image(text: text, font: font, color: color, ext: nil)
    }
    public static func image(text: String, font: UIFont, color: UIColor, ext: [NSAttributedString.Key : Any]?) -> QXImage {
        let scaleFont = font.withSize(font.qxSize * UIScreen.main.scale)
        let e = UIImage.qxCreate(text: text, font: scaleFont, color: color, ext: ext)
        let s = QXSize(e.size.width / UIScreen.main.scale, e.size.height / UIScreen.main.scale)
        return QXImage(e).setSize(s)
    }
    
    public static func image(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> QXImage {
        let s = CGSize(width: size.width * UIScreen.main.scale, height: size.height * UIScreen.main.scale)
        let e = UIImage.qxCreate(color: color, size: s)
        let s1 = QXSize(e.size.width / UIScreen.main.scale, e.size.height / UIScreen.main.scale)
        return QXImage(e).setSize(s1)
    }
    
    public static func image(size: QXSize, render: (_ ctx: CGContext, _ size: QXSize, _ scale: CGFloat) -> Void) -> QXImage {
        let s = CGSize(width: size.w * UIScreen.main.scale, height: size.h * UIScreen.main.scale)
        UIGraphicsBeginImageContext(s)
        let ctx = UIGraphicsGetCurrentContext()!
        ctx.translateBy(x: 0, y: -1)
        render(ctx, s.qxSize, UIScreen.main.scale)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        let s1 = QXSize(s.width / UIScreen.main.scale, s.height / UIScreen.main.scale)
        return QXImage(image).setSize(s1)
    }
    
}
