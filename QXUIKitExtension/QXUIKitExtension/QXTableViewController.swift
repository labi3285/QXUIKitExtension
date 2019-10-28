//
//  QXTableViewController.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/7/29.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit
import QXConsMaker

open class QXTableViewController<Model, LoadStatusView: UIView & QXLoadStatusViewProtocol>: QXModelsLoadStatusViewController<Model, QXTableView, LoadStatusView>, QXTableViewCellDelegate {
    
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
    }
    
    open func cellClass(_ model: Any?) -> QXTableViewCell.Type? {
        return nil
    }
    open func headerFooterViewClassFor(_ model: Any?) -> QXTableViewHeaderFooterView.Type? {
        return nil
    }

    open func qxTableViewCellReuseId(_ model: Any?) -> String {
        if let e = model {
            return "\(type(of: e))"
        } else {
            return "NULL"
        }
    }
    open func qxTableViewCell(_ model: Any?, _ reuseId: String) -> QXTableViewCell {
        let cell: QXTableViewCell
        if let e = model as? QXStaticBaseCell {
            cell = e
        } else if let e = cellClass(model) {
            cell = e.init(reuseId)
        } else {
            cell = QXDebugTableViewCell(reuseId)
        }
        cell.model = model
        return cell
    }
    open func qxTableViewCellHeight(_ model: Any?, _ width: CGFloat) -> CGFloat {
        if let e = model as? QXStaticBaseCell {
            if let e = type(of: e).height(model, width) {
                return e
            }
        } else if let e = cellClass(model) {
            if let e = e.height(model, width) {
                return e
            }
        }
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
        
    open func qxTableViewHeaderView(_ model: Any?, _ reuseId: String) -> QXTableViewHeaderFooterView? {
        let view: QXTableViewHeaderFooterView?
        if let e = model as? QXStaticBaseHeaderFooterView {
            view = e
        } else if let e = headerFooterViewClassFor(model) {
            view = e.init(reuseId)
        } else {
            view = nil
        }
        view?.model = model
        return view
    }
    open func qxTableViewFooterView(_ model: Any?, _ reuseId: String) -> QXTableViewHeaderFooterView? {
        let view: QXTableViewHeaderFooterView?
        if let e = model as? QXStaticBaseHeaderFooterView {
            view = e
        } else if let e = headerFooterViewClassFor(model) {
            view = e.init(reuseId)
        } else {
            view = nil
        }
        view?.model = model
        return view
    }
    
    open func qxTableViewHeaderViewReuseId(_ model: Any?) -> String {
        if let e = model {
            return "\(type(of: e))"
        } else {
            return "NULL"
        }
    }
    open func qxTableViewHeaderViewHeight(_ model: Any?, _ width: CGFloat) -> CGFloat {
        if let e = model as? QXStaticBaseHeaderFooterView {
             if let e = type(of: e).height(model, width) {
                 return e
             } else {
                return QXTableViewAutoHeight
            }
         } else if let e = headerFooterViewClassFor(model) {
             if let e = e.height(model, width) {
                 return e
             }
         }
         return QXTableViewNoneHeight
    }
    open func qxTableViewFooterViewHeight(_ model: Any?, _ width: CGFloat) -> CGFloat {
        if let e = model as? QXStaticBaseHeaderFooterView {
            if let e = type(of: e).height(model, width) {
                return e
            } else {
                return QXTableViewAutoHeight
            }
         } else if let e = headerFooterViewClassFor(model) {
            if let e = e.height(model, width) {
                return e
            }
         }
         return QXTableViewNoneHeight
    }
    open func qxTableViewFooterViewReuseId(_ model: Any?) -> String {
        if let e = model {
            return "\(type(of: e))"
        } else {
            return "NULL"
        }
    }
    
    open func qxTableViewEstimatedCellHeight(_ model: Any?, _ width: CGFloat) -> CGFloat {
        return QXTableViewAutoHeight
    }
    open func qxTableViewEstimatedHeaderHeight(_ model: Any?, _ width: CGFloat) -> CGFloat {
        return QXTableViewAutoHeight
    }
    open func qxTableViewEstimatedFooterHeight(_ model: Any?, _ width: CGFloat) -> CGFloat {
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

class QXDebugTableViewCell: QXTableViewBreakLineCell {
    
    override func height(_ model: Any?, _ width: CGFloat) -> CGFloat? {
        label.intrinsicWidth = width
        return nil
    }
    
    override var model: Any? {
        didSet {
            super.model = model
            label.text = "\(model ?? "nil")"
        }
    }
    public lazy var label: QXLabel = {
        let one = QXLabel()
        one.padding = QXEdgeInsets(10, 15, 10, 15)
        one.font = QXFont(fmt: "14 #333333")
        one.numberOfLines = 0
        return one
    }()
    required init(_ reuseId: String) {
        super.init(reuseId)
        contentView.addSubview(label)
        label.IN(contentView).LEFT.RIGHT.TOP.BOTTOM.MAKE()
        breakLine.padding = QXEdgeInsets(0, 15, 0, 15)
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class QXDebugTableViewHeaderFooterView: QXTableViewHeaderFooterView {
    
    override func height(_ model: Any?, _ width: CGFloat) -> CGFloat? {
        label.intrinsicWidth = width
        return nil
    }
    
    override var model: Any? {
        didSet {
            super.model = model
            label.text = "\(model ?? "nil")"
        }
    }
    public lazy var label: QXLabel = {
        let one = QXLabel()
        one.padding = QXEdgeInsets(10, 15, 10, 15)
        one.font = QXFont(fmt: "14 #333333")
        one.numberOfLines = 0
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
