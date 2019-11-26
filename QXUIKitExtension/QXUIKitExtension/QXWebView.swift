//
//  QXWebView.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/11/22.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit
import WebKit
import QXJSON

open class QXWebViewConfig: NSObject, WKScriptMessageHandler {

    /**
     * js端调用方法：
     * window.webkit.messageHandlers.funcName.postMessage(params);
     */
    
    /// js交互消息
    public var javaScriptBridges: [String: (_ json: QXJSON) -> ()]? {
        didSet {
            wkWebViewConfiguration.userContentController.removeAllUserScripts()
            if let dic = javaScriptBridges {
                for (k, _) in dic {
                    wkWebViewConfiguration.userContentController.add(self, name: k)
                }
            }
        }
    }
    
    public let wkWebViewConfiguration: WKWebViewConfiguration = WKWebViewConfiguration()
    
    open func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        var json = QXJSON()
        if let dic = message.body as? NSDictionary as? [String: Any] {
            json.dictionary = dic
        } else if let arr = message.body as? NSArray {
            json.array = arr as? [Any]
        } else {
            json.string = "\(message.body)"
        }
        QXDebugPrint("jscall-\(message.name):\(json)")
        if let dic = javaScriptBridges {
            for (k, v) in dic {
                if message.name == k {
                    v(json)
                }
            }
        }
    }
    
}

public protocol QXWebViewDelegate: class {
    
    func qxWebViewUpdateTitle(_ title: String?)
    func qxWebViewUpdateContentSize(_ size: CGSize)
    func qxWebViewUpdateEstimatedProgress(_ progress: CGFloat?)
    func qxWebViewUpdateNavigationInfo()
    func qxWebViewDidScroll(_ scrollView: UIScrollView)
    func qxWebViewNavigationBegin()
    func qxWebViewNavigationSucceed()
    func qxWebViewNavigationFailed(_ error: QXError)
    
}

open class QXWebView: QXView {
    
    open var url: QXURL? {
        didSet {
            if let e = url?.nsUrl {
                let r = URLRequest(url: e, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
                wkWebView.load(r)
                delegate?.qxWebViewUpdateNavigationInfo()
            }
        }
    }
    
    public weak var delegate: QXWebViewDelegate?
    
    public func callJavaScriptFunction(_ funcName: String) {
        callJavaScriptFunction(funcName, nil, nil)
    }
    public func callJavaScriptFunction(_ funcName: String, _ json: QXJSON) {
        callJavaScriptFunction(funcName, json, nil)
    }
    public func callJavaScriptFunction(_ funcName: String, _ json: QXJSON?, _ resultHandler: ((_ json: QXJSON) -> ())?) {
        var js: String = funcName
        js += "("
        if let e = json?.jsonString {
            js += e
        }
        js += ");"
        wkWebView.evaluateJavaScript(js) { (data, err) in
            var json = QXJSON()
            if let dic = data as? NSDictionary as? [String: Any] {
                json.dictionary = dic
            } else if let arr = data as? NSArray {
                json.array = arr as? [Any]
            } else {
                if let e = data {
                    json.string = "\(e)"
                }
            }
            resultHandler?(json)
        }
    }

    public var cachePolicy: URLRequest.CachePolicy = .reloadIgnoringCacheData
    public var timeoutInterval: TimeInterval = 30
    
    public let config: QXWebViewConfig
    public final lazy var wkWebView: WKWebView = {
        let e = WKWebView(frame: CGRect.zero, configuration: self.config.wkWebViewConfiguration)
        e.uiDelegate = self
        e.navigationDelegate = self
        e.scrollView.delegate = self
        return e
    }()
    private final lazy var progressView: UIProgressView = { [unowned self] in
         let e = UIProgressView(progressViewStyle: .bar)
         e.backgroundColor = .clear
         e.trackTintColor = .clear
         return e
    }()

    public required init(_ config: QXWebViewConfig) {
        self.config = config
        super.init()
        addSubview(wkWebView)
        addSubview(progressView)
        wkWebView.addObserver(self, forKeyPath: "title", options: .new, context: nil)
        wkWebView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        wkWebView.addObserver(self, forKeyPath: "canGoBack", options: .new, context: nil)
        wkWebView.addObserver(self, forKeyPath: "canGoForward", options: .new, context: nil)
        wkWebView.scrollView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        wkWebView.removeObserver(self, forKeyPath: "title", context: nil)
        wkWebView.removeObserver(self, forKeyPath: "estimatedProgress", context: nil)
        wkWebView.removeObserver(self, forKeyPath: "canGoBack", context: nil)
        wkWebView.removeObserver(self, forKeyPath: "canGoForward", context: nil)
        wkWebView.scrollView.removeObserver(self, forKeyPath: "contentSize", context: nil)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        wkWebView.qxRect = qxBounds.rectByReduce(padding)
    }
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let keyPath = keyPath else {
            return
        }
        if keyPath == "title" {
            delegate?.qxWebViewUpdateTitle(wkWebView.title)
        } else if keyPath == "estimatedProgress" {
            let p = CGFloat(wkWebView.estimatedProgress)
            if p <= 0 || p >= 1 {
                delegate?.qxWebViewUpdateEstimatedProgress(nil)
            } else {
                delegate?.qxWebViewUpdateEstimatedProgress(p)
            }
        } else if keyPath == "contentSize" {
            let wh = wkWebView.scrollView.contentSize
            delegate?.qxWebViewUpdateContentSize(wh)
        } else if keyPath == "canGoBack" || keyPath == "canGoForward" {
            delegate?.qxWebViewUpdateNavigationInfo()
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
}

extension QXWebView: UIScrollViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.qxWebViewDidScroll(scrollView)
    }
    
}

