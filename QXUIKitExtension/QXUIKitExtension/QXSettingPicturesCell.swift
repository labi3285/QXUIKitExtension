//
//  QXSettingPicturesCell.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/10/29.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit
import QXConsMaker
import TZImagePickerController

open class QXSettingPicturesCell: QXSettingCell {
    
    public var isEnableGif: Bool = true

    public var respondChange: ((_ images: [QXImage]) -> ())?

    open override func height(_ model: Any?, _ width: CGFloat) -> CGFloat? {
        let w = (width - layoutView.padding.left - layoutView.padding.right - layoutView.viewMarginX * 2) / 3
        for e in pictureViews {
            e.intrinsicSize = QXSize(w, w)
        }
        addView.intrinsicSize = QXSize(w, w)
        layoutView.intrinsicWidth = width
        return layoutView.intrinsicContentSize.height
    }
    
    public var maxPickCount: Int = 9
    
    public var pictures: [QXImage] {
        set {
            for e in pictureViews {
                e.isDisplay = false
            }
            addView.isDisplay = newValue.count < maxPickCount
            for (i, e) in newValue.enumerated() {
                let v = pictureViews[i]
                v.isDisplay = true
                v.image = e
            }
            layoutView.qxSetNeedsLayout()
        }
        get {
            return pictureViews.compactMap { $0.image }
        }
    }
    
    public lazy var closeButtons: [QXImageButton] = {
        return (0..<9).map { (i) -> QXImageButton in
            let e = QXImageButton()
            e.padding = QXEdgeInsets(5, 5, 5, 5)
            e.intrinsicSize = QXSize(30, 30)
            e.image = QXUIKitExtensionResources.shared.image("icon_close_red")
            e.respondClick = { [weak self] in
                if let s = self {
                    s.pictureViews[i].image = nil
                    s.pictureViews[i].isDisplay = false
                    s.addView.isDisplay = s.pictures.count < s.maxPickCount
                    s.layoutView.qxSetNeedsLayout()
                    s.tableView?.setNeedsUpdate()
                    s.respondChange?(s.pictures)
                }
            }
            return e
        }
    }()
    public lazy var pictureViews: [QXImageButton] = {
        return (0..<9).map { (i) -> QXImageButton in
            let e = QXImageButton()
            e.imageView.isForceImageFill = true
            e.isDisplay = false
            e.addSubview(self.closeButtons[i])
            self.closeButtons[i].IN(e).RIGHT.TOP.MAKE()
//            e.respondClick = { [weak self] in
//                if let s = self {
//                    let c = s.maxPickCount - s.pictures.count
//                    s._lastPictures = s.pictures
//                    let assets = s.pictures.compactMap({ $0.phAsset })
//                    if let vc = TZImagePickerController.init(selectedAssets: NSMutableArray(array: assets), selectedPhotos: NSMutableArray(array: []), index: i) {
//                        s.viewController?.present(vc, animated: true, completion: nil)
//                    }
//                }
//            }
            return e
        }
    }()
    public lazy var addView: QXImageButton = {
        let e = QXImageButton()
        e.intrinsicSize = QXSize(100, 100)
        e.imageView.isForceImageFill = true
        e.imageView.placeHolderImage = QXUIKitExtensionResources.shared.image("icon_add_pic")
        e.respondClick = { [weak self] in
            if let s = self {
                let c = s.maxPickCount - s.pictures.count
                s._lastPictures = s.pictures
                if let vc = TZImagePickerController(maxImagesCount: c, delegate: self) {
                    vc.allowPickingGif = s.isEnableGif
                    vc.allowPickingVideo = false
                    s.viewController?.present(vc, animated: true, completion: nil)
                }
            }
        }
        return e
    }()
    private var _lastPictures: [QXImage] = []
        
    public lazy var layoutView: QXArrangeView = {
        let one = QXArrangeView()
        one.padding = QXEdgeInsets(10, 15, 10, 15)
        one.setupViews(self.pictureViews + [self.addView])
        return one
    }()
    
    required public init() {
        super.init()
        contentView.addSubview(layoutView)
        layoutView.IN(contentView).LEFT.TOP.RIGHT.BOTTOM.MAKE()
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    required public init(_ reuseId: String) {
        fatalError("init(_:) has not been implemented")
    }
    
}

extension QXSettingPicturesCell: TZImagePickerControllerDelegate {
    
    public func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool) {
        let arr = photos!.map { (photo) -> QXImage in
            let image = QXImage(photo)
            if let asset = assets.first as? PHAsset {
                image.setPHAsset(asset)
            }
            return image
        }
        self.pictures = _lastPictures + arr
        layoutView.qxSetNeedsLayout()
        tableView?.setNeedsUpdate()
        respondChange?(pictures)
    }
    public func tz_imagePickerControllerDidCancel(_ picker: TZImagePickerController!) {
    }

    public func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingGifImage animatedImage: UIImage!, sourceAssets asset: PHAsset!) {
        let image = QXImage(animatedImage)
        if let asset = asset {
           image.setPHAsset(asset)
        }
        self.pictures = _lastPictures + [image]
        layoutView.qxSetNeedsLayout()
        tableView?.setNeedsUpdate()
        respondChange?(pictures)
    }
    
}
