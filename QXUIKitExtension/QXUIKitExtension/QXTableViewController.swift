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
        
//        contentView.canPageFilter = true
//        contentView.canRefresh = true
//        contentView.api = { ok, failed in
//             DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
//                 let ms = (0..<5).map { _ in QXDebugRandomText(333) }
//                 ok(ms, true)
//             }
//         }
    }

    open func qxTableViewCellClass(_ model: Any?) -> QXTableViewCell.Type? {
        return nil
    }
    open func qxTableViewHeaderViewClass(_ model: Any?) -> QXTableViewHeaderFooterView.Type? {
        return nil
    }
    open func qxTableViewFooterViewClass(_ model: Any?) -> QXTableViewHeaderFooterView.Type? {
        return nil
    }
    
    open func qxTableViewDidSelectCell(_ model: Any?) {
        QXDebugPrint("cell select: \(model ?? "null")")
    }
    open func qxTableViewDidSelectHeaderView(_ model: Any?) {
        QXDebugPrint("headerView select: \(model ?? "null")")
    }
    open func qxTableViewDidSelectFooterView(_ model: Any?) {
        QXDebugPrint("footerView select: \(model ?? "null")")
    }

}

