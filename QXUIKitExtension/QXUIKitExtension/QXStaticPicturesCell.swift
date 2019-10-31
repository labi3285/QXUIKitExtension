//
//  QXStaticPicturesCell.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/10/30.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit
import QXConsMaker
import DSImageBrowse

//open class QXStaticPicturesCell: QXStaticBaseCell {
//
//    open override func height(_ model: Any?, _ width: CGFloat) -> CGFloat? {
//        if pictures.count == 1 {
//            for e in pictureViews {
//                e.intrinsicWidth = width - layoutView.padding.left - layoutView.padding.right
//            }
//        } else if pictures.count == 2 {
//            let w = (width - layoutView.padding.left - layoutView.padding.right - layoutView.viewMarginX * 1) / 2
//            for e in pictureViews {
//                e.intrinsicSize = QXSize(w, w)
//            }
//        } else {
//            let w = (width - layoutView.padding.left - layoutView.padding.right - layoutView.viewMarginX * 2) / 3
//            for e in pictureViews {
//                e.intrinsicSize = QXSize(w, w)
//            }
//        }
//        layoutView.intrinsicWidth = width
//        return layoutView.intrinsicContentSize.height
//    }
//
//    public var pictures: [QXImage] {
//        set {
//            for e in pictureViews {
//                e.isDisplay = false
//            }
//            for (i, e) in newValue.enumerated() {
//                if i < 9 {
//                    let v = pictureViews[i]
//                    v.isDisplay = true
//                    v.image = e
//                }
//            }
//            layoutView.qxSetNeedsLayout()
//        }
//        get {
//            return pictureViews.compactMap { $0.image }
//        }
//    }
//
//    public lazy var pictureViews: [QXImageButton] = {
//        return (0..<9).map { (i) -> QXImageButton in
//            let e = QXImageButton()
//            e.imageView.isForceImageFill = true
//            e.isDisplay = false
//            e.respondClick = { [weak self] in
//                self?.handlePreview(i)
//            }
//            return e
//        }
//    }()
//
//    open func handlePreview(_ currentIndex: Int) {
//        var items: [DSImageScrollItem] = []
//        for view in pictureViews {
//            if view.isDisplay {
//                let url = view.image?.url?.nsUrl
//                let item = DSImageScrollItem()
//                item.largeImageURL = url
//                let thumbView = view.imageView.uiImageView
//                item.largeImageSize = thumbView.size
//                item.thumbView = thumbView
//                item.isVisibleThumbView = true
//                items.append(item)
//            }
//        }
//        let view = DSImageShowView(items: items, type: .showTypeDefault)
//        var container = vc?.navigationController?.view
//        if container == nil {
//            container = vc?.view
//        }
//        let thumbView = pictureViews[currentIndex].imageView.uiImageView
//        if container != nil {
//            view?.presentfromImageView(thumbView, toContainer: container, index: currentIndex, animated: true, completion: {
//            })
//        }
//    }
//
//    public lazy var layoutView: QXArrangeView = {
//        let one = QXArrangeView()
//        one.padding = QXEdgeInsets(5, 15, 5, 15)
//        one.setupViews(self.pictureViews)
//        return one
//    }()
//
//    required public init() {
//        super.init()
//        contentView.addSubview(layoutView)
//        layoutView.IN(contentView).LEFT.TOP.RIGHT.BOTTOM.MAKE()
//    }
//    required public init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    required public init(_ reuseId: String) {
//        fatalError("init(_:) has not been implemented")
//    }
//
//}

open class QXStaticPicturesCell: QXStaticBaseCell {
    
    open override func height(_ model: Any?, _ width: CGFloat) -> CGFloat? {
        if picturesView.pictures.count == 1 {
            for e in picturesView.pictureViews {
                e.intrinsicWidth = width - picturesView.padding.left - picturesView.padding.right
            }
        } else if picturesView.pictures.count == 2 {
            let w = (width - picturesView.padding.left - picturesView.padding.right - picturesView.viewMarginX * 1) / 2
            for e in picturesView.pictureViews {
                e.intrinsicSize = QXSize(w, w)
            }
        } else {
            let w = (width - picturesView.padding.left - picturesView.padding.right - picturesView.viewMarginX * 2) / 3
            for e in picturesView.pictureViews {
                e.intrinsicSize = QXSize(w, w)
            }
        }
        picturesView.intrinsicWidth = width
        return picturesView.intrinsicContentSize.height
    }
        
    public lazy var picturesView: QXPicturesView = {
        let one = QXPicturesView(9)
        one.padding = QXEdgeInsets(5, 15, 5, 15)
        return one
    }()
    
    required public init() {
        super.init()
        contentView.addSubview(picturesView)
        picturesView.IN(contentView).LEFT.TOP.RIGHT.BOTTOM.MAKE()
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    required public init(_ reuseId: String) {
        fatalError("init(_:) has not been implemented")
    }
    
}
