//
//  QXTableViewController.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/7/22.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit
import MJRefresh

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

open class QXModelsLoadStatusViewController
<Model, RefreshableView: UIView & QXRefreshableViewProtocol, LoadStatusView: UIView & QXLoadStatusViewProtocol>: QXLoadStatusViewController<LoadStatusView> {
    
    /// 模型
    open var models: [Model] = [] {
        didSet {
            print(models.count)
            contentView.isHidden = models.count == 0
        }
    }

    /// 是否可以下拉刷新
    public var canRefresh: Bool = false {
        didSet {
            if canRefresh {
                refreshableView.qxSetRefreshHeader(refreshHeader)
            } else {
                refreshableView.qxSetRefreshHeader(nil)
            }
        }
    }
    private func updateCanRefresh() {
        if canRefresh {
            refreshableView.qxSetRefreshHeader(refreshHeader)
        } else {
            refreshableView.qxSetRefreshHeader(nil)
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
            refreshableView.qxSetRefreshFooter(refreshFooter)
        } else {
            refreshableView.qxSetRefreshFooter(nil)
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
                loadStatus = s
            case .page(let s):
                loadStatus = .ok
                switch s {
                case .refreshing:
                    refreshHeader.beginRefreshing()
                    refreshFooter.resetNoMoreData()
                    refreshableView.qxSetRefreshFooter(nil)
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
                    refreshableView.qxSetRefreshHeader(nil)
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
    override open func retry() {
        currentPage = 1
        modelsLoadStatus = .reload(.loading(nil))
        loadModels()
    }

    /// 默认从1开始
    public var isPageStartFromZero: Bool = false
    public private(set) var currentPage: Int = 1
    public var pageCount: Int = 10

    /// 数据加载方法， 重写这个方法请调用super
    open func loadModels() { }
    
    /// 拿到分页数据的界面更新
    open func onLoadModelsOk(_ newModels: [Model], isThereMore: Bool? = nil) {
        let statusBefore = modelsLoadStatus
        if canPage {
            if statusBefore.isRefresh {
                models = newModels
            } else {
                models += newModels
                currentPage += 1
            }
            refreshableView.qxReloadData()
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
            refreshableView.qxReloadData()
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

    public lazy var refreshableView: RefreshableView = {
        let one = RefreshableView()
        return one
    }()

    override open func viewDidLoad() {
        super.viewDidLoad()
        contentView.addSubview(refreshableView)
    }

    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        refreshableView.frame = contentView.bounds
    }
}


extension QXModelsLoadStatusViewController where Model: QXModel {
    
    public func onLoadModelsComplete(_ respond: QXRespond<QXPage<Model>>) {
        if respond.isOk {
            if let page = respond.data {
                if let arr = page.models {
                    onLoadModelsOk(arr, isThereMore: page.isThereMorePage)
                } else {
                    onLoadModelsOk([], isThereMore: page.isThereMorePage)
                }
            } else {
                QXDebugFatalError("shoud not be here")
                onLoadModelsOk([], isThereMore: false)
            }
        } else {
            onLoadModelsFailed(respond.error)
        }
    }
    
    

    
}

class XXXPage<T: QXModel>: QXPage<T> {
}
extension QXModelsLoadStatusViewController where Model: QXModel {
    func onMyLoadModelsComplete(_ respond: QXRespond<XXXPage<Model>>) {
        if respond.isOk {
            if let page = respond.data {
                if let arr = page.models {
                    onLoadModelsOk(arr, isThereMore: page.isThereMorePage)
                } else {
                    onLoadModelsOk([], isThereMore: page.isThereMorePage)
                }
            } else {
                QXDebugFatalError("shoud not be here")
                onLoadModelsOk([], isThereMore: false)
            }
        } else {
            onLoadModelsFailed(respond.error)
        }
    }
}
