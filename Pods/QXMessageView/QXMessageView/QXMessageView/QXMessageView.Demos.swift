//
//  QXMessageView.Demos.swift
//  QXMessageView
//
//  Created by labi3285 on 2017/12/21.
//  Copyright © 2017年 labi3285_lab. All rights reserved.
//

import UIKit

extension QXMessageView {
    
    public static func demoLoading(msg: String?, superview: UIView) -> QXMessageView {
        let contentView = QXMessageView.DemoLoadingView()
        contentView.text = msg
        return messageView(contentView: contentView, superview: superview)
    }
    
    @discardableResult public static func demoSuccess(msg: String, superview: UIView, duration: TimeInterval? = nil, complete: (() -> ())? = nil) -> QXMessageView {
        let contentView = QXMessageView.DemoIconTextView()
        contentView.icon = QXMessageView._kDemoSuccessIcon
        contentView.text = msg
        let _duration: TimeInterval
        if let e = duration {
            _duration = e
        } else {
            var n: TimeInterval = 0
            for e in msg {
                if e.isASCII {
                    n += 1
                } else {
                    n += 2
                }
            }
            _duration = min(max(2 * n / 16, 1.5), 6)
        }
        return messageView(contentView: contentView, superview: superview, duration: _duration, complete: complete)
    }
    
    @discardableResult public static func demoFailure(msg: String, superview: UIView, duration: TimeInterval? = nil, complete: (() -> ())? = nil) -> QXMessageView {
        let contentView = QXMessageView.DemoIconTextView()
        contentView.icon = QXMessageView._kDemoFailureIcon
        contentView.text = msg
        let _duration: TimeInterval
        if let e = duration {
            _duration = e
        } else {
            var n: TimeInterval = 0
            for e in msg {
                if e.isASCII {
                    n += 1
                } else {
                    n += 2
                }
            }
            _duration = min(max(2 * n / 16, 1.5), 6)
        }
        return messageView(contentView: contentView, superview: superview, duration: _duration, complete: complete)
    }
    
    @discardableResult public static func demoWarning(msg: String, superview: UIView, duration: TimeInterval? = nil, complete: (() -> ())? = nil) -> QXMessageView {
        let contentView = QXMessageView.DemoIconTextView()
        contentView.icon = QXMessageView._kDemoWarningIcon
        contentView.text = msg
        let _duration: TimeInterval
        if let e = duration {
            _duration = e
        } else {
            _duration = min(max(2 * TimeInterval(msg.count) / 8, 1.5), 6)
        }
        return messageView(contentView: contentView, superview: superview, duration: _duration, complete: complete)
    }

    public class DemoIconTextView: MessageView, QXMessageViewContentViewProtocol {
        public var text: String? {
            didSet {
                _messageLabel.text = text
            }
        }
        public var icon: UIImage? {
            didSet {
                _iconView.image = icon
            }
        }
        private let _kLeftRightMargin: CGFloat = 15
        private let _kTopBottomMargin: CGFloat = 15
        private let _kIconTextMargin: CGFloat = 10
        private let _kIconWidthHeight: CGFloat = 18
        private let _kContentTopBottomMinMargin: CGFloat = 20
        private let _kContentLeftRightMinMargin: CGFloat = 20
        private lazy var _iconView: UIImageView = {
            let one = UIImageView()
            return one
        }()
        private lazy var _messageLabel: UILabel = {
            let one = UILabel()
            one.font = UIFont.boldSystemFont(ofSize: 15)
            one.textColor = UIColor.white
            one.numberOfLines = 0
            return one
        }()
        public required init() {
            super.init()
            addSubview(_iconView)
            addSubview(_messageLabel)
        }
        public required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        public override func layoutSubviews() {
            super.layoutSubviews()
            do {
                let w: CGFloat = _kIconWidthHeight
                let h: CGFloat = _kIconWidthHeight
                let x: CGFloat = _kLeftRightMargin
                let y = (bounds.height - h) / 2
                _iconView.frame = CGRect(x: x, y: y, width: w, height: h)
            }
            do {
                let x = _iconView.frame.maxX + _kIconTextMargin
                let y: CGFloat = 0
                let w: CGFloat = bounds.width - x - _kLeftRightMargin
                let h: CGFloat = bounds.height
                _messageLabel.frame = CGRect(x: x, y: y, width: w, height: h)
            }
        }
        public func qxMessageViewContentViewSizeFor(containerSize: CGSize) -> CGSize {
            _messageLabel.text = text
            let textMaxWidth = containerSize.width - _kLeftRightMargin * 2 - _kIconWidthHeight - _kIconTextMargin
            _messageLabel.frame = CGRect(x: 0, y: 0, width: textMaxWidth, height: 0)
            _messageLabel.sizeToFit()
            let textSize = _messageLabel.frame.size
            let w = min(textSize.width + _kIconTextMargin + _kIconWidthHeight + _kLeftRightMargin * 2, containerSize.width - _kContentLeftRightMinMargin * 2)
            let h = min(textSize.height + _kTopBottomMargin * 2, containerSize.height - _kContentTopBottomMinMargin * 2)
            return CGSize(width: w, height: h)
        }
        public func qxMessageViewContentViewAnchorCenter() -> CGPoint {
            return CGPoint(x: 0.5, y: 0.5)
        }
    }
    
