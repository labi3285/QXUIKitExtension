//
//  QXRefreshHeader.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/7/23.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit
import MJRefresh

public protocol QXRefreshHeaderDateHandlerProtocol {
    func qxRefreshDateToRichText(_ date: QXDate) -> QXRichText?
}
public struct QXRefreshHeaderDateHandler: QXRefreshHeaderDateHandlerProtocol {
    public func qxRefreshDateToRichText(_ date: QXDate) -> QXRichText? {
        return QXRichText.text(date.string(.nature_chinese, "--"), QXFont(fmt: "14 #333333"))
    }
}

open class QXRefreshHeader: MJRefreshHeader {
    
    public var fixHeight: CGFloat = MJRefreshHeaderHeight {
        didSet {
            QXDebugAssert(fixHeight > 0, "高度为0会导致无法刷新")
        }
    }
    
    public var textNormal: QXRichText?
        = QXRichText.text("下拉可以刷新", QXFont(fmt: "14 #333333"))
    public var textPulling: QXRichText?
        = QXRichText.text("松开立即刷新", QXFont(fmt: "14 #333333"))
    public var textLoading: QXRichText?
        = QXRichText.text("正在刷新数据中...", QXFont(fmt: "14 #333333"))
    public var textDatePrefix: QXRichText?
        = QXRichText.text("上次更新时间：", QXFont(fmt: "14 #333333"))
    
    public var dateHandler: QXRefreshHeaderDateHandlerProtocol = QXRefreshHeaderDateHandler()
    
    public var customizedImageNormal: QXImage?
    public var customizedImagePulling: QXImage?
    public var customizedImageLoading: QXImage?

    public var imageRefreshArrow: QXImage?
        = QXUIKitExtensionResources.shared.image("icon_refresh_arrow").setSize(24, 24)
    
