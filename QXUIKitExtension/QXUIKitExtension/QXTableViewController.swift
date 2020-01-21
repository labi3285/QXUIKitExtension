//
//  QXTableViewController.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/7/29.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

open class QXTableViewController<Model>: QXViewController, QXTableViewDelegate {
    
    public final lazy var tableView: QXTableView = {
        let e = QXTableView()
        e.delegate = self
        return e
    }()
    public final lazy var loadStatusView: QXLoadStatusView = {
        let e = QXLoadStatusView()
        return e
    }()
    
    public final lazy var contentView: QXModelsLoadStatusView<Model> = {
        let e = QXModelsLoadStatusView<Model>(contentView: self.tableView, loadStatusView: self.loadStatusView)
        e.api = { [weak self] filter, done in
            self?.loadData(filter, done)
        }
        return e
    }()
        
    open func loadData(_ filter: QXFilter, _ done: @escaping (QXRequest.RespondPage<Model>) -> Void) {
        done(.failed(QXError(-1, "请重写loadData或者提供api")))
    }
    
    open override func viewDidLayoutSubviews() {
        contentView.qxRect = view.qxBounds
        contentView.layoutSubviews()
        tableView.layoutSubviews()
        super.viewDidLayoutSubviews()
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(contentView)
    }
    
    open func tableViewDidSetupCell(_ cell: QXTableViewCell, for model: Any, in section: QXTableViewSection) { }
    open func tableViewDidSelectCell(_ cell: QXTableViewCell, for model: Any, in section: QXTableViewSection) { }
    
    open func tableViewDidSetupHeaderView(_ headerView: QXTableViewHeaderFooterView, for model: Any, in section: QXTableViewSection) { }
    open func tableViewDidSelectHeaderView(_ headerView: QXTableViewHeaderFooterView, for model: Any, in section: QXTableViewSection) { }
    
    open func tableViewDidSetupFooterView(_ footerView: QXTableViewHeaderFooterView, for model: Any, in section: QXTableViewSection) { }
    open func tableViewDidSelectFooterView(_ footerView: QXTableViewHeaderFooterView, for model: Any, in section: QXTableViewSection) { }

    open func tableViewDidMove(from: IndexPath, to: IndexPath, in sections: [QXTableViewSection]) { }
    
    open func tableViewNeedsReloadData() {
        contentView.reloadData()
    }
    
}

