//
//  QXTableViewController.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/7/29.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

open class QXTableViewController<Model, LoadStatusView: UIView & QXLoadStatusViewProtocol>: QXModelsLoadStatusViewController<Model, QXTableView, LoadStatusView>, QXTableViewCellProtocol {
    
    override open var models: [Model] {
        didSet {
            let section = QXTableViewSection(models)
            tableView.sections = [section]
            super.models = models
        }
    }
    
    open var tableView: QXTableView {
        return refreshableView
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        tableView.cellsDelegate = self
        canRefresh = true
        canPage = true
    }
    
    open func qxTableViewCell(_ model: Any?, _ reuseId: String) -> QXTableViewCell {
        return DebugTableViewCell(reuseId: reuseId)
    }
    
}

class DebugTableViewCell: QXTableViewCell {
    
    override var model: Any? {
        didSet {
            super.model = model
            label.text = "\(model ?? "nil")"
        }
    }
    public lazy var label: QXLabel = {
        let one = QXLabel()
        one.margin = QXMargin(10, 15, 10, 15)
        one.font = QXFont(fmt: "14 #333333")
        return one
    }()
    required init(reuseId: String) {
        super.init(reuseId: reuseId)
        contentView.addSubview(label)
        label.IN(contentView).LEFT.RIGHT.TOP.BOTTOM.MAKE()
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
