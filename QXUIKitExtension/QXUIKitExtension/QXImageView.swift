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

    open var isThumbnail: Bool {
        set {
            uiImageView.qxIsThumbnail = newValue
        }
        get {
            return uiImageView.qxIsThumbnail
        }
    }
    
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
    private var _image: QXImage?
    
}


