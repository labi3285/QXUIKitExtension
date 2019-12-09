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
        clipsToBounds = true
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
        if let e = image?.size {
            return e.sizeByAdd(padding)
        } else if let e = placeHolderImage?.size {
            return e.sizeByAdd(padding)
        }
        return QXSize.zero.sizeByAdd(padding)
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


