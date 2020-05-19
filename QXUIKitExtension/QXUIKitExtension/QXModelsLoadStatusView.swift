//
//  QXModelsLoadStatusView.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/10/31.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

public enum QXModelsLoadStatus {
    case reload(_ status: QXLoadStatus)
    case page(_ status: QXModelsPageStatus)
    public var isRefresh: Bool {
        switch self {
        case .page(status: let s):
            switch s {
            case .refreshing, .refreshOk, .refreshError(_):
                return true
            default:
                return false
            }
        case .reload(_):
            return true
        }
    }
}

public enum QXModelsPageStatus {
    case refreshing
    case refreshOk
    case refreshError(_ err: QXError?)
    case paging
    case pageOk
    case pageError(_ err: QXError?)
    case pageEmpty(_ msg: String?)
    case pageNoMore(_ msg: String?)
}

public enum QXModelsLoadType {
    case load
    case reload
    case refresh
    case page
}

open class QXModelsLoadStatusView<Model>: QXView {
        
    public var api: ((QXFilter, @escaping (QXRequest.RespondPage<Model>) -> Void) -> Void)?
            
    open func loadData(_ filter: QXFilter, _ done: @escaping (QXRequest.RespondPage<Model>) -> Void) {
        if let e = api {
            e(filter, done)
        } else {
            done(.failed(QXError(-1, "请重写loadData或者提供api")))
        }
    }
    
    open func loadData() {
        filter.page = isPageStartFromZero ? 0 : 1
        models = []
        contentView.qxResetOffset()
        modelsLoadStatus = .reload(.loading)
        loadModels(QXModelsLoadType.load)
    }
    open func reloadData() {
        filter.page = isPageStartFromZero ? 0 : 1
        models = []
        contentView.qxResetOffset()
        modelsLoadStatus = .reload(.loading)
        loadModels(QXModelsLoadType.reload)
    }
    
    /// 设置这个参数，直接展示
    public var staticModels: [Model]? {
        didSet {
            contentView.qxUpdateModels(staticModels ?? [])
        }
    }
    
    /// 自动设置models
    open var models: [Model] = [] {
        didSet {
            if staticModels == nil {
                contentView.qxUpdateModels(models)
            }
        }
    }
    
    open func loadModels(_ loadType: QXModelsLoadType) {
        weak var ws = self
        _requestId += 1
        let id = _requestId
        loadData(filter) { (respond) in
            if id == (ws?._requestId ?? -1) {
                switch respond {
                case .succeed(let ms, let isThereMore):
                    ws?.onLoadModelsOk(ms, isThereMore: isThereMore)
                case .failed(let err):
                    ws?.onLoadModelsFailed(err)
                }
            }
        }
    }
    private var _requestId: Int = -1
    private var _isInitializeRequest: Int = -1

    public var filter: QXFilter = QXFilter()
    public var isPageStartFromZero: Bool = true

    public let loadStatusView: UIView & QXLoadStatusViewProtocol
    public let contentView: UIView & QXRefreshableViewProtocol
    public required init(contentView: UIView & QXRefreshableViewProtocol, loadStatusView: UIView & QXLoadStatusViewProtocol) {
        self.contentView = contentView
        self.loadStatusView = loadStatusView
        super.init()
        self.addSubview(contentView)
        contentView.qxAddSubviewToRefreshableView(loadStatusView)
        loadStatusView.qxLoadStatusViewRetryHandler { [weak self] in
            self?.reloadData()
        }
        contentView.qxDisableAutoInserts()
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        contentView.qxRect = qxBounds.rectByReduce(padding)
        loadStatusView.qxRect = contentView.qxBounds
    }

    open override func natureContentSize() -> QXSize {
        return loadStatusView.intrinsicContentSize.qxSize.sizeByAdd(padding)
    }