    public lazy var messageLabel: QXLabel = {
        let one = QXLabel()
        one.uiLabel.textAlignment = .center
        return one
    }()
    public lazy var dateLabel: QXLabel = {
        let one = QXLabel()
        one.uiLabel.textAlignment = .center
        return one
    }()
    public lazy var imageView: QXImageView = {
        let one = QXImageView()
        one.padding = QXEdgeInsets(0, 5, 0, 5)
        return one
    }()
    public lazy var arrowView: QXImageView = {
        let one = QXImageView()
        one.qxTintColor = QXColor.fmtHex("#333333")
        one.padding = QXEdgeInsets(0, 5, 0, 5)
        return one
    }()
    public var loadingView: QXActivityIndicatorView = {
        let e = QXActivityIndicatorView(systemView: UIActivityIndicatorView(style: .gray))
        e.margin = QXEdgeInsets(0, 5, 0, 5)
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
    
    open override func prepare() {
        super.prepare()
        mj_h = fixHeight
    }
    
    open override func placeSubviews() {
        super.placeSubviews()
        qxCheckOrAddSubview(loadingView)
        qxCheckOrAddSubview(imageView)
        qxCheckOrAddSubview(arrowView)
        qxCheckOrAddSubview(messageLabel)
        qxCheckOrAddSubview(dateLabel)
        if isCustomised {
            let imageSize = imageView.intrinsicContentSize
            let rect = self.qxBounds
            imageView.qxRect = rect.insideRect(.center, .size(imageSize))
        } else {
            let loadingSize = loadingView.intrinsicContentSize
            let arrowSize = arrowView.intrinsicContentSize
            let messageSize = messageLabel.intrinsicContentSize
            let dateSize = dateLabel.intrinsicContentSize
            let textWidth = max(dateSize.width, messageSize.width)
            let iconWidth = max(arrowSize.width, loadingSize.width)
            let rect = self.qxBounds
            let left = (rect.w - iconWidth - textWidth) / 2
            loadingView.qxRect = rect.insideRect(.left(left), .center, .size(loadingSize))
            arrowView.qxRect = rect.insideRect(.left(left), .center, .size(arrowSize))
            messageLabel.qxRect = rect.insideRect(.left(left + iconWidth), .top(7), .size(textWidth, messageSize.height))
            dateLabel.qxRect = rect.insideRect(.left(left + iconWidth), .bottom(7), .size(textWidth, dateSize.height))
        }
    }
    private var isCustomised: Bool = false
    
    open override var state: MJRefreshState {
        didSet {
            super.state = state
            messageLabel.isDisplay = true
            dateLabel.isDisplay = true
            let date = QXDate(lastUpdatedTime ?? Date())
            if let a = textDatePrefix, let b = dateHandler.qxRefreshDateToRichText(date) {
                dateLabel.richTexts = a + b
            }
            switch state {
            case .refreshing:
                if let e = customizedImageLoading {
                    loadingView.isDisplay = false
                    arrowView.isDisplay = false
                    messageLabel.isDisplay = false
                    dateLabel.isDisplay = false
                    imageView.isDisplay = true
                    imageView.image = e
                    isCustomised = true
                } else {
                    loadingView.startAnimating()
                    loadingView.isDisplay = true
                    arrowView.isDisplay = false
                    messageLabel.richText = textLoading
                    imageView.isDisplay = false
                    isCustomised = false
                }
            case .pulling:
                if let e = customizedImagePulling {
                    loadingView.isDisplay = false
                    arrowView.isDisplay = false
                    messageLabel.isDisplay = false
                    dateLabel.isDisplay = false
                    imageView.isDisplay = true
                    imageView.image = e
                    isCustomised = true
                } else {
                    loadingView.stopAnimating()
                    loadingView.isDisplay = false
                    arrowView.isDisplay = true
                    UIView.animate(withDuration: 0.2) {
                        self.arrowView.transform = CGAffineTransform(rotationAngle: .pi)
                    }
                    arrowView.image = imageRefreshArrow
                    messageLabel.richText = textPulling
                    imageView.isDisplay = false
                    isCustomised = false
                }
            default:
                if let e = customizedImageNormal {
                    loadingView.isDisplay = false
                    arrowView.isDisplay = false
                    messageLabel.isDisplay = false
                    dateLabel.isDisplay = false
                    imageView.isDisplay = true
                    imageView.image = e
                    isCustomised = true
                } else {
                    loadingView.stopAnimating()
                    loadingView.isDisplay = false
                    arrowView.isDisplay = true
                    UIView.animate(withDuration: 0.2) {
                        self.arrowView.transform = CGAffineTransform.identity
                    }
                    arrowView.image = imageRefreshArrow
                    messageLabel.richText = textNormal
                    imageView.isDisplay = false
                    isCustomised = false
                }
            }
        }
    }
    
}

open class QXRefreshFooter: MJRefreshAutoFooter {
    
    public var fixHeight: CGFloat = MJRefreshFooterHeight {
        didSet {
            QXDebugAssert(fixHeight > 0, "高度为0会导致无法刷新")
        }
    }
    
    public var textNormal: QXRichText?
        = QXRichText.text("点击或上拉加载更多", QXFont(fmt: "14 #333333"))
    public var textLoading: QXRichText?
        = QXRichText.text("正在加载更多的数据...", QXFont(fmt: "14 #333333"))
    public var textNoMoreData: QXRichText?
        = QXRichText.text("已经全部加载完毕", QXFont(fmt: "14 #333333"))
    
    public var imageNormal: QXImage?
    public var imageLoading: QXImage?
    public var imageNoMoreData: QXImage?
    
