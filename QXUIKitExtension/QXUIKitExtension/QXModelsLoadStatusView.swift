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

open class QXModelsLoadStatusView<T>: QXView {
        
    public var api: QXModelsApi<T>?
    
    open func reloadData() {
        currentPage = 1
        modelsLoadStatus = .reload(.loading(nil))
        loadModels()
    }

    /// 模型
    open var models: [T] = [] {
        didSet {
            contentView.isHidden = models.count == 0
            contentView.qxUpdateModels(models)
        }
    }
    
    open func loadModels() {
        weak var ws = self
        api?({ models, isThereMore in
            ws?.onLoadModelsOk(models, isThereMore: isThereMore)
        }, { err in
            ws?.onLoadModelsFailed(err)
        })
    }

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

    open override func layoutSubviews() {
        super.layoutSubviews()
        contentView.qxRect = qxBounds.rectByReduce(padding)
        loadStatusView.qxRect = qxBounds.rectByReduce(padding)
    }

    open override var intrinsicContentSize: CGSize {
        if isDisplay {
            if let e = intrinsicSize {
                return e.cgSize
            }
            let e = loadStatusView.intrinsicContentSize
            return e.qxSizeByAdd(padding.uiEdgeInsets)
        }
        return CGSize.zero
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
    
    public lazy var refreshFooter: QXRefreshFooter = {
        let one = QXRefreshFooter(refreshingBlock: {  [weak self] in
            self?.footerStartRefresh()
        })!
        return one
    }()
    
    public lazy var refreshHeader: QXRefreshHeader = {
        let one = QXRefreshHeader(refreshingBlock: {  [weak self] in
            self?.headerStartRefresh()
        })!
        return one
    }()

    public private(set) var modelsLoadStatus: QXModelsLoadStatus = .reload(.ok) {
        didSet {
            switch modelsLoadStatus {
            case .reload(status: let s):
                refreshHeader.endRefreshing()
                refreshFooter.endRefreshing()
                refreshFooter.resetNoMoreData()
                loadStatusView.qxLoadStatusViewUpdateStatus(s)
                switch s {
                case .ok:
                    contentView.isHidden = false
                default:
                    contentView.isHidden = true
                }
            case .page(let s):
                loadStatusView.qxLoadStatusViewUpdateStatus(.ok)
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
        currentPage = 1
        modelsLoadStatus = .page(.refreshing)
        loadModels()
    }
    open func footerStartRefresh() {
        modelsLoadStatus = .page(.paging)
        loadModels()
    }
        
    /// 默认从1开始
    public var isPageStartFromZero: Bool = false
    public private(set) var currentPage: Int = 1
    public var pageCount: Int = 10
    
    /// 拿到分页数据的界面更新
    open func onLoadModelsOk(_ newModels: [T], isThereMore: Bool? = nil) {
        let statusBefore = modelsLoadStatus
        if canPage {
            if statusBefore.isRefresh {
                models = newModels
            } else {
                models += newModels
                currentPage += 1
            }
            contentView.qxReloadData()
            let isThereMore = isThereMore ?? (newModels.count > 0)
            switch statusBefore {
            case .reload(status: _):
                if models.count > 0 {
                    if isThereMore {
                        modelsLoadStatus = .reload(.ok)
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
                        modelsLoadStatus = .reload(.ok)
                    } else {
                        modelsLoadStatus = .reload(.empty(nil))
                    }
                default:
                    fatalError("请设置canPage=true")
                }
            case .reload(status: _):
                if models.count > 0 {
                    modelsLoadStatus = .reload(.ok)
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
            modelsLoadStatus = .reload(.error(err))
        case .page(let s):
            switch s {
            case .refreshing:
                modelsLoadStatus = .page(.refreshError(err))
            case .paging:
                modelsLoadStatus = .page(.pageError(err))
            default:
                fatalError("初始化状态只能有reload、paging、refreshing三种")
            }
        }
    }

}
