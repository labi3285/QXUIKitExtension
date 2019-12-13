//
//  QXNavigationWebView.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/12/12.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

open class QXNavigationWebView: QXWebView, QXWebViewDelegate {
    
    public var respondTitle: ((String?) -> ())?
    
    public required init(_ config: QXWebViewConfig) {
        super.init(config)
        addSubview(loadStatusView)
        addSubview(progressView)
        addSubview(bottomView)
        self.delegate = self
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        let rect = qxBounds.rectByReduce(padding)
        let progressH: CGFloat = 1.5
        var bottomH: CGFloat = 0
        if wkWebView.canGoBack || wkWebView.canGoForward {
            bottomH = bottomView.natureContentSize().h
            bottomView.qxRect = rect.insideRect(.left(0), .right(0), .bottom(0), .height(bottomH))
        }
        progressView.qxRect = rect.insideRect(.left(0), .right(0), .top(0), .height(progressH))
        wkWebView.qxRect = rect.insideRect(.left(0), .right(0), .top(0), .bottom(bottomH))
    }
    
    public final lazy var progressView: UIProgressView = {
        let e = UIProgressView(progressViewStyle: .bar)
        e.qxTintColor = QXColor.dynamicAccent
        e.backgroundColor = .clear
        e.trackTintColor = .clear
        return e
    }()
    public final lazy var loadStatusView: QXLoadStatusView = {
        let e = QXLoadStatusView()
        e.qxBackgroundColor = QXColor.white
        e.qxLoadStatusViewRetryHandler { [weak self] in
            self?.reloadData()
        }
        e.qxLoadStatusViewUpdateStatus(.succeed)
        return e
    }()

    public final lazy var backButton: QXImageButton = {
        let e = QXImageButton()
        e.fixSize = QXSize(35, 35)
        e.padding = QXEdgeInsets(5, 5, 5, 5)
        e.qxTintColor = QXColor.dynamicIndicator
        e.image = QXUIKitExtensionResources.shared.image("icon_backward")
            .setRenderingMode(.alwaysTemplate)
        e.isEnabled = false
        e.respondClick = { [weak self] in
            if let s = self {
                if s.wkWebView.canGoBack {
                    s.wkWebView.goBack()
                }
            }
        }
        return e
    }()
    public final lazy var forwardButton: QXImageButton = {
        let e = QXImageButton()
        e.fixSize = QXSize(35, 35)
        e.padding = QXEdgeInsets(5, 5, 5, 5)
        e.qxTintColor = QXColor.dynamicIndicator
        e.image = QXUIKitExtensionResources.shared.image("icon_forward")
            .setRenderingMode(.alwaysTemplate)
        e.isEnabled = false
        e.respondClick = { [weak self] in
            if let s = self {
                if s.wkWebView.canGoForward {
                    s.wkWebView.goForward()
                }
            }
        }
        return e
    }()
    public final lazy var bottomView: QXStackView = {
        let e = QXStackView()
        e.qxBackgroundColor = QXColor.dynamicBar
        e.viewMargin = 10
        e.alignmentX = .center
        e.views = [self.backButton, QXSpace(20), self.forwardButton]
        e.padding = QXEdgeInsets(5, 15, 5, 15)
        return e
    }()
    
    public func goBack() {
        if wkWebView.canGoBack {
            wkWebView.goBack()
        }
    }
    public func refresh() {
        wkWebView.reload()
    }
    
    //MARK:- QXWebViewDelegate
    open func qxWebViewUpdateTitle(_ title: String?) {
        respondTitle?(title)
    }
    open func qxWebViewUpdateEstimatedProgress(_ progress: CGFloat?) {
        progressView.isHidden = progress == nil
        progressView.progress = Float(progress ?? 0)
    }
    open func qxWebViewUpdateContentSize(_ size: CGSize) {
    }
    open func qxWebViewDidScroll(_ scrollView: UIScrollView) {
    }
    open func qxWebViewUpdateNavigationInfo() {
        backButton.isEnabled = wkWebView.canGoBack
        forwardButton.isEnabled = wkWebView.canGoForward
        qxSetNeedsLayout()
    }
    open func qxWebViewNavigationBegin() {
        loadStatusView.isHidden = true
    }
    open func qxWebViewNavigationSucceed() {
        loadStatusView.isHidden = true
    }
    open func qxWebViewNavigationFailed(_ error: QXError) {
        if error.code >= "400" {
            loadStatusView.isHidden = false
            loadStatusView.errorIcon = QXRichText.text("\(error.code)", QXFont(35, "#333333")).qxImage
            loadStatusView.qxLoadStatusViewUpdateStatus(.failed(error))
        } else {
            loadStatusView.isHidden = true
        }
    }
    
}