    /// 是否可以下拉刷新
    public var canRefresh: Bool = false {
        didSet {
            if canRefresh {
                contentView.qxSetRefreshHeader(refreshHeader)
            } else {
                contentView.qxSetRefreshHeader(nil)
            }
        }
    }
    
    /// 是否可以上拉刷新
    public var canPage: Bool = false {
        didSet {
            contentView.qxSetRefreshFooter(canPage ? refreshFooter : nil)
        }
    }
    
    public final lazy var refreshFooter: QXRefreshFooter = {
        let e = QXRefreshFooter(refreshingBlock: {  [weak self] in
            self?.footerStartRefresh()
        })!
        return e
    }()
    
    public final lazy var refreshHeader: QXRefreshHeader = {
        let e = QXRefreshHeader(refreshingBlock: {  [weak self] in
            self?.headerStartRefresh()
        })!
        return e
    }()

    public private(set) var modelsLoadStatus: QXModelsLoadStatus = .reload(.succeed) {
        didSet {
            func updateStatic() {
                loadStatusView.qxLoadStatusViewUpdateStatus(.succeed)
                switch modelsLoadStatus {
                case .reload(status: let s):
                    refreshHeader.endRefreshing()
                    refreshFooter.endRefreshing()
                    refreshFooter.resetNoMoreData()
                    switch s {
                    case .loading:
                        contentView.qxSetRefreshHeader(nil)
                        contentView.qxSetRefreshFooter(nil)
                        showLoading(msg: loadStatusView.qxLoadStatusViewLoadingText())
                    case .empty(_):
                        contentView.qxSetRefreshHeader(canRefresh ? refreshHeader : nil)
                        contentView.qxSetRefreshFooter(nil)
                        hideLoading()
                    case .failed(let err):
                        contentView.qxSetRefreshHeader(canRefresh ? refreshHeader : nil)
                        contentView.qxSetRefreshFooter(nil)
                        hideLoading()
                        showFailure(msg: err?.message ?? loadStatusView.qxLoadStatusViewDefaultErrorText() ?? "请求出错")
                    case .succeed:
                        contentView.qxSetRefreshHeader(canRefresh ? refreshHeader : nil)
                        contentView.qxSetRefreshFooter(canPage ? refreshFooter : nil)
                        hideLoading()
                    }
                case .page(let s):
                    hideLoading()
                    switch s {
                    case .refreshing:
                        refreshHeader.beginRefreshing()
                        refreshFooter.resetNoMoreData()
                        contentView.qxSetRefreshFooter(nil)
                    case .refreshOk:
                        refreshHeader.endRefreshing()
                        contentView.qxSetRefreshFooter(canPage ? refreshFooter : nil)
                    case .refreshError(let err):
                        showFailure(msg: err?.message ?? loadStatusView.qxLoadStatusViewDefaultErrorText() ?? "请求出错")
                        refreshHeader.endRefreshing()
                        contentView.qxSetRefreshFooter(canPage ? refreshFooter : nil)
                    case .paging:
                        refreshFooter.beginRefreshing()
                        contentView.qxSetRefreshHeader(nil)
                    case .pageError(let err):
                        showFailure(msg: err?.message ?? loadStatusView.qxLoadStatusViewDefaultErrorText() ?? "请求出错")
                        refreshFooter.endRefreshing()
                        contentView.qxSetRefreshHeader(canRefresh ? refreshHeader : nil)
                    case .pageOk:
                        refreshFooter.endRefreshing()
                        contentView.qxSetRefreshHeader(canRefresh ? refreshHeader : nil)
                    case .pageEmpty(msg: _):
                        refreshFooter.endRefreshingWithNoMoreData()
                        contentView.qxSetRefreshHeader(canRefresh ? refreshHeader : nil)
                    case .pageNoMore(_):
                        refreshHeader.endRefreshing()
                        refreshFooter.endRefreshingWithNoMoreData()
                        contentView.qxSetRefreshHeader(canRefresh ? refreshHeader : nil)
                    }
                }
            }
            
            func updateNormal() {
                switch modelsLoadStatus {
                case .reload(status: let s):
                    refreshHeader.endRefreshing()
                    refreshFooter.endRefreshing()
                    refreshFooter.resetNoMoreData()
                    loadStatusView.qxLoadStatusViewUpdateStatus(s)
                    switch s {
                    case .loading:
                        contentView.qxSetRefreshHeader(nil)
                        contentView.qxSetRefreshFooter(nil)
                    case .empty(_), .failed(_):
                        contentView.qxSetRefreshHeader(canRefresh ? refreshHeader : nil)
                        contentView.qxSetRefreshFooter(nil)
                    case .succeed:
                        contentView.qxSetRefreshHeader(canRefresh ? refreshHeader : nil)
                        contentView.qxSetRefreshFooter(canPage ? refreshFooter : nil)
                    }
                case .page(let s):
                    if models.count == 0 {
                        switch s {
                        case .refreshing:
                            loadStatusView.qxLoadStatusViewUpdateStatus(.loading)
                            refreshHeader.beginRefreshing()
                            refreshFooter.resetNoMoreData()
                            contentView.qxSetRefreshFooter(nil)
                        case .refreshOk:
                            loadStatusView.qxLoadStatusViewUpdateStatus(.succeed)
                            refreshHeader.endRefreshing()
                            contentView.qxSetRefreshFooter(canPage ? refreshFooter : nil)
                        case .refreshError(let err):
                            loadStatusView.qxLoadStatusViewUpdateStatus(.failed(err))
                            refreshHeader.endRefreshing()
                            contentView.qxSetRefreshFooter(nil)
                        default:
                            QXDebugFatalError("no go here")
                        }
                    } else {
                        loadStatusView.qxLoadStatusViewUpdateStatus(.succeed)
                        contentView.qxSetRefreshFooter(canPage ? refreshFooter : nil)
                        switch s {
                        case .refreshing:
                            if models.count == 0 {
                                loadStatusView.qxLoadStatusViewUpdateStatus(.loading)
                            } else {
                                loadStatusView.qxLoadStatusViewUpdateStatus(.succeed)
                            }
                            refreshHeader.beginRefreshing()
                            refreshFooter.resetNoMoreData()
                            contentView.qxSetRefreshFooter(nil)
                        case .refreshOk:
                            refreshHeader.endRefreshing()
                            contentView.qxSetRefreshFooter(canPage ? refreshFooter : nil)
                        case .refreshError(let err):
                            if let e = err?.message {
                                showFailure(msg: e)
                            }
                            refreshHeader.endRefreshing()
                            contentView.qxSetRefreshFooter(canPage ? refreshFooter : nil)
                        case .paging:
                            refreshFooter.beginRefreshing()
                            contentView.qxSetRefreshHeader(nil)
                        case .pageError(let err):
                            showFailure(msg: err?.message ?? loadStatusView.qxLoadStatusViewDefaultErrorText() ?? "请求出错")
                            refreshFooter.endRefreshing()
                            contentView.qxSetRefreshHeader(canRefresh ? refreshHeader : nil)
                        case .pageOk:
                            refreshFooter.endRefreshing()
                            contentView.qxSetRefreshHeader(canRefresh ? refreshHeader : nil)
                        case .pageEmpty(msg: _):
                            refreshFooter.endRefreshingWithNoMoreData()
                            contentView.qxSetRefreshHeader(canRefresh ? refreshHeader : nil)
                        case .pageNoMore(_):
                            refreshHeader.endRefreshing()
                            refreshFooter.endRefreshingWithNoMoreData()
                            contentView.qxSetRefreshHeader(canRefresh ? refreshHeader : nil)
                        }
                    }
                }
            }
            
            if staticModels == nil {
                updateNormal()
            } else {
                updateStatic()
            }

        }
    }

