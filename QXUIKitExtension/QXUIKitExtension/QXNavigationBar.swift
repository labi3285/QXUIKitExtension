//
//  QXNavigationBar.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/8/19.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

open class QXNavigationBar: QXView {
    
    public var leftMargin: CGFloat = 10
    public var rightMargin: CGFloat = 10
    
    public var isAutoTitle: Bool = true
    public var isAutoBack: Bool = true
    public var isAutoDismiss: Bool = true
    public var isDismissAtLeft: Bool = true

    public var leftViewA: QXView? { didSet { updateView(leftViewA, old: oldValue) } }
    public var leftViewB: QXView? { didSet { updateView(leftViewB, old: oldValue) } }
    public var leftViewC: QXView? { didSet { updateView(leftViewC, old: oldValue) } }
    
    public var titleView: QXView? { didSet { updateView(titleView, old: oldValue) } }

    public var rightViewA: QXView? { didSet { updateView(rightViewA, old: oldValue) } }
    public var rightViewB: QXView? { didSet { updateView(rightViewB, old: oldValue) } }
    public var rightViewC: QXView? { didSet { updateView(rightViewC, old: oldValue) } }
    
    public var lineView: QXView? { didSet { updateView(lineView, old: oldValue) } }
    
    public final lazy var contentView: QXView = {
        let e = QXView()
        return e
    }()
    
    private func updateView(_ view: QXView?, old: QXView?) {
        if let view = view, let old = old, view === old {
            return
        }
        for e in contentView.subviews {
            if let old = old, old === e {
                e.removeFromSuperview()
            }
        }
        if let e = view {
            contentView.addSubview(e)
        }
    }

    public override init() {
        super.init()
        addSubview(contentView)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        contentView.qxRect = qxRect.insideRect(.top(QXDevice.statusBarHeight))
        let rect = contentView.qxRect.absoluteRect
        var leftViewsInfo: [(QXView, QXSize)] = []
        if let e = leftViewA { leftViewsInfo.append((e, e.natureSize)) }
        if let e = leftViewB { leftViewsInfo.append((e, e.natureSize)) }
        if let e = leftViewC { leftViewsInfo.append((e, e.natureSize)) }
        var leftTotalW: CGFloat = 0
        for e in leftViewsInfo {
            leftTotalW += e.1.w
        }
        var rightViewsInfo: [(QXView, QXSize)] = []
        if let e = rightViewC { rightViewsInfo.append((e, e.natureSize)) }
        if let e = rightViewB { rightViewsInfo.append((e, e.natureSize)) }
        if let e = rightViewA { rightViewsInfo.append((e, e.natureSize)) }
        var rightTotalW: CGFloat = 0
        for e in rightViewsInfo {
            rightTotalW += e.1.w
        }
        let contentW = rect.w - leftMargin - rightMargin
        let titleSpace = contentW - leftTotalW - rightTotalW
        var x: CGFloat = leftMargin
        if let titleView = titleView {
            let titleSize = titleView.natureSize
            let leftRemain = contentW / 2 - leftTotalW
            let rightRemain = contentW / 2 - rightTotalW
            for e in leftViewsInfo {
                e.0.qxRect = QXRect(x, (rect.h - e.1.h) / 2, e.1.w, e.1.h)
                x += e.1.w
            }
            if min(leftRemain, rightRemain) * 2 >= titleSize.w {
                x += leftRemain - titleSize.w / 2
                titleView.frame = CGRect(x: x, y: (rect.h - titleSize.h) / 2, width: titleSize.w, height: titleSize.h)
                x += titleSize.w
                x += rightRemain - titleSize.w / 2
            } else {
                titleView.frame = CGRect(x: x, y: (rect.h - titleSize.h) / 2, width: titleSpace, height: titleSize.h)
                x += titleSpace
            }
            for e in rightViewsInfo {
                e.0.qxRect = QXRect(x, (rect.h - e.1.h) / 2, e.1.w, e.1.h)
                x += e.1.w
            }
        } else {
            for e in leftViewsInfo {
                e.0.qxRect = QXRect(x, (rect.h - e.1.h) / 2, e.1.w, e.1.h)
                x += e.1.w
            }
            x += titleSpace
            for e in rightViewsInfo {
                e.0.qxRect = QXRect(x, (rect.h - e.1.h) / 2, e.1.w, e.1.h)
                x += e.1.w
            }
        }
        if let lineView = lineView {
            let size = lineView.natureSize
            lineView.qxRect = rect.insideRect(.bottom(0), .left(0), .right(0), .height(size.h))
        }
    }
    
