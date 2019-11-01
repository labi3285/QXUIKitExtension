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

public protocol QXTableViewDelegate: class {
    func qxTableViewCellClass(_ model: Any?) -> QXTableViewCell.Type?
    func qxTableViewHeaderFooterViewClass(_ model: Any?) -> QXTableViewHeaderFooterView.Type?
    func qxTableViewMoveCell(_ indexPath: IndexPath, _ toIndexPath: IndexPath)
}
extension QXTableViewDelegate {
    func qxTableViewCellClass(_ model: Any?) -> QXTableViewCell.Type? { return nil }
    func qxTableViewHeaderFooterViewClass(_ model: Any?) -> QXTableViewHeaderFooterView.Type? { return nil }
    func qxTableViewMoveCell(_ indexPath: IndexPath, _ toIndexPath: IndexPath) { }
}

open class QXTableViewCell: UITableViewCell {
    
    open var model: Any?
    
    public weak fileprivate(set) var tableView: QXTableView?
    public fileprivate(set) var indexPath: IndexPath?
    public fileprivate(set) var isFirstCellInSection: Bool = false
    public fileprivate(set) var isLastCellInSection: Bool = false
    public fileprivate(set) var cellWidth: CGFloat = 0

    open class func height(_ model: Any?, _ width: CGFloat) -> CGFloat? { return nil }
    open class func editActions(_ model: Any?) -> [UITableViewRowAction]? { return nil }
    open class func editCommit(_ model: Any?, _ editingStyle: UITableViewCell.EditingStyle) {}
    open class func canMove(_ model: Any?) -> [UITableViewRowAction]? { return nil }
    open class func estimatedHeight(_ model: Any?, _ width: CGFloat) -> CGFloat { QXTableViewAutoHeight }
    open func willDisplay() { }
    open func didEndDisplaying() { }

    open func initializedWithTable() { }
    
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
    
    public weak fileprivate(set) var tableView: QXTableView?
    public fileprivate(set) var section: Int?
    public fileprivate(set) var viewWidth: CGFloat = 0
        
    open class func height(_ model: Any?, _ width: CGFloat) -> CGFloat? { return nil }
    open class func estimatedHeight(_ model: Any?, _ width: CGFloat) -> CGFloat { QXTableViewAutoHeight }
    open func willDisplay() {}
    open func didEndDisplaying() {}
    
    open func initializedWithTable() { }

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

open class QXTableViewBreakLineCell: QXTableViewCell {
        
    open override func initializedWithTable() {
        super.initializedWithTable()
        breakLine.isHidden = isLastCellInSection
    }

    public lazy var breakLine: QXLineView = {
        let one = QXLineView.breakLine
        one.isVertical = false
        one.isHidden = false
        one.isUserInteractionEnabled = false
        return one
    }()
    
    required public init(_ reuseId: String) {
        super.init(reuseId)
        contentView.addSubview(breakLine)
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    open override func layoutSubviews() {
        super.layoutSubviews()
        let h = breakLine.intrinsicContentSize.height
        breakLine.frame = CGRect(x: 0, y: contentView.frame.height - h, width: contentView.frame.width, height: h)
        bringSubviewToFront(breakLine)
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
    
    public weak var delegate: QXTableViewDelegate?
    public var sections: [QXTableViewSection] = []
    
    open func setNeedsUpdate() {
        if _isNeedsUpdate {
            return
        }
        _isNeedsUpdate = true
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.15) {
            if self._isNeedsUpdate {
                self.update()
            }
        }
    }
    private var _isNeedsUpdate: Bool = false
    
    open func update() {
        uiTableView.beginUpdates()
        uiTableView.endUpdates()
        _isNeedsUpdate = false
    }
    
    /// 默认是group
    public var isPlain: Bool {
        set {
            if newValue {
                if uiTableView.style != .plain {
                    uiTableView = UITableView(frame: CGRect.zero, style: .plain)
                    updateUITableView()
                }
            } else {
                if uiTableView.style == .plain {
                    uiTableView = UITableView(frame: CGRect.zero, style: .grouped)
                    updateUITableView()
                }
            }
        }
        get {
            return uiTableView.style == .plain
        }
    }

    public private(set) var uiTableView: UITableView = UITableView(frame: CGRect.zero, style: .grouped)
    
    open func updateUITableView() {
        uiTableView.backgroundColor = UIColor.clear
        uiTableView.separatorStyle = .none
        uiTableView.qxCheckOrRemoveFromSuperview()
        addSubview(uiTableView)
        uiTableView.delegate = self
        uiTableView.dataSource = self
        setNeedsLayout()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        uiTableView.frame = bounds.qxSubRect(padding.uiEdgeInsets)
    }
    
    required override public init() {
        super.init()
        updateUITableView()
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
        let section = sections[indexPath.section]
        let model = section.models[indexPath.row]
        let cell: QXTableViewCell
        if let e = model as? QXStaticBaseCell {
            cell = e
        } else {
            let id: String
            if let e = model {
                id = "\(type(of: e))"
            } else {
                id = "NULL"
            }
            let cls: QXTableViewCell.Type
            if let e = delegate?.qxTableViewCellClass(model) {
                cls = e
            } else {
                cls = QXDebugTableViewCell.self
            }
            cell = cls.init(id)
        }
        cell.tableView = self
        cell.indexPath = indexPath
        cell.isFirstCellInSection = indexPath.row == 0
        cell.isLastCellInSection = indexPath.row == section.models.count - 1
        cell.cellWidth = uiTableView.bounds.width
        cell.initializedWithTable()
        cell.model = model
        return cell
    }
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = sections[indexPath.section]
        let model = section.models[indexPath.row]
        if let e = model as? QXStaticBaseCell {
            if let e = type(of: e).height(model, uiTableView.bounds.width) {
                return e
            }
        } else if let e = delegate?.qxTableViewCellClass(model) {
            if let e = e.height(model, uiTableView.bounds.width) {
                return e
            }
        }
        return QXTableViewAutoHeight
    }
    
