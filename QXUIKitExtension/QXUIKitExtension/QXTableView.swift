//
//  QXTableView.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/7/27.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit
import MJRefresh

public let QXTableViewAutoHeight: CGFloat = UITableView.automaticDimension
public let QXTableViewNoneHeight: CGFloat = 0.0001

public protocol QXTableViewCellDelegate: class {
    
    /// [Required]
    func qxTableViewCell(_ model: Any?, _ reuseId: String) -> QXTableViewCell

    // [Optional]
    func qxTableViewCellReuseId(_ model: Any?) -> String
    func qxTableViewCellHeight(_ model: Any?) -> CGFloat
    func qxTableViewCellCanEdit(_ model: Any?) -> Bool
    func qxTableViewCellEditActions(_ model: Any?) -> [UITableViewRowAction]?
    
    func qxTableViewHeaderViewReuseId(_ model: Any?) -> String
    func qxTableViewHeaderViewHeight(_ model: Any?) -> CGFloat

    func qxTableViewFooterViewReuseId(_ model: Any?) -> String
    func qxTableViewFooterViewHeight(_ model: Any?) -> CGFloat

    func qxTableViewEstimatedCellHeight(_ model: Any?) -> CGFloat
    func qxTableViewEstimatedHeaderHeight(_ model: Any?) -> CGFloat
    func qxTableViewEstimatedFooterHeight(_ model: Any?) -> CGFloat

    func qxTableViewHeaderView(_ model: Any?, _ reuseId: String) -> QXTableViewHeaderFooterView?
    func qxTableViewFooterView(_ model: Any?, _ reuseId: String) -> QXTableViewHeaderFooterView?

    func qxTableViewWillDisplayCell(_ cell: QXTableViewCell)
    func qxTableViewWillDisplayHeaderView(_ view: QXTableViewHeaderFooterView)
    func qxTableViewWillDisplayFooterView(_ view: QXTableViewHeaderFooterView)
    
    func qxTableViewDidEndDisplayingCell( _ cell: QXTableViewCell)
    func qxTableViewDidEndDisplayingHeaderView(_ view: QXTableViewHeaderFooterView)
    func qxTableViewDidEndDisplayingFooterView(_ view: QXTableViewHeaderFooterView)
    
}

extension QXTableViewCellDelegate {
    
    public func qxTableViewCellReuseId(_ model: Any?) -> String {
        if let e = model {
            return "\(type(of: e))"
        } else {
            return "NULL"
        }
    }
    public func qxTableViewCellHeight(_ model: Any?) -> CGFloat {
        return QXTableViewAutoHeight
    }
    public func qxTableViewCellCanEdit(_ model: Any?) -> Bool {
        return false
    }
    public func qxTableViewCellCanMove(_ model: Any?) -> Bool {
        return false
    }
    public func qxTableViewCellEditActions(_ model: Any?) -> [UITableViewRowAction]? {
        return nil
    }
    
    public func qxTableViewHeaderViewReuseId(_ model: Any?) -> String {
        if let e = model {
            return "\(type(of: e))"
        } else {
            return "NULL"
        }
    }
    public func qxTableViewHeaderViewHeight(_ model: Any?) -> CGFloat {
        return QXTableViewNoneHeight
    }
    public func qxTableViewFooterViewHeight(_ model: Any?) -> CGFloat {
        return QXTableViewNoneHeight
    }
    
    public func qxTableViewFooterViewReuseId(_ model: Any?) -> String {
        if let e = model {
            return "\(type(of: e))"
        } else {
            return "NULL"
        }
    }
    public func qxTableViewEstimatedCellHeight(_ model: Any?) -> CGFloat {
        return QXTableViewAutoHeight
    }
    public func qxTableViewEstimatedHeaderHeight(_ model: Any?) -> CGFloat {
        return QXTableViewAutoHeight
    }
    public func qxTableViewEstimatedFooterHeight(_ model: Any?) -> CGFloat {
        return QXTableViewAutoHeight
    }
    public func qxTableViewHeaderView(_ model: Any?, _ reuseId: String) -> QXTableViewHeaderFooterView? {
        return QXTableViewHeaderFooterView(reuseId)
    }
    public func qxTableViewFooterView(_ model: Any?, _ reuseId: String) -> QXTableViewHeaderFooterView? {
        return QXTableViewHeaderFooterView(reuseId)
    }
    
