//
//  QXWebViewController.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/11/22.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

class QXWebViewController: QXViewController, QXWebViewDelegate {

    public convenience required init() {
        self.init(QXWebViewConfig())
    }
    
    public required init(_ config: QXWebViewConfig) {
        self.webView = QXWebView(config)
        super.init()
        self.webView.delegate = self
        self.webView.extendHeight = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public final lazy var progressView: UIProgressView = { [unowned self] in
        let e = UIProgressView(progressViewStyle: .bar)
        e.qxTintColor = QXColor.dynamicAccent
        e.backgroundColor = .clear
        e.trackTintColor = .clear
        return e
    }()
    public let webView: QXWebView
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
                if s.webView.wkWebView.canGoBack {
                    s.webView.wkWebView.goBack()
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
                if s.webView.wkWebView.canGoForward {
                    s.webView.wkWebView.goForward()
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
        e.setupViews(self.backButton, QXSpace(20), self.forwardButton)
        if QXDevice.isLiuHaiScreen {
            e.padding = QXEdgeInsets(5, 15, 30, 15)
        } else {
            e.padding = QXEdgeInsets(5, 15, 5, 15)
        }
        return e
    }()
    
    public func goBack() {
        if webView.wkWebView.canGoBack {
            webView.wkWebView.goBack()
        }
    }
    public func refresh() {
        webView.wkWebView.reload()
    }
    
//    override func shouldPop() -> Bool {
//        if webView.wkWebView.canGoBack {
//            webView.wkWebView.goBack()
//            return false
//        }
//        return true
//    }
    
//    private func tryShowBottomView(animated: Bool) {
//        var h: CGFloat = 0
//        if !isForceBottomViewShow && !backButton.isEnabled && !forwardButton.isEnabled {
//            h = bottomView.natureContentSize().h
//        }
//        navigationBottomCons?.constant = h
//        if animated {
//            if isBottomViewShow {
//                return
//            }
//            weak var ws = self
//            UIView.animate(withDuration: 0.3, animations: {
//                ws?.view.layoutIfNeeded()
//            }) { (c) in
//                ws?.isBottomViewShow = true
//            }
//        } else {
//            var h: CGFloat = 0
//            if !isForceBottomViewShow && !backButton.isEnabled && !forwardButton.isEnabled {
//                h = bottomView.natureContentSize().h
//            }
//            view.layoutIfNeeded()
//            isBottomViewShow = true
//        }
//    }
//    private func tryHideBottomView(animated: Bool) {
//        let h = bottomView.natureContentSize().h
//        navigationBottomCons?.constant = h
//        if animated {
//            if !isBottomViewShow {
//                return
//            }
//            if isForceBottomViewShow {
//                navigationBottomCons?.constant = 0
//                view.layoutIfNeeded()
//                return
//            }
//            weak var ws = self
//            UIView.animate(withDuration: 0.3, animations: {
//                ws?.view.layoutIfNeeded()
//            }) { (c) in
//                ws?.isBottomViewShow = false
//            }
//        } else {
//            view.layoutIfNeeded()
//            isBottomViewShow = false
//        }
//    }
//    public private(set) var isBottomViewShow: Bool = false
//    public private(set) var isForceBottomViewShow: Bool = true
        
    private var navigationBottomCons: NSLayoutConstraint?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
        view.addSubview(progressView)
        view.addSubview(bottomView)
        
        progressView.IN(view).LEFT.RIGHT.TOP.HEIGHT(1.5).MAKE()
        webView.IN(view).LEFT.RIGHT.TOP.MAKE()
        webView.BOTTOM.EQUAL(bottomView).TOP.MAKE()
        bottomView.IN(view).LEFT.RIGHT.MAKE()
        navigationBottomCons = bottomView.BOTTOM.EQUAL(view).OFFSET(bottomView.natureContentSize().h).MAKE()
    }
    
    //MARK:- QXWebViewDelegate
    open func qxWebViewUpdateTitle(_ title: String?) {
        self.title = title
    }
    open func qxWebViewUpdateEstimatedProgress(_ progress: CGFloat?) {
        progressView.isHidden = progress == nil
        progressView.progress = Float(progress ?? 0)
    }
    open func qxWebViewUpdateContentSize(_ size: CGSize) {
//        if size.height <= webView.wkWebView.scrollView.bounds.height + 10 {
//            isForceBottomViewShow = webView.wkWebView.canGoBack || webView.wkWebView.canGoForward
//            tryShowBottomView(animated: false)
//        } else {
//            isForceBottomViewShow = false
//        }
    }
    open func qxWebViewDidScroll(_ scrollView: UIScrollView) {
//        if scrollView.panGestureRecognizer.velocity(in: scrollView).y > 5 {
//            tryShowBottomView(animated: true)
//        } else if scrollView.panGestureRecognizer.velocity(in: scrollView).y < -5 {
//            tryHideBottomView(animated: true)
//        }
    }
    open func qxWebViewUpdateNavigationInfo() {
        backButton.isEnabled = webView.wkWebView.canGoBack
        forwardButton.isEnabled = webView.wkWebView.canGoForward
        var h = bottomView.natureContentSize().h
        if webView.wkWebView.canGoBack || webView.wkWebView.canGoForward {
            h = 0
        }
        navigationBottomCons?.constant = h
        view.setNeedsLayout()
    }
    open func qxWebViewNavigationBegin() {
        
    }
    open func qxWebViewNavigationSucceed() {

    }
    open func qxWebViewNavigationFailed(_ error: QXError) {

    }

}
