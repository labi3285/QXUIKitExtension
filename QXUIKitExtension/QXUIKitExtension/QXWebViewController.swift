//
//  QXWebViewController.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/11/22.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

open class QXWebViewController: QXViewController {

    public let webView: QXNavigationWebView

    public override convenience init() {
        self.init(QXWebViewConfig())
    }
    public required init(_ config: QXWebViewConfig) {
        self.webView = QXNavigationWebView(config)
        if QXDevice.isLiuHaiScreen {
            self.webView.padding = QXEdgeInsets(0, 0, 25, 0)
        }
        super.init()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        view.qxBackgroundColor = QXColor.white
        view.addSubview(webView)
        webView.IN(view).LEFT.RIGHT.TOP.BOTTOM.MAKE()
    }

}