    public lazy var messageLabel: QXLabel = {
        let one = QXLabel()
        return one
    }()
    public lazy var imageView: QXImageView = {
        let one = QXImageView()
        one.padding = QXEdgeInsets(0, 5, 0, 5)
        one.backgroundColor = UIColor.red
        return one
    }()
    public lazy var backButton: QXButton = {
        let one = QXButton()
        one.respondClick = { [weak self] in
            if let s = self, s.state == .idle {
                s.beginRefreshing()
            }
        }
        return one
    }()
    public var loadingView: QXActivityIndicatorView = {
        let e = QXActivityIndicatorView(systemView: UIActivityIndicatorView(style: .gray))
        e.margin = QXEdgeInsets(0, 5, 0, 5)
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
    
    open override func prepare() {
        super.prepare()
        mj_h = fixHeight
    }

    open override func placeSubviews() {
        super.placeSubviews()
        qxCheckOrAddSubview(backButton)
        qxCheckOrAddSubview(loadingView)
        qxCheckOrAddSubview(imageView)
        qxCheckOrAddSubview(messageLabel)
        let loadingSize = loadingView.intrinsicContentSize
        let imageSize = imageView.intrinsicContentSize
        let messageSize = messageLabel.intrinsicContentSize
        let rect = self.qxBounds
        let left = (rect.w - loadingSize.width - messageSize.width - imageSize.width) / 2
        backButton.qxRect = rect
        loadingView.qxRect = backButton.qxRect.insideRect(.left(left), .center, .size(loadingSize))
        imageView.qxRect = loadingView.qxRect.rightRect(.center, .size(imageSize))
        messageLabel.qxRect = imageView.qxRect.rightRect(.center, .size(messageSize))
    }
    
    open override var state: MJRefreshState {
        didSet {
            super.state = state
            switch state {
            case .refreshing:
                messageLabel.richText = textLoading
                messageLabel.isDisplay = imageLoading == nil && textLoading != nil
                imageView.image = imageLoading
                loadingView.startAnimating()
                if imageLoading == nil {
                    loadingView.isDisplay = true
                    imageView.isDisplay = false
                } else {
                    loadingView.isDisplay = false
                    imageView.isDisplay = true
                }
            case .noMoreData:
                messageLabel.richText = textNormal
                messageLabel.isDisplay = imageNoMoreData == nil && textNoMoreData != nil
                imageView.isDisplay = imageNoMoreData != nil
                imageView.image = imageNoMoreData
                loadingView.stopAnimating()
                loadingView.isDisplay = false
            default:
                messageLabel.richText = textNormal
                messageLabel.isDisplay = imageNormal == nil && textNormal != nil
                imageView.isDisplay = imageNormal != nil
                imageView.image = imageNormal
                loadingView.stopAnimating()
                loadingView.isDisplay = false
            }
        }
    }
    
}

extension UIScrollView {
    
    public var qxRefreshHeader: QXRefreshHeader? {
        set {
            mj_header = newValue
        }
        get {
            return mj_header as? QXRefreshHeader
        }
    }
    
    public var qxRefreshFooter: QXRefreshFooter? {
        set {
            mj_footer = newValue
        }
        get {
            return mj_footer as? QXRefreshFooter
        }
    }
    
}

public protocol QXRefreshableViewProtocol {
    func qxDisableAutoInserts()
    func qxUpdateModels(_ models: [Any])
    func qxSetRefreshHeader(_ header: QXRefreshHeader?)
    func qxSetRefreshFooter(_ footer: QXRefreshFooter?)
    func qxReloadData()
}

extension UIScrollView: QXRefreshableViewProtocol {
    @objc public func qxDisableAutoInserts() {
        if #available(iOS 11.0, *) {
            contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
    }
    @objc public func qxUpdateModels(_ models: [Any]) {
        
    }
    @objc public func qxSetRefreshHeader(_ header: QXRefreshHeader?) {
        mj_header = header
    }
    @objc public func qxSetRefreshFooter(_ footer: QXRefreshFooter?) {
        mj_footer = footer
    }
    @objc public func qxReloadData() {
    }
    
}

extension UITableView {
    @objc public override func qxReloadData() {
        reloadData()
    }
}
extension UICollectionView {
    @objc public override func qxReloadData() {
        reloadData()
    }
}