extension QXWebView: WKUIDelegate {
    
//    open func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
//        return WKWebView(frame: CGRect.zero, configuration: configuration)
//    }
//    open func webViewDidClose(_ webView: WKWebView) {
//
//    }
    
    open func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let vc = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        vc.addAction(UIAlertAction(title: "确定", style: UIAlertAction.Style.cancel, handler: { (act) in
            completionHandler()
        }))
        viewController?.present(vc)
    }
    open func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let vc = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        vc.addAction(UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: { (act) in
            completionHandler(false)
        }))
        vc.addAction(UIAlertAction(title: "确定", style: UIAlertAction.Style.default, handler: { (act) in
             completionHandler(true)
        }))
        viewController?.present(vc)
    }
    open func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        let vc = UIAlertController(title: nil, message: prompt, preferredStyle: .alert)
        weak var wkTextField: UITextField?
        vc.addTextField { (textField) in
            textField.placeholder = "点击输入内容"
            textField.text = defaultText
            wkTextField = textField
        }
        vc.addAction(UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: { (act) in
            completionHandler(nil)
        }))
        vc.addAction(UIAlertAction(title: "确定", style: UIAlertAction.Style.default, handler: { (act) in
            completionHandler(wkTextField?.text)
        }))
        viewController?.present(vc)        
    }
    
    
//    open func webView(_ webView: WKWebView, shouldPreviewElement elementInfo: WKPreviewElementInfo) -> Bool {
//        return true
//    }
//    open func webView(_ webView: WKWebView, previewingViewControllerForElement elementInfo: WKPreviewElementInfo, defaultActions previewActions: [WKPreviewActionItem]) -> UIViewController? {
//
//    }
//    open func webView(_ webView: WKWebView, commitPreviewingViewController previewingViewController: UIViewController) {
//
//    }
//    optional func webView(_ webView: WKWebView, contextMenuConfigurationForElement elementInfo: WKContextMenuElementInfo, completionHandler: @escaping (UIContextMenuConfiguration?) -> Void) {
//
//    }
//    open func webView(_ webView: WKWebView, contextMenuWillPresentForElement elementInfo: WKContextMenuElementInfo) {
//
//    }
//    open func webView(_ webView: WKWebView, contextMenuForElement elementInfo: WKContextMenuElementInfo, willCommitWithAnimator animator: UIContextMenuInteractionCommitAnimating) {
//
//    }
//    open func webView(_ webView: WKWebView, contextMenuDidEndForElement elementInfo: WKContextMenuElementInfo) {
//
//    }
    
}

extension QXWebView: WKNavigationDelegate {
    
    open func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(WKNavigationActionPolicy.allow)
    }
    @available(iOS 13.0, *)
    open func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, preferences: WKWebpagePreferences, decisionHandler: @escaping (WKNavigationActionPolicy, WKWebpagePreferences) -> Void) {
        decisionHandler(WKNavigationActionPolicy.allow, preferences)
    }
    open func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(WKNavigationResponsePolicy.allow)
    }
    open func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        delegate?.qxWebViewNavigationBegin()
        delegate?.qxWebViewUpdateNavigationInfo()
    }
    open func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        delegate?.qxWebViewUpdateNavigationInfo()
    }
    open func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        let err = error as NSError
        delegate?.qxWebViewNavigationFailed(QXError(err.code, err.domain))
        delegate?.qxWebViewUpdateNavigationInfo()
        if let url = QXUIKitExtensionResources.shared.url(for: "error.html").nsUrl {
              let request = URLRequest(url: url)
              webView.load(request)
        }
    }
    open func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        delegate?.qxWebViewUpdateNavigationInfo()
    }
    open func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        delegate?.qxWebViewNavigationSucceed()
        delegate?.qxWebViewUpdateNavigationInfo()
    }
    open func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        if let url = QXUIKitExtensionResources.shared.url(for: "error.html").nsUrl {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
//    open func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
//
//    }
//    open func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
//
//    }
    
}
