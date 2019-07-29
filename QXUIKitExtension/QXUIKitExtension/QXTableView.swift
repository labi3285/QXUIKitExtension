//
//  QXTableView.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/7/27.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit
import MJRefresh

public let QXTableViewAutoHeight = UITableView.automaticDimension

public protocol QXTableViewCellProtocol {
    
    /// [Required]
    func qxTableViewCell(_ model: Any?, _ reuseId: String) -> QXTableViewCell

    // [Optional]
    func qxTableViewCellReuseId(_ model: Any?) -> String
    func qxTableViewCellHeight(_ model: Any?) -> CGFloat
    func qxTableViewCellCanEdit(_ model: Any?) -> Bool
    func qxTableViewCellEditActions(_ model: Any?) -> [UITableViewRowAction]?

//    func qxTableViewCellCanMove(_ model: Any?) -> Bool
    
}

extension QXTableViewCellProtocol {
    
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
}

open class QXTableViewCell: UITableViewCell {
    
    open var model: Any?
    
    required public init(reuseId: String) {
        super.init(style: .default, reuseIdentifier: reuseId)
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
    
    public var cellsDelegate: QXTableViewCellProtocol?
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
    
    
    
//    @available(iOS 2.0, *)
//    optional func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
//
//    @available(iOS 6.0, *)
//    optional func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
//
//    @available(iOS 6.0, *)
//    optional func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int)
//
//    @available(iOS 6.0, *)
//    optional func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath)
//
//    @available(iOS 6.0, *)
//    optional func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int)
//
//    @available(iOS 6.0, *)
//    optional func tableView(_ tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int)
//

    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = sections[indexPath.section]
        let model = section.models[indexPath.row]
        if let delegate = cellsDelegate {
            return delegate.qxTableViewCellHeight(model)
        } else {
            return QXDebugFatalError("请设置 cellsDelegate", QXTableViewAutoHeight)
        }
    }
//
//    @available(iOS 2.0, *)
//    optional func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
//
//    @available(iOS 2.0, *)
//    optional func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
//
//    @available(iOS 7.0, *)
//    optional func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
//
//    @available(iOS 7.0, *)
//    optional func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat
//
//    @available(iOS 7.0, *)
//    optional func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat
//
//    @available(iOS 2.0, *)
//    optional func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
//
//    @available(iOS 2.0, *)
//    optional func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?
//
//    @available(iOS 2.0, *)
//    optional func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath)
//
//    @available(iOS 6.0, *)
//    optional func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool
//
//    @available(iOS 6.0, *)
//    optional func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath)
//
//    @available(iOS 6.0, *)
//    optional func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath)
//
//    @available(iOS 2.0, *)
//    optional func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath?
//
//    @available(iOS 3.0, *)
//    optional func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath?
//
//    @available(iOS 2.0, *)
//    optional func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
//
//    @available(iOS 3.0, *)
//    optional func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath)
//
//    @available(iOS 2.0, *)
//    optional func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle
//
//    @available(iOS 3.0, *)
//    optional func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String?
//
//    @available(iOS 8.0, *)
//    optional func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?
//
//    @available(iOS 11.0, *)
//    optional func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
//
//    @available(iOS 11.0, *)
//    optional func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
//
//    @available(iOS 2.0, *)
//    optional func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool
//
//    @available(iOS 2.0, *)
//    optional func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath)
//
//    @available(iOS 2.0, *)
//    optional func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?)
//
//    @available(iOS 2.0, *)
//    optional func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath
//
//    @available(iOS 2.0, *)
//    optional func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int
//
//    @available(iOS 5.0, *)
//    optional func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool
//
//    @available(iOS 5.0, *)
//    optional func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool
//
//    @available(iOS 5.0, *)
//    optional func tableView(_ tableView: UITableView, performAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?)
//
//    @available(iOS 9.0, *)
//    optional func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool
//
//    @available(iOS 9.0, *)
//    optional func tableView(_ tableView: UITableView, shouldUpdateFocusIn context: UITableViewFocusUpdateContext) -> Bool
//
//    @available(iOS 9.0, *)
//    optional func tableView(_ tableView: UITableView, didUpdateFocusIn context: UITableViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator)
//
//    @available(iOS 9.0, *)
//    optional func indexPathForPreferredFocusedView(in tableView: UITableView) -> IndexPath?
//
//    @available(iOS 11.0, *)
//    optional func tableView(_ tableView: UITableView, shouldSpringLoadRowAt indexPath: IndexPath, with context: UISpringLoadedInteractionContext) -> Bool
    
    
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