    open func headerStartRefresh() {
        filter.page = isPageStartFromZero ? 0 : 1
        modelsLoadStatus = .page(.refreshing)
        loadModels(.refresh)
    }
    open func footerStartRefresh() {
        modelsLoadStatus = .page(.paging)
        loadModels(.page)
    }

    /// 拿到分页数据的界面更新
    open func onLoadModelsOk(_ newModels: [Model], isThereMore: Bool? = nil) {
        let statusBefore = modelsLoadStatus
        if canPage {
            if statusBefore.isRefresh {
                models = newModels
            } else {
                models += newModels
            }
            filter.page += 1
            let isThereMore = isThereMore ?? (newModels.count > 0)
            switch statusBefore {
            case .reload(status: _):
                if models.count > 0 {
                    if isThereMore {
                        modelsLoadStatus = .reload(.succeed)
                    } else {
                        modelsLoadStatus = .page(.pageNoMore("没有更多内容"))
                    }
                } else {
                    modelsLoadStatus = .reload(.empty(nil))
                }
            case .page(status: let s):
                switch s {
                case .refreshing:
                    if models.count > 0 {
                        if isThereMore {
                            modelsLoadStatus = .page(.refreshOk)
                        } else {
                            modelsLoadStatus = .page(.pageNoMore("没有更多内容"))
                        }
                    } else {
                        modelsLoadStatus = .reload(.empty(nil))
                    }
                case .paging:
                    if models.count > 0 {
                        if isThereMore {
                            modelsLoadStatus = .page(.pageOk)
                        } else {
                            modelsLoadStatus = .page(.pageNoMore("没有更多内容"))
                        }
                    } else {
                        modelsLoadStatus = .reload(.empty(nil))
                    }
                default:
                    QXDebugFatalError("初始化状态只能有reload、paging、refreshing三种")
                }
            }
            
        } else {
            models = newModels
            switch statusBefore {
            case .page(status: let s):
                switch s {
                case .refreshing:
                    if models.count > 0 {
                        modelsLoadStatus = .reload(.succeed)
                    } else {
                        modelsLoadStatus = .reload(.empty(nil))
                    }
                default:
                    QXDebugFatalError("请设置canPage=true")
                }
            case .reload(status: _):
                if models.count > 0 {
                    modelsLoadStatus = .reload(.succeed)
                } else {
                    modelsLoadStatus = .reload(.empty(nil))
                }
            }
        }
    }
    