    public class DemoLoadingView: MessageView, QXMessageViewContentViewProtocol {
        public var text: String? {
            didSet {
                _messageLabel.text = text
                _indicatorView.startAnimating()
            }
        }
        private let _kLeftRightMargin: CGFloat = 15
        private let _kTopBottomMargin: CGFloat = 15
        private let _kTextIndicatorMargin: CGFloat = 10
        private let _kIndicatorWidthHeight: CGFloat = 18
        private let _kContentTopBottomMinMargin: CGFloat = 20
        private let _kContentLeftRightMinMargin: CGFloat = 20
        private lazy var _indicatorView: UIActivityIndicatorView = {
            let one = UIActivityIndicatorView(style: .white)
            return one
        }()
        private lazy var _messageLabel: UILabel = {
            let one = UILabel()
            one.font = UIFont.boldSystemFont(ofSize: 15)
            one.textColor = UIColor.white
            one.numberOfLines = 0
            return one
        }()
        public required init() {
            super.init()
            addSubview(_indicatorView)
            addSubview(_messageLabel)
        }
        public required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        public override func layoutSubviews() {
            super.layoutSubviews()
            do {
                let w: CGFloat = _kIndicatorWidthHeight
                let h: CGFloat = _kIndicatorWidthHeight
                let x: CGFloat = _kLeftRightMargin
                let y = (bounds.height - h) / 2
                _indicatorView.frame = CGRect(x: x, y: y, width: w, height: h)
            }
            do {
                let x = _indicatorView.frame.maxX + _kTextIndicatorMargin
                let y: CGFloat = 0
                let w: CGFloat = bounds.width - x - _kLeftRightMargin
                let h: CGFloat = bounds.height
                _messageLabel.frame = CGRect(x: x, y: y, width: w, height: h)
            }
        }
        public func qxMessageViewContentViewSizeFor(containerSize: CGSize) -> CGSize {
            _messageLabel.text = text
            if text == nil {
                _messageLabel.sizeToFit()
                let w = _kLeftRightMargin * 2 + _kIndicatorWidthHeight
                let h = _kTopBottomMargin * 2 + _kIndicatorWidthHeight
                return CGSize(width: w, height: h)
            } else {
                _messageLabel.sizeToFit()
                let textSize = _messageLabel.frame.size
                let w = min(textSize.width + _kTextIndicatorMargin + _kIndicatorWidthHeight + _kLeftRightMargin * 2, containerSize.width - _kContentLeftRightMinMargin * 2)
                let h = min(textSize.height + _kTopBottomMargin * 2, containerSize.height - _kContentTopBottomMinMargin * 2)
                return CGSize(width: w, height: h)
            }
        }
        public func qxMessageViewContentViewAnchorCenter() -> CGPoint {
            return CGPoint(x: 0.5, y: 0.5)
        }
    }
    
    public class MessageView: UIView {
        public required init() {
            super.init(frame: CGRect.zero)
            backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
            clipsToBounds = true
        }
        public required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        public override func layoutSubviews() {
            super.layoutSubviews()
            layer.cornerRadius = min(3, min(bounds.width, bounds.height) / 2)
        }
    }
    
    private static let _kDemoSuccessIcon: UIImage = {
        var path = Bundle(for: QXMessageView.self).path(forResource: "QXMessageView.Demo.bundle", ofType: nil)!
        let bundle = Bundle(path: path)!
        return UIImage(named: "icon_succeed", in: bundle, compatibleWith: nil)!
    }()
    private static let _kDemoFailureIcon: UIImage = {
        var path = Bundle(for: QXMessageView.self).path(forResource: "QXMessageView.Demo.bundle", ofType: nil)!
        let bundle = Bundle(path: path)!
        return UIImage(named: "icon_failed", in: bundle, compatibleWith: nil)!
    }()
    private static let _kDemoWarningIcon: UIImage = {
        var path = Bundle(for: QXMessageView.self).path(forResource: "QXMessageView.Demo.bundle", ofType: nil)!
        let bundle = Bundle(path: path)!
        return UIImage(named: "icon_warning", in: bundle, compatibleWith: nil)!
    }()
    
}
