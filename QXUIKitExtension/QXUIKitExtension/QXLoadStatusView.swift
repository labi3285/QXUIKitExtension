//
//  QXLoadStatusView.swift
//  QXViewController
//
//  Created by labi3285 on 2019/7/11.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

public enum QXLoadStatus {
    case loading
    case succeed
    case failed(_ err: QXError?)
    case empty(_ msg: String?)
}

public protocol QXLoadStatusViewProtocol {
    func qxLoadStatusViewUpdateStatus(_ status: QXLoadStatus)
    func qxLoadStatusViewRetryHandler(_ todo: (() -> Void)?)
    
    func qxLoadStatusViewLoadingText() -> String?
    func qxLoadStatusViewDefaultErrorText() -> String?
    func qxLoadStatusViewDefaultEmptyText() -> String?
}

public protocol QXcontentViewDelegate: class {
    func qxcontentViewNeedsReloadData()
}

open class QXContentLoadStatusView<Model>: QXView {
        
    public var api: ( (@escaping (QXRequest.Respond<Model>)->() ) -> Void)?
    
    open func loadData(done: @escaping (QXRequest.Respond<Model>) -> Void) {
        if let e = api {
            e(done)
        } else {
            done(.failed(QXError(-1, "请重写loadData或者提供api")))
        }
    }
            
    open func reloadData() {
        weak var ws = self
        _requestId += 1
        let id = _requestId
        ws?.loadStatus = .loading
        loadData { (respond) in
            if id == (ws?._requestId ?? -1) {
                switch respond {
                case .succeed(_):
                    ws?.loadStatus = .succeed
                case .failed(let err):
                    ws?.loadStatus = .failed(err)
                }
            }
        }
    }
    private var _requestId: Int = -1
    
    open var loadStatus: QXLoadStatus = .succeed {
        didSet {
            switch loadStatus {
            case .succeed:
                loadStatusView.isHidden = true
                contentView.isHidden = false
            case .loading:
                loadStatusView.isHidden = false
                contentView.isHidden = true
                loadStatusView.qxLoadStatusViewUpdateStatus(loadStatus)
            case .empty(msg: _):
                loadStatusView.isHidden = false
                contentView.isHidden = true
                loadStatusView.qxLoadStatusViewUpdateStatus(loadStatus)
            case .failed(err: _):
                loadStatusView.isHidden = false
                contentView.isHidden = true
                loadStatusView.qxLoadStatusViewUpdateStatus(loadStatus)
            }
        }
    }
    
    public let contentView: UIView
    public let loadStatusView: UIView & QXLoadStatusViewProtocol
    public required init(contentView: UIView, loadStatusView: UIView & QXLoadStatusViewProtocol) {
        self.contentView = contentView
        self.loadStatusView = loadStatusView
        super.init()
        self.addSubview(contentView)
        self.addSubview(loadStatusView)
        loadStatusView.qxLoadStatusViewRetryHandler { [weak self] in
            self?.reloadData()
        }
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        contentView.qxRect = qxBounds.rectByReduce(padding)
        loadStatusView.qxRect = qxBounds.rectByReduce(padding)
    }
    
    open override func natureContentSize() -> QXSize {
        return loadStatusView.qxIntrinsicContentSize.sizeByAdd(padding)
    }
    
}


open class QXLoadStatusView: UIView {
    
    open var topBottomRatio: CGFloat = 1 / 2
        
    open var loadingIcon: QXImage?
//        = QXImage(path: "QXUIKitExtensionResources.bundle/gif.gif").setSize(QXSize(80, 80))
    open var emptyIcon: QXImage?
        = QXUIKitExtensionResources.shared.image("icon_load_empty")
            .setSize(QXSize(60, 60))
            .setRenderingMode(.alwaysTemplate)
    open var errorIcon: QXImage?
        = QXUIKitExtensionResources.shared.image("icon_load_failed")
            .setSize(QXSize(60, 60))
            .setRenderingMode(.alwaysTemplate)
    
    // loadingIcon 为nil的时候展示
    open var loadingView: QXActivityIndicatorView = {
        let e = QXActivityIndicatorView()
        e.padding = QXEdgeInsets(5, 5, 5, 5)
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
    
    open var loadingTextFont: QXFont = QXFont(13, QXColor.dynamicPlaceHolder)
    open var emptyTextFont: QXFont = QXFont(13, QXColor.dynamicPlaceHolder)
    open var errorTextFont: QXFont = QXFont(13, QXColor.dynamicPlaceHolder)
    
    open var loadingText: String? = nil
    open var defaultEmptyText: String? = "暂无内容"
    open var defaultErrorText: String? = "请求失败"
    
    open var imageTextMargin: CGFloat = 10
    
    open var isEmptyRetryEnabled: Bool = false
    open var isRetryButtonShow: Bool = true
    open var isFullScreenRetry: Bool = false
    
    public final lazy var iconView: QXImageView = {
        let e = QXImageView()
        e.padding = QXEdgeInsets.zero
        e.qxTintColor = QXColor.dynamicPlaceHolder
        e.respondNeedsLayout = { [weak self] in
            self?.layoutSubviews()
        }
        return e
    }()
    public final lazy var contentLabel: QXLabel = {
        let e = QXLabel()
        e.padding = QXEdgeInsets(10, 20, 10, 20)
        e.numberOfLines = 0
        e.alignmentX = .center
        e.alignmentY = .center
        e.respondNeedsLayout = { [weak self] in
            self?.setNeedsLayout()
        }
        return e
    }()
    public final lazy var retryButton: QXTitleButton = {
        let e = QXTitleButton()
        e.backView.qxBorder = QXBorder().setCornerRadius(5)
        e.backView.backColor = QXColor.dynamicButton
        e.font = QXFont(14, QXColor.dynamicButtonText)
        e.title = "点击重试"
        e.padding = QXEdgeInsets(7, 10, 7, 10)
        e.titlePadding = QXEdgeInsets(7, 10, 7, 10)
        e.respondNeedsLayout = { [weak self] in
            self?.setNeedsLayout()
        }
        return e
    }()
    public final lazy var stackView: QXStackView = {
        let e = QXStackView()
        e.views = [self.loadingView, self.iconView, self.contentLabel, self.retryButton]
        e.isVertical = true
        e.alignmentX = .center
        e.alignmentY = .center
        return e
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(stackView)
        self.isHidden = true
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override open func layoutSubviews() {
        super.layoutSubviews()
        let rect = qxRect.absoluteRect
        contentLabel.fixWidth = rect.w
        let size = stackView.natureSize
        let top = (rect.h - size.h) * topBottomRatio / (topBottomRatio + 1)
        stackView.qxRect = rect.insideRect(.top(top), .center, .size(size))
    }
        
}

extension QXLoadStatusView: QXLoadStatusViewProtocol {
    
    public func qxLoadStatusViewUpdateStatus(_ status: QXLoadStatus) {
        switch status {
        case .succeed:
            self.isHidden = true
        case .loading:
            self.isHidden = false
            let text = loadingText
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
            self.isHidden = false
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
        case .failed(let err):
            self.isHidden = false
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
    
    public func qxLoadStatusViewRetryHandler(_ todo: (() -> Void)?) {
        retryButton.respondClick = todo
    }
    
    public func qxLoadStatusViewLoadingText() -> String? {
        return loadingText
    }
    public func qxLoadStatusViewDefaultEmptyText() -> String? {
        return defaultEmptyText
    }
    public func qxLoadStatusViewDefaultErrorText() -> String? {
        return defaultErrorText
    }

 }
