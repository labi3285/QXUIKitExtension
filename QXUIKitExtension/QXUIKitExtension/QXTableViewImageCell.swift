//
//  QXTableViewImageCell.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/11/12.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

open class QXTableViewImage {

    public init(_ image: QXImage) {
        self.image = image
    }
    
    open var image: QXImage?

    open var contentMode: UIView.ContentMode = .scaleAspectFit
    open var isThumbnail: Bool = false
    open var placeHolderImage: QXImage?
    open var padding: QXEdgeInsets = QXEdgeInsets(5, 15, 5, 15)

}

open class QXTableViewImageCell: QXTableViewCell {
    
    override open func contextDidSetup() {
        super.contextDidSetup()
        myImageView.fixWidth = (context?.givenWidth ?? 0)
    }
        
    override open var model: Any? {
        didSet {
            super.model = model
            if let e = model as? QXTableViewImage {
                myImageView.contentMode = e.contentMode
                myImageView.isThumbnail = e.isThumbnail
                myImageView.placeHolderImage = e.placeHolderImage
                myImageView.image = e.image
                myImageView.padding = e.padding
            }
        }
    }
    
    public final lazy var myImageView: QXImageView = {
        let e = QXImageView()
        e.respondUpdateImage = { [weak self] in
            self?.context?.tableView?.setNeedsUpdate()
        }
        return e
    }()

    required public init(_ reuseId: String) {
        super.init(reuseId)
        contentView.addSubview(myImageView)
        myImageView.IN(contentView).LEFT.RIGHT.TOP.BOTTOM.MAKE()
        backButton.isDisplay = false
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
