//
//  QXSettingTitlePictureCell.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/10/29.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit
import QXConsMaker
import TZImagePickerController

open class QXSettingTitlePictureCell: QXSettingCell {
        
    public var isEnableGif: Bool = false
    
    public var isEnableEdit: Bool = true
    //public var editSize: QXSize = QXSize(300, 300)

    public var picture: QXImage? {
        set {
            pictureView.image = newValue
            closeButton.isHidden = newValue != nil
        }
        get {
            return pictureView.image
        }
    }
    public var respondChange: ((_ image: QXImage?) -> ())?
    
    public lazy var titleLabel: QXLabel = {
        let one = QXLabel()
        one.numberOfLines = 1
        one.intrinsicMinHeight = 999
        one.alignmentY = .top
        one.padding = QXEdgeInsets(10, 0, 10, 0)
        one.font = QXFont(fmt: "16 #333333")
        return one
    }()
    
    public lazy var closeButton: QXImageButton = {
        let one = QXImageButton()
        one.padding = QXEdgeInsets(5, 5, 5, 5)
        one.intrinsicSize = QXSize(30, 30)
        one.image = QXUIKitExtensionResources.shared.image("icon_close_red")
        one.isHidden = true
        one.respondClick = { [weak self] in
            self?.pictureView.image = nil
            self?.closeButton.isHidden = true
            self?.respondChange?(nil)
        }
        return one
    }()
    public lazy var pictureView: QXImageButton = {
        let one = QXImageButton()
        one.intrinsicSize = QXSize(100, 100)
        one.imageView.isForceImageFill = true
        one.imageView.placeHolderImage = QXUIKitExtensionResources.shared.image("icon_add_pic")
        one.respondClick = { [weak self] in
            if let s = self {
                if let vc = TZImagePickerController(maxImagesCount: 1, delegate: self) {
                    vc.allowPickingGif = s.isEnableGif
                    vc.allowCrop = s.isEnableEdit
                    //vc.cropRect = CGRect(x: 0, y: 0, width: s.editSize.w, height: s.editSize.h)
                    vc.allowPickingVideo = false
                    self?.viewController?.present(vc, animated: true, completion: nil)
                }
            }
        }
        one.addSubview(self.closeButton)
        self.closeButton.IN(one).RIGHT.TOP.MAKE()
        return one
    }()
        
    public lazy var layoutView: QXStackView = {
        let one = QXStackView()
        one.alignmentY = .center
        one.alignmentX = .left
        one.viewMargin = 10
        one.padding = QXEdgeInsets(5, 15, 5, 15)
        one.setupViews([self.titleLabel, QXFlexView(), self.pictureView])
        return one
    }()
    
    required public init() {
        super.init()
        contentView.addSubview(layoutView)
        layoutView.IN(contentView).LEFT.TOP.RIGHT.BOTTOM.MAKE()
        height = 120
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    required public init(_ reuseId: String) {
        fatalError("init(_:) has not been implemented")
    }
    
}

extension QXSettingTitlePictureCell: TZImagePickerControllerDelegate {
    
    // The picker should dismiss itself; when it dismissed these callback will be called.
    // You can also set autoDismiss to NO, then the picker don't dismiss itself.
    // If isOriginalPhoto is YES, user picked the original photo.
    // You can get original photo with asset, by the method [[TZImageManager manager] getOriginalPhotoWithAsset:completion:].
    // The UIImage Object in photos default width is 828px, you can set it by photoWidth property.
    // 这个照片选择器会自己dismiss，当选择器dismiss的时候，会执行下面的代理方法
    // 你也可以设置autoDismiss属性为NO，选择器就不会自己dismis了
    // 如果isSelectOriginalPhoto为YES，表明用户选择了原图
    // 你可以通过一个asset获得原图，通过这个方法：[[TZImageManager manager] getOriginalPhotoWithAsset:completion:]
    // photos数组里的UIImage对象，默认是828像素宽，你可以通过设置photoWidth属性的值来改变它
    
    public func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool) {
        if let photo = photos.first {
            let image = QXImage(photo)
            if let asset = assets.first as? PHAsset {
                image.setPHAsset(asset)
            }
            pictureView.image = image
            closeButton.isHidden = false
            respondChange?(image)
        }
    }
    public func tz_imagePickerControllerDidCancel(_ picker: TZImagePickerController!) {
    }

    // 如果用户选择了一个gif图片且allowPickingMultipleVideo是NO，下面的代理方法会被执行
    // 如果allowPickingMultipleVideo是YES，将会调用imagePickerController:didFinishPickingPhotos:sourceAssets:isSelectOriginalPhoto:
    public func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingGifImage animatedImage: UIImage!, sourceAssets asset: PHAsset!) {        
        let image = QXImage(animatedImage)
        if let asset = asset {
         image.setPHAsset(asset)
        }
        pictureView.image = image
        closeButton.isHidden = false
        respondChange?(image)
    }
    
}