    /// 分页报错处理的界面更新
    open func onLoadModelsFailed(_ err: QXError?) {
        let statusBefore = modelsLoadStatus
        switch statusBefore {
        case .reload(_):
            modelsLoadStatus = .reload(.failed(err))
        case .page(let s):
            switch s {
            case .refreshing:
                modelsLoadStatus = .page(.refreshError(err))
            case .paging:
                modelsLoadStatus = .page(.pageError(err))
            default:
                QXDebugFatalError("初始化状态只能有reload、paging、refreshing三种")
            }
        }
    }

}

extension QXModelsLoadStatusView {
    
    @discardableResult public func mapModels<T>(_ modelType: T.Type) -> [T] {
        var ms: [T] = []
        for (_, r) in models.enumerated() {
            if let m = r as? T {
                ms.append(m)
            }
        }
        return ms
    }
    
    @discardableResult public func mapModels<T>(_ modelType: T.Type, _ todo: (T) -> Void) -> [T] {
        var ms: [T] = []
        for (_, r) in models.enumerated() {
            if let m = r as? T {
                todo(m)
                ms.append(m)
            }
        }
        return ms
    }
    
    @discardableResult public func reduceModels<T>(_ modelType: T.Type, _ todo: (T) -> T?) -> [T] {
        var ms: [T] = []
        for (i, r) in models.enumerated() {
            if let m = r as? T {
                if let m = todo(m) {
                    ms.append(m)
                } else {
                    models.remove(at: i)
                }
                ms.append(m)
            }
        }
        return ms
    }
    
}
