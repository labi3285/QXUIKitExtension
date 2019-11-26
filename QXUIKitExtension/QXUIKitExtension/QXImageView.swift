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
    
    open var image: QXImage? {
        set {
            _image = newValue
            uiImageView.qxImage = newValue
            placeHolderView.isHidden = placeHolderView.image == nil || uiImageView.image != nil
        }
        get {
            if let e = uiImageView.image {
                _image?.uiImage = e
            }
            return _image
        }
    }
    
    open var isForceImageFill: Bool = false
    open var isForcePlaceHolderFill: Bool = false

    open var isThumbnail: Bool {
        set {
            uiImageView.qxIsThumbnail = newValue
        }
        get {
            return uiImageView.qxIsThumbnail
        }
    }
    
    open var alignmentX: QXAlignmentX = .center
    open var alignmentY: QXAlignmentY = .center
    
    open var placeHolderImage: QXImage? {
        set {
            placeHolderView.qxImage = newValue
            placeHolderView.isHidden = placeHolderView.image == nil || uiImageView.image != nil
        }
        get {
            return placeHolderView.qxImage
        }
    }
    
    public final lazy var uiImageView: ImageView = {
        let e = ImageView()
        e.contentMode = .scaleAspectFill
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
        clipsToBounds = true
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        if qxBounds.size.isZero {
            return
        }
        func rectForSize(_ size: QXSize) -> QXRect {
            let sw = qxBounds.w - padding.left - padding.right
            let sh = qxBounds.h - padding.top - padding.bottom
            let wh = size
            var x: CGFloat = padding.left
            var y: CGFloat = padding.top
            var w: CGFloat = 0
            var h: CGFloat = 0
            if !wh.isZero {
                if wh.w / wh.h > sw / sh {
                    if wh.w >= sw {
                        w = sw
                        h = w * wh.h / wh.w
                    } else {
                        w = wh.w
                        h = wh.h
                        switch alignmentX {
                        case .left:
                            break
                        case .center:
                            x += (sw - w) / 2
                        case .right:
                            x += sw - w
                        }
                    }
                    switch alignmentY {
                    case .top:
                        break
                    case .center:
                        y += (sh - h) / 2
                    case .bottom:
                        y += sh - h
                    }
                } else {
                    if wh.h >= sh {
                        h = sh
                        w = h * wh.w / wh.h
                    } else {
                        w = wh.w
                        h = wh.h
                        switch alignmentY {
                        case .top:
                            break
                        case .center:
                            y += (sh - h) / 2
                        case .bottom:
                            y += sh - h
                        }
                    }
                    switch alignmentX {
                    case .left:
                        break
                    case .center:
                        x += (sw - w) / 2
                    case .right:
                        x += sw - w
                    }
                }
            }
            return QXRect(x, y, w, h)
        }
        if isForcePlaceHolderFill {
            placeHolderView.qxRect = qxBounds.rectByReduce(padding)
        } else {
            placeHolderView.qxRect = rectForSize(placeHolderImage?.size ?? QXSize.zero)
        }
        if isForceImageFill {
            uiImageView.qxRect = qxBounds.rectByReduce(padding)
        } else {
            uiImageView.qxRect = rectForSize(image?.size ?? QXSize.zero)
        }
    }
        
    
    open override func natureContentSize() -> QXSize {
        var w: CGFloat = 0
        var h: CGFloat = 0
        if let e = fixWidth {
            w = e
            var size = image?.size ?? QXSize.zero
            if size.isZero, let e = placeHolderImage?.size {
                size = e
            }
            if size.isZero {
                return size
            }
            let _h = (w - padding.left - padding.right) * size.h / size.w
            if isForceImageFill {
                h = _h
            } else {
                h = min(_h, size.h)
            }
            h = padding.top + h + padding.bottom
        } else if let e = maxWidth {
            var size = image?.size ?? QXSize.zero
            if size.isZero, let e = placeHolderImage?.size {
                size = e
            }
            if size.isZero {
                return size
            }
            w = min(e, size.w + padding.left + padding.right)
            let _h = (w - padding.left - padding.right) * size.h / size.w
            h = padding.top + _h + padding.bottom
        }  else if let e = fixHeight {
            h = e
            var size = image?.size ?? QXSize.zero
            if size.isZero, let e = placeHolderImage?.size {
                 size = e
            }
            if size.isZero {
                return size
            }
            let _w = (h - padding.top - padding.bottom) * size.w / size.h
            if isForceImageFill {
                w = _w
            } else {
                w = min(_w, size.w)
            }
            w = padding.left + w + padding.right
        }  else if let e = maxHeight {
            var size = image?.size ?? QXSize.zero
            if size.isZero, let e = placeHolderImage?.size {
                size = e
            }
            if size.isZero {
                return size
            }
            h = min(e, size.h + padding.top + padding.bottom)
            let _w = (h - padding.top - padding.bottom) * size.w / size.h
            w = padding.left + _w + padding.right
        } else {
            var size = image?.size ?? QXSize.zero
            if size.isZero, let e = placeHolderImage?.size {
                size = e
            }
            if size.isZero {
                return size
            }
            w = padding.left + size.w + padding.right
            if !size.isZero {
                h = padding.top + size.w * size.h / size.w + padding.bottom
            } else {
                h = padding.top + padding.bottom
            }
        }
        return QXSize(w, h)
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
    private var _image: QXImage?
    
}


