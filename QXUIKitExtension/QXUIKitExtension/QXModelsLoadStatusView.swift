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
    
    /// 自动设置models
    open var models: [Model] = [] {
        didSet {
            contentView.qxUpdateModels(models, staticModels)
        }
    }
    
    /// static models
    open var staticModels: [Model]? = [] {
        didSet {
            contentView.qxUpdateModels(models, staticModels)
        }
    }
    
    public var isQXMessageForLoadingEnabledWhenThereIsModels: Bool = false
    public var isQXMessageForErrorEnabledWhenThereIsModels: Bool = false
    public var isQXMessageForEmptyEnabledWhenThereIsModels: Bool = false

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

    public let loadStatusView: QXView & QXLoadStatusViewProtocol
    public let contentView: UIView & QXRefreshableViewProtocol
    public required init(contentView: UIView & QXRefreshableViewProtocol, loadStatusView: QXView & QXLoadStatusViewProtocol) {
        self.contentView = contentView
        self.loadStatusView = loadStatusView
        super.init()
        self.addSubview(contentView)
        //_ = contentView.qxUpdateGlobalDataLoadStatus(QXLoadStatus.succeed, loadStatusView)
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
            contentView.qxSetRefreshHeader(canRefresh ? refreshHeader : nil)
        }
    }
    
    /// 是否可以上拉刷新
    public var canPage: Bool = false {
        didSet {
            // auto
            contentView.qxSetRefreshFooter(nil)
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
    
    open var modelsLoadStatus: QXModelsLoadStatus = .reload(.succeed) {
        didSet {
            let isThereModels = (models.count + (staticModels?.count ?? 0)) > 0
            let isLoadStatusViewNeeded = models.count <= 0
            switch modelsLoadStatus {
            case .reload(status: let s):
                refreshHeader.endRefreshing()
                refreshFooter.endRefreshing()
                refreshFooter.resetNoMoreData()
                loadStatusView.qxLoadStatusViewUpdateStatus(s)
                contentView.qxUpdateGlobalDataLoadStatus(s, loadStatusView, true, isLoadStatusViewNeeded)
                switch s {
                case .loading:
                    contentView.qxSetRefreshHeader(nil)
                    contentView.qxSetRefreshFooter(nil)
                    if isQXMessageForLoadingEnabledWhenThereIsModels && isThereModels  {
                        showLoading(msg: nil)
                    }
                case .empty(let msg):
                     contentView.qxSetRefreshHeader(canRefresh ? refreshHeader : nil)
                     contentView.qxSetRefreshFooter(nil)
                     if isQXMessageForEmptyEnabledWhenThereIsModels && isThereModels {
                        showWarning(msg: msg ?? "暂无数据")
                     }
                case .failed(let err):
                    contentView.qxSetRefreshHeader(canRefresh ? refreshHeader : nil)
                    contentView.qxSetRefreshFooter(nil)
                    if isQXMessageForErrorEnabledWhenThereIsModels && isThereModels {
                        showFailure(msg: err?.message ?? "未知错误")
                    }
                case .succeed:
                    contentView.qxSetRefreshHeader(canRefresh ? refreshHeader : nil)
                    contentView.qxSetRefreshFooter(canPage ? refreshFooter : nil)
                    hideLoading()
                }
            case .page(let s):
                if models.count == 0 {
                    switch s {
                    case .refreshing:
                        loadStatusView.qxLoadStatusViewUpdateStatus(.loading)
                        contentView.qxUpdateGlobalDataLoadStatus(.succeed, loadStatusView, false, isLoadStatusViewNeeded)
                        if isQXMessageForLoadingEnabledWhenThereIsModels && isThereModels  {
                            showLoading(msg: nil)
                        }
                        refreshHeader.beginRefreshing()
                        refreshFooter.resetNoMoreData()
                        contentView.qxSetRefreshFooter(nil)
                    case .refreshOk:
                        loadStatusView.qxLoadStatusViewUpdateStatus(.succeed)
                        contentView.qxUpdateGlobalDataLoadStatus(.succeed, loadStatusView, false, isLoadStatusViewNeeded)
                        hideLoading()
                        
                        refreshHeader.endRefreshing()
                        contentView.qxSetRefreshFooter(canPage ? refreshFooter : nil)
                    case .refreshError(let err):
                        loadStatusView.qxLoadStatusViewUpdateStatus(.failed(err))
                        contentView.qxUpdateGlobalDataLoadStatus(.failed(err), loadStatusView, false, isLoadStatusViewNeeded)
                        if isQXMessageForErrorEnabledWhenThereIsModels && isThereModels {
                            showFailure(msg: err?.message ?? "未知错误")
                        }
                        refreshHeader.endRefreshing()
                        contentView.qxSetRefreshFooter(nil)
                    default:
                        QXDebugFatalError("no go here")
                    }
                } else {
                    loadStatusView.qxLoadStatusViewUpdateStatus(.succeed)
                    contentView.qxUpdateGlobalDataLoadStatus(.succeed, loadStatusView, false, isLoadStatusViewNeeded)
                    
                    contentView.qxSetRefreshFooter(canPage ? refreshFooter : nil)
                    switch s {
                    case .refreshing:
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
    }

    open func headerStartRefresh() {
        _originPage = filter.page
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
        if let e = _originPage {
            filter.page = e
        }
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
    private var _originPage: Int?

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
