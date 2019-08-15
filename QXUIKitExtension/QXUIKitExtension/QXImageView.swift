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
    
    open var margin: QXMargin = QXMargin.zero

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
    
    public init() {
        super.init(frame: CGRect.zero)
        addSubview(uiImageView)
        addSubview(placeHolderView)
        isUserInteractionEnabled = false
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        uiImageView.frame = CGRect(x: margin.left, y: margin.top, width: bounds.width - margin.left - margin.right, height: bounds.height - margin.top - margin.bottom)
    }
    public var intrinsicWidth: CGFloat?
    open override var intrinsicContentSize: CGSize {
        if isDisplay {
            if let e = intrinsicSize {
                return e.cgSize
            } else if let e = intrinsicWidth {
                let size = image?.size ?? QXSize.zero
                if size.isZero {
                    return CGSize.zero
                } else {
                    return CGSize(width: margin.left + e + margin.right, height: margin.top + e * size.h / size.w + margin.bottom)
                }
            } else {
                let size = image?.size ?? QXSize.zero
                if size.w > 0 && size.h > 0 {
                    return CGSize(width: margin.left + size.w + margin.right, height: margin.top + size.w * size.h / size.w + margin.bottom)
                } else {
                    return CGSize.zero
                }
            }
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