    open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let _section = sections[section]
        let model = _section.header
        let view: QXTableViewHeaderFooterView?
        if let e = model as? QXStaticBaseHeaderFooterView {
            view = e
        } else {
            let id: String
            if let e = model {
                id = "\(type(of: e))"
            } else {
                id = "NULL"
            }
            if let e = delegate?.qxTableViewHeaderFooterViewClass(model) {
                view = e.init(id)
            } else {
                view = nil
            }
        }
        if let e = view {
            e.tableView = self
            e.section = section
            e.viewWidth = uiTableView.bounds.width
            e.initializedWithTable()
            e.model = model
            return e
        }
        return nil
    }
    open func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let _section = sections[section]
        let model = _section.footer
        let view: QXTableViewHeaderFooterView?
        if let e = model as? QXStaticBaseHeaderFooterView {
            view = e
        } else {
            let id: String
            if let e = model {
                id = "\(type(of: e))"
            } else {
                id = "NULL"
            }
            if let e = delegate?.qxTableViewHeaderFooterViewClass(model) {
                view = e.init(id)
            } else {
                view = nil
            }
        }
        if let e = view {
            e.tableView = self
            e.section = section
            e.viewWidth = uiTableView.bounds.width
            e.initializedWithTable()
            e.model = model
            return e
        }
        return nil
    }
            
    open func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let section = sections[section]
        let model = section.footer
        if let e = model as? QXStaticBaseHeaderFooterView {
           if let e = type(of: e).height(model, uiTableView.bounds.width) {
               return e
           }
        } else if let e = delegate?.qxTableViewHeaderFooterViewClass(model) {
           if let e = e.height(model, uiTableView.bounds.width) {
               return e
           }
        }
        return QXTableViewNoneHeight
    }
    open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let section = sections[section]
        let model = section.footer
        if let e = model as? QXStaticBaseHeaderFooterView {
           if let e = type(of: e).height(model, uiTableView.bounds.width) {
               return e
           }
        } else if let e = delegate?.qxTableViewHeaderFooterViewClass(model) {
           if let e = e.height(model, uiTableView.bounds.width) {
               return e
           }
        }
        return QXTableViewNoneHeight
    }
    open func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = sections[indexPath.section]
        let model = section.models[indexPath.row]
        if let e = delegate?.qxTableViewCellClass(model)?.estimatedHeight(model, uiTableView.bounds.width) {
            return e
        }
        return QXTableViewAutoHeight
    }
        
    open func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let section = sections[indexPath.section]
        let model = section.models[indexPath.row]
        if let e = delegate?.qxTableViewCellClass(model)?.editActions(model) {
            return e.count > 0
        }
        return false
    }
    open func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        let section = sections[indexPath.section]
        let model = section.models[indexPath.row]
        if let e = delegate?.qxTableViewCellClass(model)?.canMove(model) {
          return e.count > 0
        }
        return false
    }
    
    open func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let section = sections[indexPath.section]
        let model = section.models[indexPath.row]
        delegate?.qxTableViewCellClass(model)?.editCommit(model, editingStyle)
    }
    
    open func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let section = sections[indexPath.section]
        let model = section.models[indexPath.row]
        return delegate?.qxTableViewCellClass(model)?.editActions(model)
    }

    open func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        delegate?.qxTableViewMoveCell(sourceIndexPath, destinationIndexPath)
    }
    
    open func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as? QXTableViewCell)?.willDisplay()
    }
    open func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as? QXTableViewCell)?.didEndDisplaying()
    }
    open func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as? QXTableViewHeaderFooterView)?.willDisplay()
    }
    open func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        (view as? QXTableViewHeaderFooterView)?.willDisplay()
    }

    open func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
        (view as? QXTableViewHeaderFooterView)?.didEndDisplaying()
    }
    open func tableView(_ tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int) {
        (view as? QXTableViewHeaderFooterView)?.didEndDisplaying()
    }

    open func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
}

extension QXTableView: QXRefreshableViewProtocol {
    public func qxDisableAutoInserts() {
        uiTableView.qxDisableAutoInserts()
    }
    public func qxSetRefreshHeader(_ header: QXRefreshHeader?) {
        uiTableView.mj_header = header
    }
    public func qxSetRefreshFooter(_ footer: QXRefreshFooter?) {
        uiTableView.mj_footer = footer
    }
    public func qxReloadData() {
        uiTableView.reloadData()
    }
    public func qxUpdateModels(_ models: [Any]) {
        let section = QXTableViewSection(models, nil, nil)
        self.sections = [section]
    }
}


class QXDebugTableViewCell: QXTableViewBreakLineCell {
    
    open override func initializedWithTable() {
        super.initializedWithTable()
        label.intrinsicWidth = cellWidth
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
    
    open override func initializedWithTable() {
        super.initializedWithTable()
        label.intrinsicWidth = viewWidth
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
