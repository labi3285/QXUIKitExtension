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
        let cell = QXDebugTableViewCell(reuseId)
        cell.model = model
        return cell
    }
    open func qxTableViewHeaderView(_ model: Any?, _ reuseId: String) -> QXTableViewHeaderFooterView? {
        return nil
    }
    open func qxTableViewFooterView(_ model: Any?, _ reuseId: String) -> QXTableViewHeaderFooterView? {
        return nil
    }
    
    open func qxTableViewCellReuseId(_ model: Any?) -> String {
        if let e = model {
            return "\(type(of: e))"
        } else {
            return "NULL"
        }
    }
    open func qxTableViewCellHeight(_ model: Any?) -> CGFloat {
        return QXTableViewAutoHeight
    }
    open func qxTableViewCellCanEdit(_ model: Any?) -> Bool {
        return false
    }
    open func qxTableViewCellCanMove(_ model: Any?) -> Bool {
        return false
    }
    open func qxTableViewCellEditActions(_ model: Any?) -> [UITableViewRowAction]? {
        return nil
    }
    open func qxTableViewHeaderViewReuseId(_ model: Any?) -> String {
        if let e = model {
            return "\(type(of: e))"
        } else {
            return "NULL"
        }
    }
    open func qxTableViewHeaderViewHeight(_ model: Any?) -> CGFloat {
        return QXTableViewNoneHeight
    }
    open func qxTableViewFooterViewHeight(_ model: Any?) -> CGFloat {
        return QXTableViewNoneHeight
    }
    open func qxTableViewFooterViewReuseId(_ model: Any?) -> String {
        if let e = model {
            return "\(type(of: e))"
        } else {
            return "NULL"
        }
    }
    open func qxTableViewEstimatedCellHeight(_ model: Any?) -> CGFloat {
        return QXTableViewAutoHeight
    }
    open func qxTableViewEstimatedHeaderHeight(_ model: Any?) -> CGFloat {
        return QXTableViewAutoHeight
    }
    open func qxTableViewEstimatedFooterHeight(_ model: Any?) -> CGFloat {
        return QXTableViewAutoHeight
    }
    open func qxTableViewWillDisplayCell(_ cell: QXTableViewCell) {
    }
    open func qxTableViewWillDisplayHeaderView(_ view: QXTableViewHeaderFooterView) {
    }
    open func qxTableViewWillDisplayFooterView(_ view: QXTableViewHeaderFooterView) {
    }
    open func qxTableViewDidEndDisplayingCell(_ cell: QXTableViewCell) {
    }
    open func qxTableViewDidEndDisplayingHeaderView(_ view: QXTableViewHeaderFooterView) {
    }
    open func qxTableViewDidEndDisplayingFooterView(_ view: QXTableViewHeaderFooterView) {
    }
}

class QXDebugTableViewCell: QXTableViewCell {
    
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
        one.numberOfLines = 0
        one.intrinsicWidth = UIScreen.main.bounds.width
        return one
    }()
    required init(_ reuseId: String) {
        super.init(reuseId)
        contentView.addSubview(label)
        label.IN(contentView).LEFT.RIGHT.TOP.BOTTOM.MAKE()
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class QXDebugTableViewHeaderFooterView: QXTableViewHeaderFooterView {
    
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
        one.numberOfLines = 0
        one.intrinsicWidth = UIScreen.main.bounds.width
        return one
    }()
    required init(_ reuseId: String) {
        super.init(reuseId)
        contentView.addSubview(label)
        label.IN(contentView).LEFT.RIGHT.TOP.BOTTOM.MAKE()
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
