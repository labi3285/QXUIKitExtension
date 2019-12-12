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

open class QXModelsLoadStatusView<Model>: QXView {
        
    /// 优先级 ①
    public var api: QXModelsApi<Model>?
    /// 优先级 ②
    public var loadDataHandler: ( (QXFilter, @escaping (QXRequest.Respond<[Model]>)->() ) -> ())?
    
    open func loadData(_ filter: QXFilter, _ done: @escaping (QXRequest.Respond<[Model]>) -> ()) {
        if let e = loadDataHandler {
            e(filter, done)
        } else {
            /// 优先级 ③
            done(.failed(QXError(-1, "请重写loadData或者提供api")))
        }
    }
    
    open func reloadData() {
        filter.page = isPageStartFromZero ? 0 : 1
        modelsLoadStatus = .reload(.loading(nil))
        loadModels()
    }

    /// 模型
    open var models: [Model] = [] {
        didSet {
            contentView.isHidden = models.count == 0
            contentView.qxUpdateModels(models)
        }
    }
    
    open func loadModels() {
        weak var ws = self
        if let e = api {
            e.execute(filter, { models, isThereMore in
                ws?.onLoadModelsOk(models, isThereMore: isThereMore)
            }, { err in
                ws?.onLoadModelsFailed(err)
            })
        } else {
            loadData(filter) { (respond) in
                switch respond {
                case .succeed(let ms):
                    if let ms = ms {
                        ws?.onLoadModelsOk(ms, isThereMore: ms.count > 0)
                    } else {
                        ws?.onLoadModelsOk([], isThereMore: false)
                    }
                case .failed(let err):
                    ws?.onLoadModelsFailed(err)
                }
            }
        }
    }

    public var filter: QXFilter = QXFilter()
    public var isPageStartFromZero: Bool = true

    public let contentView: UIView & QXRefreshableViewProtocol
    public let loadStatusView: UIView & QXLoadStatusViewProtocol
    public required init(contentView: UIView & QXRefreshableViewProtocol, loadStatusView: UIView & QXLoadStatusViewProtocol) {
        self.contentView = contentView
        self.loadStatusView = loadStatusView
        super.init()
        self.addSubview(contentView)
        self.addSubview(loadStatusView)
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
        loadStatusView.qxRect = qxBounds.rectByReduce(padding)
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
    private func updateCanRefresh() {
        if canRefresh {
            contentView.qxSetRefreshHeader(refreshHeader)
        } else {
            contentView.qxSetRefreshHeader(nil)
        }
    }

    /// 是否可以上拉刷新
    public var canPage: Bool = false {
        didSet {
           updateCanPage()
        }
    }
    private func updateCanPage() {
        if canPage {
            contentView.qxSetRefreshFooter(refreshFooter)
        } else {
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

    public private(set) var modelsLoadStatus: QXModelsLoadStatus = .reload(.succeed) {
        didSet {
            switch modelsLoadStatus {
            case .reload(status: let s):
                refreshHeader.endRefreshing()
                refreshFooter.endRefreshing()
                refreshFooter.resetNoMoreData()
                loadStatusView.qxLoadStatusViewUpdateStatus(s)
                switch s {
                case .succeed:
                    contentView.isHidden = false
                default:
                    contentView.isHidden = true
                }
            case .page(let s):
                loadStatusView.qxLoadStatusViewUpdateStatus(.succeed)
                contentView.isHidden = false
                switch s {
                case .refreshing:
                    refreshHeader.beginRefreshing()
                    refreshFooter.resetNoMoreData()
                    contentView.qxSetRefreshFooter(nil)
                case .refreshOk:
                    refreshHeader.endRefreshing()
                    updateCanPage()
                case .refreshError(let err):
                    if let e = err?.message {
                        showFailure(msg: e)
                    }
                    refreshHeader.endRefreshing()
                    updateCanPage()
                case .paging:
                    refreshFooter.beginRefreshing()
                    contentView.qxSetRefreshHeader(nil)
                case .pageError(let err):
                    if let e = err?.message {
                        showFailure(msg: e)
                    }
                    refreshFooter.endRefreshing()
                    updateCanRefresh()
                case .pageOk:
                    refreshFooter.endRefreshing()
                    updateCanRefresh()
                case .pageEmpty(msg: _):
                    refreshFooter.endRefreshingWithNoMoreData()
                    updateCanRefresh()
                case .pageNoMore(_):
                    refreshHeader.endRefreshing()
                    refreshFooter.endRefreshingWithNoMoreData()
                    updateCanRefresh()
                }
            }
        }
    }

    open func headerStartRefresh() {
        filter.page = isPageStartFromZero ? 0 : 1
        modelsLoadStatus = .page(.refreshing)
        loadModels()
    }
    open func footerStartRefresh() {
        modelsLoadStatus = .page(.paging)
        loadModels()
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
            contentView.qxReloadData()
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