    public func qxTableViewWillDisplayCell(_ cell: QXTableViewCell) {
        
    }
    public func qxTableViewWillDisplayHeaderView(_ view: QXTableViewHeaderFooterView) {
        
    }
    public func qxTableViewWillDisplayFooterView(_ view: QXTableViewHeaderFooterView) {
        
    }
    public func qxTableViewDidEndDisplayingCell(_ cell: QXTableViewCell) {
        
    }
    public func qxTableViewDidEndDisplayingHeaderView(_ view: QXTableViewHeaderFooterView) {
        
    }
    public func qxTableViewDidEndDisplayingFooterView(_ view: QXTableViewHeaderFooterView) {
    }
}

open class QXTableViewCell: UITableViewCell {
    
    open var model: Any?
    
    required public init(_ reuseId: String) {
        super.init(style: .default, reuseIdentifier: reuseId)
        backgroundView = UIView()
        contentView.backgroundColor = UIColor.clear
        backgroundColor = UIColor.clear
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

open class QXTableViewHeaderFooterView: UITableViewHeaderFooterView {
    
    open var model: Any?
    
    required public init(_ reuseId: String) {
        super.init(reuseIdentifier: reuseId)
        backgroundView = UIView()
        contentView.backgroundColor = UIColor.clear
        backgroundColor = UIColor.clear
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

public struct QXTableViewSection {
    public var indexTitle: String? = nil
    public var header: Any? = nil
    public var models: [Any?] = []
    public var footer: Any? = nil
    
    public init(_ models: [Any?]) {
        self.models = models
    }
    public init(_ models: [Any?], _ header: Any?, _ footer: Any?) {
        self.models = models
        self.header = header
        self.footer = footer
    }
}

open class QXTableView: QXView {
    
    public weak var cellsDelegate: QXTableViewCellDelegate?
    public var sections: [QXTableViewSection] = []

    public var padding: QXPadding = QXPadding.zero
    
    /// 默认是扁平的
    public var isPlain: Bool {
        set {
            if newValue {
                if nsTableView.style != .plain {
                    nsTableView = UITableView(frame: CGRect.zero, style: .plain)
                    updateNSTableView()
                }
            } else {
                if nsTableView.style == .plain {
                    nsTableView = UITableView(frame: CGRect.zero, style: .grouped)
                    updateNSTableView()
                }
            }
        }
        get {
            return nsTableView.style == .plain
        }
    }
    
    public private(set) var nsTableView: UITableView = UITableView(frame: CGRect.zero, style: .plain)
    
    open func updateNSTableView() {
        nsTableView.backgroundColor = UIColor.clear
        nsTableView.separatorStyle = .none
        nsTableView.qxCheckOrRemoveFromSuperview()
        addSubview(nsTableView)
        nsTableView.delegate = self
        nsTableView.dataSource = self
        setNeedsLayout()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        nsTableView.frame = bounds.qxSubRect(padding.uiEdgeInsets)
    }
    
    required public init() {
        super.init(frame: CGRect.zero)
        updateNSTableView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension QXTableView: UITableViewDelegate, UITableViewDataSource {
    
    open func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].models.count
    }
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let delegate = cellsDelegate {
            let section = sections[indexPath.section]
            let model = section.models[indexPath.row]
            let id = delegate.qxTableViewCellReuseId(model)
            let cell: QXTableViewCell
            if let e = tableView.dequeueReusableCell(withIdentifier: id) as? QXTableViewCell {
                cell = e
            } else {
                cell = delegate.qxTableViewCell(model, id)
            }
            cell.model = model
            return cell
        } else {
            return QXDebugFatalError("请设置 cellsDelegate", UITableViewCell())
        }
    }
    open func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if let delegate = cellsDelegate {
            let section = sections[indexPath.section]
            let model = section.models[indexPath.row]
            return delegate.qxTableViewCellCanEdit(model)
        } else {
            return QXDebugFatalError("请设置 cellsDelegate", false)
        }
    }
    open func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if let delegate = cellsDelegate {
            let section = sections[indexPath.section]
            let model = section.models[indexPath.row]
            return delegate.qxTableViewCellCanEdit(model)
        } else {
            return QXDebugFatalError("请设置 cellsDelegate", false)
        }
    }
//    open func sectionIndexTitles(for tableView: UITableView) -> [String]? {
//        return ["1", "2", "3"]
//    }
    open func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    }
    
