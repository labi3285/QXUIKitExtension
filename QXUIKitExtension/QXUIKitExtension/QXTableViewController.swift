//
//  QXTableViewController.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/7/29.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

open class QXTableViewController<Model>: QXViewController, QXTableViewDelegate {

    public lazy var tableView: QXTableView = {
        let one = QXTableView()
        one.delegate = self
        return one
    }()
    public lazy var loadStatusView: QXLoadStatusView = {
        let one = QXLoadStatusView()
        return one
    }()
    
    public lazy var contentView: QXModelsLoadStatusView<Model> = {
        let one = QXModelsLoadStatusView<Model>(contentView: self.tableView, loadStatusView: self.loadStatusView)
         return one
    }()
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(contentView)
        contentView.IN(view).LEFT.RIGHT.TOP.BOTTOM.MAKE()
        
//        contentView.canPage = true
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
    open func qxTableViewHeaderFooterViewClass(_ model: Any?) -> QXTableViewHeaderFooterView.Type? {
        return nil
    }
    open func qxTableViewMoveCell(_ indexPath: IndexPath, _ toIndexPath: IndexPath) {
        
    }
    
}

