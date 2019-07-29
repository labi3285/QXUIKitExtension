//
//  QXMessageView.swift
//  QXMessageView
//
//  Created by labi3285 on 2017/12/21.
//  Copyright © 2017年 labi3285_lab. All rights reserved.
//

import UIKit

public protocol QXMessageViewContentViewProtocol {
    /// [requried] size for content view
    func qxMessageViewContentViewSizeFor(containerSize: CGSize) -> CGSize
    /// [requried] offset for content view, [0.5,0.5] is for center
    func qxMessageViewContentViewAnchorCenter() -> CGPoint
}

public class QXMessageView: UIControl {
    
    /// create new message view
    public static func messageView(contentView: UIView & QXMessageViewContentViewProtocol, superview: UIView) -> QXMessageView {
        let messageView = QXMessageView(contentView: contentView)
        superview.addSubview(messageView)
        messageView.translatesAutoresizingMaskIntoConstraints = false
        superview.addConstraint(NSLayoutConstraint(item: messageView, attribute: .left, relatedBy: .equal, toItem: superview, attribute: .left, multiplier: 1, constant: 0))
        superview.addConstraint(NSLayoutConstraint(item: messageView, attribute: .right, relatedBy: .equal, toItem: superview, attribute: .right, multiplier: 1, constant: 0))
        superview.addConstraint(NSLayoutConstraint(item: messageView, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1, constant: 0))
        superview.addConstraint(NSLayoutConstraint(item: messageView, attribute: .bottom, relatedBy: .equal, toItem: superview, attribute: .bottom, multiplier: 1, constant: 0))
        return messageView
    }
    
    /// create new message view
    @discardableResult public static func messageView(contentView: UIView & QXMessageViewContentViewProtocol, superview: UIView, duration: TimeInterval, complete: (() -> ())?) -> QXMessageView {
        let messageView = QXMessageView.messageView(contentView: contentView, superview: superview)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration) {
            messageView.remove()
            complete?()
        }
        return messageView
    }
    
    /// remove from inView
    public func remove() {
        removeFromSuperview()
    }
    
    /// message view init
    public required init(contentView: UIView & QXMessageViewContentViewProtocol) {
        self.contentView = contentView
        self.identify = QXMessageView.createNewIdentify()
        super.init(frame: CGRect.zero)
        addSubview(contentView)
    }
    
    public let identify: Int
    private let contentView: UIView & QXMessageViewContentViewProtocol
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override public func layoutSubviews() {
        super.layoutSubviews()
        let containerSize = bounds.size
        let offset = contentView.qxMessageViewContentViewAnchorCenter()
        let size = contentView.qxMessageViewContentViewSizeFor(containerSize: containerSize)
        var x = containerSize.width * offset.x - size.width / 2
        x = max(20, x)
        x = min(containerSize.width - 20 - size.width, x)
        var y = containerSize.height * offset.y - size.height / 2
        y = max(20, y)
        y = min(containerSize.height - 20 - size.height, y)
        contentView.frame = CGRect(x: x, y: y, width: size.width, height: size.height)
    }

    private static var _identify: Int = -1
    private static func createNewIdentify() -> Int {
        _identify += 1
        return _identify
    }
    
}
