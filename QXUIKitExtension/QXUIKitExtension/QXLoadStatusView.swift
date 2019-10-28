//
//  QXLoadStatusView.swift
//  QXViewController
//
//  Created by labi3285 on 2019/7/11.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

open class QXLoadStatusView: UIView, QXLoadStatusViewProtocol {
    
    open var topBottomRatio: CGFloat = 1 / 2
        
    open var loadingIcon: QXImage?
//        = QXImage(path: "QXUIKitExtensionResources.bundle/gif.gif").setSize(QXSize(80, 80))
    open var emptyIcon: QXImage?
        = QXImage("QXUIKitExtensionResources.bundle/icon_load_empty")
            .setSize(QXSize(60, 60))
            .setRenderingMode(.alwaysTemplate)
    open var errorIcon: QXImage?
        = QXImage("QXUIKitExtensionResources.bundle/icon_load_failed")
            .setSize(QXSize(60, 60))
            .setRenderingMode(.alwaysTemplate)
    
    // loadingIcon 为nil的时候展示
    open var loadingView: QXActivityIndicatorView = {
        let e = QXActivityIndicatorView(systemView: UIActivityIndicatorView(style: .gray))
        e.margin = QXEdgeInsets(5, 5, 5, 5)
        return e
        }() {
        didSet {
            for view in subviews {
                if view is QXLoadStatusViewProtocol {
                    view.removeFromSuperview()
                }
            }
            addSubview(loadingView)
        }
    }
    
    open var loadingTextFont: QXFont = QXFont(13, "#848484")
    open var emptyTextFont: QXFont = QXFont(13, "#848484")
    open var errorTextFont: QXFont = QXFont(13, "#848484")
    
    open var defaultLoadingText: String? = "加载中"
    open var defaultEmptyText: String? = "暂无内容"
    open var defaultErrorText: String? = "请求失败"
    
    open var imageTextMargin: CGFloat = 10
    
    open var isEmptyRetryEnabled: Bool = false
    open var isRetryButtonShow: Bool = true
    open var isFullScreenRetry: Bool = false
    
    open lazy var iconView: QXImageView = {
        let one = QXImageView()
        one.padding = QXEdgeInsets.zero
        one.qxTintColor = QXColor.fmtHex("#848484")
        one.respondResize = { [weak self] in
            self?.layoutSubviews()
        }
        return one
    }()
    open lazy var contentLabel: QXLabel = {
        let one = QXLabel()
        one.padding = QXEdgeInsets(10, 20, 10, 20)
        one.numberOfLines = 0
        one.alignmentX = .center
        one.alignmentY = .center
        one.respondResize = { [weak self] in
            self?.setNeedsLayout()
        }
        return one
    }()
    public lazy var retryButton: QXTitleButton = {
        let one = QXTitleButton()
        one.backView.qxBorder = QXBorder.border
        one.font = QXFont(14, "#848484")
        one.title = "点击重试"
        one.padding = QXEdgeInsets(7, 10, 7, 10)
        one.titlePadding = QXEdgeInsets(7, 10, 7, 10)
        one.respondResize = { [weak self] in
            self?.setNeedsLayout()
        }
        return one
    }()
    public lazy var stackView: QXStackView = {
        let one = QXStackView()
        one.setupViews([self.loadingView, self.iconView, self.contentLabel, self.retryButton])
        one.isVertical = true
        one.alignmentX = .center
        one.alignmentY = .center
        return one
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(stackView)
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    open override func layoutSubviews() {
        super.layoutSubviews()
        let rect = qxRect.absoluteRect
        contentLabel.intrinsicWidth = rect.w
        let size = stackView.qxIntrinsicContentSize
        let top = (rect.h - size.h) * topBottomRatio / (topBottomRatio + 1)
        stackView.qxRect = rect.insideRect(.top(top), .center, .size(size))
    }
    
    public func qxLoadStatusViewUpdateStatus(_ status: QXLoadStatus) {
        switch status {
        case .ok:
            break
        case .loading(let msg):
            let text = msg ?? defaultLoadingText
            contentLabel.font = loadingTextFont
            contentLabel.text = text ?? ""
            contentLabel.isDisplay = text != nil
            loadingView.isDisplay = loadingIcon == nil
            iconView.isDisplay = loadingIcon != nil
            iconView.image = loadingIcon
            retryButton.isDisplay = false
            if loadingIcon == nil {
                loadingView.startAnimating()
            }
        case .empty(let msg):
            let text = msg ?? defaultEmptyText
            loadingView.stopAnimating()
            contentLabel.font = emptyTextFont
            contentLabel.text = text ?? ""
            loadingView.isHidden = true
            iconView.image = emptyIcon
            loadingView.isDisplay = false
            iconView.isDisplay = emptyIcon != nil
            contentLabel.isDisplay = text != nil
            retryButton.isDisplay = isEmptyRetryEnabled && isRetryButtonShow
        case .error(let err):
            let text = err?.message ?? defaultErrorText
            loadingView.stopAnimating()
            contentLabel.font = errorTextFont
            contentLabel.text = text ?? ""
            loadingView.isDisplay = false
            iconView.image = errorIcon
            iconView.isDisplay = errorIcon != nil
            contentLabel.isDisplay = text != nil
            retryButton.isDisplay = isRetryButtonShow
        }
        qxSetNeedsLayout()
    }

    public func qxLoadStatusViewRetryHandler(_ todo: (() -> ())?) {
        self.retryButton.respondClick = todo
    }
    
}