    open func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if let delegate = cellsDelegate {
            let section = sections[indexPath.section]
            let model = section.models[indexPath.row]
            return delegate.qxTableViewCellEditActions(model)
        } else {
            return QXDebugFatalError("请设置 cellsDelegate", nil)
        }
    }
//
//    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
    
    open func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let delegate = cellsDelegate {
            if let cell = cell as? QXTableViewCell {
                delegate.qxTableViewWillDisplayCell(cell)
            }
        }
    }
    open func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let delegate = cellsDelegate {
            if let view = view as? QXTableViewHeaderFooterView {
                delegate.qxTableViewWillDisplayHeaderView(view)
            }
        }
    }
    open func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        if let delegate = cellsDelegate {
            if let view = view as? QXTableViewHeaderFooterView {
                delegate.qxTableViewWillDisplayFooterView(view)
            }
        }
    }
    open func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let delegate = cellsDelegate {
            if let cell = cell as? QXTableViewCell {
                delegate.qxTableViewDidEndDisplayingCell(cell)
            }
        }
    }
    open func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
        if let delegate = cellsDelegate {
            if let view = view as? QXTableViewHeaderFooterView {
                delegate.qxTableViewDidEndDisplayingHeaderView(view)
            }
        }
    }
    open func tableView(_ tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int) {
        if let delegate = cellsDelegate {
            if let view = view as? QXTableViewHeaderFooterView {
                delegate.qxTableViewDidEndDisplayingFooterView(view)
            }
        }
    }

    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = sections[indexPath.section]
        let model = section.models[indexPath.row]
        if let delegate = cellsDelegate {
            return delegate.qxTableViewCellHeight(model)
        } else {
            return QXDebugFatalError("请设置 cellsDelegate", QXTableViewAutoHeight)
        }
    }

    open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let section = sections[section]
        let model = section.header
        if let delegate = cellsDelegate {
            return delegate.qxTableViewHeaderViewHeight(model)
        } else {
            return QXDebugFatalError("请设置 cellsDelegate", QXTableViewAutoHeight)
        }
    }
    
    open func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let section = sections[section]
        let model = section.footer
        if let delegate = cellsDelegate {
            return delegate.qxTableViewFooterViewHeight(model)
        } else {
            return QXDebugFatalError("请设置 cellsDelegate", QXTableViewAutoHeight)
        }
    }

    open func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = sections[indexPath.section]
        let model = section.models[indexPath.row]
        if let delegate = cellsDelegate {
            return delegate.qxTableViewEstimatedCellHeight(model)
        } else {
            return QXDebugFatalError("请设置 cellsDelegate", QXTableViewAutoHeight)
        }
    }
//    open func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
//        return 30
//
//    }

    
//    open func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
//        let section = sections[section]
//        let model = section.header
//        if let delegate = cellsDelegate {
//            return delegate.qxTableViewEstimatedHeaderHeight(model)
//        } else {
//            return QXDebugFatalError("请设置 cellsDelegate", QXTableViewAutoHeight)
//        }
//    }
//    open func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
//        let section = sections[section]
//        let model = section.footer
//        if let delegate = cellsDelegate {
//            return delegate.qxTableViewEstimatedFooterHeight(model)
//        } else {
//            return QXDebugFatalError("请设置 cellsDelegate", QXTableViewAutoHeight)
//        }
//    }
    
    open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let delegate = cellsDelegate {
            let section = sections[section]
            let model = section.header
            let id = delegate.qxTableViewHeaderViewReuseId(model)
            let view = delegate.qxTableViewHeaderView(model, id)
            view?.model = model
            return view
        } else {
            return QXDebugFatalError("请设置 cellsDelegate", UITableViewHeaderFooterView())
        }
    }

    open func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if let delegate = cellsDelegate {
            let section = sections[section]
            let model = section.footer
            let id = delegate.qxTableViewFooterViewReuseId(model)
            let view = delegate.qxTableViewFooterView(model, id)
            view?.model = model
            return view
        } else {
            return QXDebugFatalError("请设置 cellsDelegate", UITableViewHeaderFooterView())
        }
    }

    open func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
}

extension QXTableView: QXRefreshableViewProtocol {
    
    public func qxSetRefreshHeader(_ header: QXRefreshHeader?) {
        nsTableView.mj_header = header
    }
    public func qxSetRefreshFooter(_ footer: QXRefreshFooter?) {
        nsTableView.mj_footer = footer
    }
    public func qxReloadData() {
        nsTableView.reloadData()
    }
    
}