    open override func natureContentSize() -> QXSize {
        if let e = fixWidth ?? maxWidth {
            return QXSize(e, QXDevice.statusBarHeight + QXDevice.navigationBarHeight)
        }
        return QXSize(QXView.extendLength, QXDevice.statusBarHeight + QXDevice.navigationBarHeight)
    }
    
}

extension QXNavigationBar {
    
    open func autoCheckOrSetBackButton(image: QXImage?, title: String?, font: QXFont?) -> QXButton? {
        if leftViewA != nil {
            return nil
        }
        if let image = image, let title = title {
            let button = QXStackButton()
            let imageView = QXImageView()
            imageView.tintColor = tintColor
            imageView.image = image
            let label = QXLabel()
            label.font = font ?? QXFont(14, QXColor.dynamicTitle)
            label.text = title
            label.maxWidth = 100
            button.views = [imageView, label]
            button.minHeight = 32
            leftViewA = button
            return button
        } else if let image = image {
            let button = QXStackButton()
            let imageView = QXImageView()
            imageView.image = image
            button.views = [imageView]
            button.minHeight = 32
            leftViewA = button
            return button
        } else if let title = title {
            let button = QXStackButton()
            let label = QXLabel()
            label.font = font ?? QXFont(14, QXColor.dynamicTitle)
            label.text = title
            label.maxWidth = 100
            button.views = [label]
            button.minHeight = 32
            leftViewA = button
            return button
        }
        return nil
    }
    
    open func autoCheckOrSetDismissButton(image: QXImage?, title: String?, font: QXFont?) -> QXButton? {
        if !isAutoDismiss {
            return nil
        }
        if isDismissAtLeft && leftViewA != nil {
            return nil
        }
        if !isDismissAtLeft && rightViewA != nil {
            return nil
        }
        if let image = image, let title = title {
            let button = QXStackButton()
            let imageView = QXImageView()
            imageView.image = image
            let label = QXLabel()
            label.font = font ?? QXFont(14, QXColor.dynamicTitle)
            label.text = title
            label.maxWidth = 100
            button.views = [imageView, label]
            button.minHeight = 32
            if isDismissAtLeft {
                leftViewA = button
            } else {
                rightViewA = button
            }
            return button
        } else if let image = image {
            let button = QXStackButton()
            let imageView = QXImageView()
            imageView.image = image
            button.views = [imageView]
            button.minHeight = 32
            if isDismissAtLeft {
                leftViewA = button
            } else {
                rightViewA = button
            }
            return button
        } else if let title = title {
            let button = QXStackButton()
            let label = QXLabel()
            label.font = font ?? QXFont(14, QXColor.dynamicTitle)
            label.text = title
            label.maxWidth = 100
            button.views = [label]
            button.minHeight = 32
            if isDismissAtLeft {
                leftViewA = button
            } else {
                rightViewA = button
            }
            return button
        }
        return nil
    }
    
    open func autoCheckOrSetTitleView(title: String?, font: QXFont?) -> QXLabel? {
        if titleView != nil || !isAutoTitle {
            return nil
        }
        if let title = title {
            let label = QXLabel()
            label.alignmentX = .center
            label.font = font ?? QXFont(14, QXColor.dynamicTitle)
            label.text = title
            label.padding = QXEdgeInsets(0, 10, 0, 10)
            titleView = label
            return label
        }
        return nil
    }
    
}
