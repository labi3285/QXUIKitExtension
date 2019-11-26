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

    open var isForceImageFill: Bool = false
    open var isForcePlaceHolderFill: Bool = false
    open var isThumbnail: Bool = false
    open var alignmentX: QXAlignmentX = .center
    open var alignmentY: QXAlignmentY = .center
    open var placeHolderImage: QXImage?

}

class QXTableViewImageCell: QXTableViewCell {
    
    override open func initializedWithTable() {
        super.initializedWithTable()
        myImageView.fixWidth = cellWidth
    }
        
    override var model: Any? {
        didSet {
            super.model = model
            if let e = model as? QXTableViewImage {
                myImageView.isForceImageFill = e.isForceImageFill
                myImageView.isForcePlaceHolderFill = e.isForcePlaceHolderFill
                myImageView.isThumbnail = e.isThumbnail
                myImageView.alignmentX = e.alignmentX
                myImageView.alignmentY = e.alignmentY
                myImageView.placeHolderImage = e.placeHolderImage
                myImageView.image = e.image
            }
        }
    }
    
    public final lazy var myImageView: QXImageView = {
        let one = QXImageView()
        one.padding = QXEdgeInsets(5, 15, 5, 15)
        one.respondUpdateImage = { [weak self] in
            self?.tableView?.setNeedsUpdate()
        }
        return one
    }()

    required init(_ reuseId: String) {
        super.init(reuseId)
        contentView.addSubview(myImageView)
        myImageView.IN(contentView).LEFT.RIGHT.TOP.BOTTOM.MAKE()
        backButton.isDisplay = false
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
