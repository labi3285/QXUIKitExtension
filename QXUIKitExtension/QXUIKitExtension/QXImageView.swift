//
//  QXImageView.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/7/20.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

open class QXImageView: QXView {
    
    open var respondUpdateImage: ((_ image: QXImage?) ->())?
    
    open var padding: QXMargin = QXMargin.zero

    open var image: QXImage? {
        set {
            _image = newValue
            uiImageView.qxImage = newValue
        }
        get {
            if let e = uiImageView.image {
                _image?.uiImage = e
            }
            return _image
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
    
    public lazy var uiImageView: ImageView = {
        let one = ImageView()
        one.isUserInteractionEnabled = false
        one.respondUpdateImage = { [weak self] image in
            self?.update()
        }
        return one
    }()
    public lazy var placeHolderView: PlaceHolder = {
        let one = PlaceHolder()
        one.isUserInteractionEnabled = false
        one.isHidden = true
        return one
    }()
    
    public override init() {
        super.init()
        addSubview(uiImageView)
        addSubview(placeHolderView)
        isUserInteractionEnabled = false
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        uiImageView.frame = CGRect(x: padding.left, y: padding.top, width: bounds.width - padding.left - padding.right, height: bounds.height - padding.top - padding.bottom)
    }
    
    public var intrinsicWidth: CGFloat?
    public var intrinsicHeight: CGFloat?
    public var intrinsicMinWidth: CGFloat?
    public var intrinsicMinHeight: CGFloat?
    public var intrinsicMaxWidth: CGFloat?
    public var intrinsicMaxHeight: CGFloat?
    open override var intrinsicContentSize: CGSize {
        if isDisplay {
            var w: CGFloat = 0
            var h: CGFloat = 0
            if let e = intrinsicSize {
                w = e.w
                h = e.h
            } else if let e = intrinsicWidth {
                w = e
                let size = image?.size ?? QXSize.zero
                if !size.isZero {
                    h = padding.top + (e - padding.left - padding.right) * size.h / size.w + padding.bottom
                }
            } else if let e = intrinsicHeight {
                h = e
                let size = image?.size ?? QXSize.zero
                if !size.isZero {
                    w = padding.left + e - (padding.top - padding.bottom) * size.w / size.h + padding.right
                }
            } else {
                let size = image?.size ?? QXSize.zero
                if !size.isZero {
                    w = padding.left + size.w + padding.right
                    h = padding.top + size.w * size.h / size.w + padding.bottom
                }
            }
            if let e = intrinsicMinWidth { w = max(e, w) }
            if let e = intrinsicMaxWidth { w = min(e, w) }
            if let e = intrinsicMinHeight { h = max(e, h) }
            if let e = intrinsicMaxHeight { h = min(e, h) }
            return CGSize(width: w, height: h)
        } else {
            return CGSize.zero
        }
    }
    
    open func update() {
        respondUpdateImage?(image)
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
    public class PlaceHolder: UIImageView {
        override public var image: UIImage? {
            didSet {
                super.image = image
                self.isHidden = image == nil
            }
        }
    }
    private var _image: QXImage?
    
}

