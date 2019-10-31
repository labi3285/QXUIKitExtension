//
//  QXPictureView.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/10/30.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit
import DSImageBrowse

open class QXPictureView: QXImageButton {
        
    public var index: Int = 0
    
    open func handlePreview() {
        guard let url = image?.url?.nsUrl else {
            return
        }
        let item = DSImageScrollItem()
        item.largeImageURL = url
        let thumbView = imageView.uiImageView
        item.largeImageSize = thumbView.size
        item.thumbView = thumbView
        item.isVisibleThumbView = true
        let view = DSImageShowView(items: [item], type: .showTypeDefault)
        var container = qxVc?.navigationController?.view
        if container == nil {
           container = qxVc?.view
        }
        if container != nil {
           view?.presentfromImageView(thumbView, toContainer: container, index: index, animated: true, completion: {
           })
        }
    }
    public override init() {
        super.init()
        respondClick = { [weak self] in
            self?.handlePreview()
        }
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

open class QXPicturesView: QXArrangeView {
            
    public var pictures: [QXImage] {
        set {
            for e in pictureViews {
                e.isDisplay = false
            }
            for (i, e) in newValue.enumerated() {
                if i < 9 {
                    let v = pictureViews[i]
                    v.isDisplay = true
                    v.image = e
                }
            }
            qxSetNeedsLayout()
        }
        get {
            return pictureViews.compactMap { $0.image }
        }
    }

    public lazy var pictureViews: [QXImageButton] = {
        return (0..<self.maxCount).map { (i) -> QXImageButton in
            let e = QXImageButton()
            e.imageView.isForceImageFill = true
            e.isDisplay = false
            e.respondClick = { [weak self] in
                self?.handlePreview(i)
            }
            return e
        }
    }()
    
    open func handlePreview(_ currentIndex: Int) {
        if pictureViews[currentIndex].image?.url?.nsUrl == nil {
            return
        }
        var items: [DSImageScrollItem] = []
        var newIndex: Int = 0
        for (i, view) in pictureViews.enumerated() {
            if view.isDisplay {
                if let url = view.image?.url?.nsUrl {
                    let item = DSImageScrollItem()
                    item.largeImageURL = url
                    let thumbView = view.imageView.uiImageView
                    item.largeImageSize = thumbView.size
                    item.thumbView = thumbView
                    item.isVisibleThumbView = true
                    items.append(item)
                    if i < currentIndex {
                         newIndex += 1
                    }
                }
            }
        }
        let view = DSImageShowView(items: items, type: .showTypeDefault)
        var container = qxVc?.navigationController?.view
        if container == nil {
            container = qxVc?.view
        }
        let thumbView = pictureViews[currentIndex].imageView.uiImageView
        if container != nil {
            view?.presentfromImageView(thumbView, toContainer: container, index: newIndex, animated: true, completion: {
            })
        }
    }
    
    public let maxCount: Int
    public required init(_ maxCount: Int) {
        self.maxCount = maxCount
        super.init()
        setupViews(pictureViews)
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
