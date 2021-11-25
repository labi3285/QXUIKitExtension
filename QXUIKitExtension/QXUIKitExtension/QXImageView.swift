//
//  QXImageView.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/7/20.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

open class QXImageView: QXView {
    
    open var respondUpdateImage: (() ->())?
    
    open override var contentMode: UIView.ContentMode {
        didSet {
            super.contentMode = contentMode
            uiImageView.contentMode = contentMode
        }
    }
    
    open var image: QXImage? {
        didSet {
            uiImageView.qxImage = image
            placeHolderView.isHidden = placeHolderView.image == nil || uiImageView.image != nil
        }
    }

    open var isThumbnail: Bool {
        set {
            uiImageView.qxIsThumbnail = newValue
        }
        get {
            return uiImageView.qxIsThumbnail
        }
    }
    
    open var placeHolderImage: QXImage? {
        didSet {
            placeHolderView.qxImage = placeHolderImage
            placeHolderView.isHidden = placeHolderView.image == nil || uiImageView.image != nil
        }
    }
    
    public final lazy var uiImageView: ImageView = {
        let e = ImageView()
        e.contentMode = .scaleAspectFit
        e.isUserInteractionEnabled = false
        e.respondUpdateImage = { [weak self] image in
            self?.setNeedsLayout()
            self?.placeHolderView.isHidden = self?.placeHolderView.image == nil || image != nil
            self?.qxSetNeedsLayout()
            self?.respondUpdateImage?()
        }
        return e
    }()
    public final lazy var placeHolderView: ImageView = {
        let e = ImageView()
        e.isUserInteractionEnabled = false
        e.isHidden = true
        e.respondUpdateImage = { [weak self] image in
            self?.placeHolderView.isHidden = image == nil || self?.uiImageView.image != nil
            self?.qxSetNeedsLayout()
            self?.respondUpdateImage?()
        }
        return e
    }()
    
    public override init() {
        super.init()
        addSubview(uiImageView)
        addSubview(placeHolderView)
        isUserInteractionEnabled = false
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        uiImageView.qxRect = qxBounds.rectByReduce(padding)
        placeHolderView.qxRect = qxBounds.rectByReduce(padding)
    }
    
    open override func natureContentSize() -> QXSize {
        var w: CGFloat = 0
        var h: CGFloat = 0
        if let e = image?.size, e.w > 0, e.h > 0 {
            w = e.w
            h = e.h
            if let _w = fixWidth {
                w = _w
                h = w * e.h / e.w
            }
            if let _h = fixHeight {
                h = _h
                w = h * e.w / e.h
            }
        } else if let e = placeHolderImage?.size {
            w = e.w
            h = e.h
            if let _w = fixWidth {
                w = _w
                h = w * e.h / e.w
            }
            if let _h = fixHeight {
                h = _h
                w = h * e.w / e.h
            }
        }
        return QXSize(w, h).sizeByAdd(padding)
    }
    
    public class ImageView: UIImageView {
        var respondUpdateImage: ((_ image: UIImage?) ->())?
        override public var image: UIImage? {
            didSet {
                super.image = image
                respondUpdateImage?(image)
            }
        }
    }
}

open class QXDarkImageView: QXImageView {
    
    open override var image: QXImage? {
        didSet {
            if !QXColor.isDarkMode {
                uiImageView.qxImage = image
            }
            placeHolderView.isHidden = placeHolderView.image == nil || uiImageView.image != nil
        }
    }
    
    open var imageDark: QXImage? {
        didSet {
            if QXColor.isDarkMode {
                uiImageView.qxImage = imageDark
            }
            placeHolderView.isHidden = placeHolderView.image == nil || uiImageView.image != nil
        }
    }
    
    open override var placeHolderImage: QXImage? {
        didSet {
            if !QXColor.isDarkMode {
                placeHolderView.qxImage = placeHolderImage
            }
            placeHolderView.isHidden = placeHolderView.image == nil || uiImageView.image != nil
        }
    }
    
    open var placeHolderImageDark: QXImage? {
        didSet {
            if QXColor.isDarkMode {
                placeHolderView.qxImage = placeHolderImageDark
            }
            placeHolderView.isHidden = placeHolderView.image == nil || uiImageView.image != nil
        }
    }
    
    public override init() {
        super.init()
        isUserInteractionEnabled = false
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc open func applicationDidBecomeActive() {
        if QXColor.isDarkMode {
            let a = self.placeHolderImageDark
            let b = self.imageDark
            self.placeHolderImageDark = a
            self.imageDark = b
        } else {
            let a = self.placeHolderImage
            let b = self.image
            self.placeHolderImage = a
            self.image = b
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    open override func natureContentSize() -> QXSize {
        var w: CGFloat = 0
        var h: CGFloat = 0
        if QXColor.isDarkMode {
            if let e = imageDark?.size, e.w > 0, e.h > 0 {
                w = e.w
                h = e.h
                if let _w = fixWidth {
                    w = _w
                    h = w * e.h / e.w
                }
                if let _h = fixHeight {
                    h = _h
                    w = h * e.w / e.h
                }
            } else if let e = placeHolderImageDark?.size {
                w = e.w
                h = e.h
                if let _w = fixWidth {
                    w = _w
                    h = w * e.h / e.w
                }
                if let _h = fixHeight {
                    h = _h
                    w = h * e.w / e.h
                }
            }
        } else {
            if let e = image?.size, e.w > 0, e.h > 0 {
                w = e.w
                h = e.h
                if let _w = fixWidth {
                    w = _w
                    h = w * e.h / e.w
                }
                if let _h = fixHeight {
                    h = _h
                    w = h * e.w / e.h
                }
            } else if let e = placeHolderImage?.size {
                w = e.w
                h = e.h
                if let _w = fixWidth {
                    w = _w
                    h = w * e.h / e.w
                }
                if let _h = fixHeight {
                    h = _h
                    w = h * e.w / e.h
                }
            }
        }
        return QXSize(w, h).sizeByAdd(padding)
    }
    
}
