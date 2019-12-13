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
    func qxTableViewHeaderViewClass(_ model: Any?) -> QXTableViewHeaderFooterView.Type?
    func qxTableViewFooterViewClass(_ model: Any?) -> QXTableViewHeaderFooterView.Type?
    
    func qxTableViewDidSelectCell(_ model: Any?)
    func qxTableViewDidSelectHeaderView(_ model: Any?)
    func qxTableViewDidSelectFooterView(_ model: Any?)

    func qxTableViewMoveCell(_ indexPath: IndexPath, _ toIndexPath: IndexPath)
}
extension QXTableViewDelegate {
    public func qxTableViewCellClass(_ model: Any?) -> QXTableViewCell.Type? { return nil }
    public func qxTableViewHeaderViewClass(_ model: Any?) -> QXTableViewHeaderFooterView.Type? { return nil }
    public func qxTableViewFooterViewClass(_ model: Any?) -> QXTableViewHeaderFooterView.Type? { return nil }
    
    public func qxTableViewDidSelectCell(_ model: Any?) { }
    public func qxTableViewDidSelectHeaderView(_ model: Any?) { }
    public func qxTableViewDidSelectFooterView(_ model: Any?) { }

    public func qxTableViewMoveCell(_ indexPath: IndexPath, _ toIndexPath: IndexPath) { }
}

public class QXTableViewSection {
    
    public var indexTitle: String? = nil
    public var header: Any? = nil
    public var models: [Any?] = []
    public var footer: Any? = nil
    
    public var isDisplay: Bool = true
    
    public init(_ models: [Any?]) {
        self.models = models
    }
    public init(_ models: [Any?], _ header: Any?, _ footer: Any?) {
        self.models = models
        self.header = header
        self.footer = footer
    }
    
}

public func >> (lhs: Any.Type, rhs: QXTableViewCell.Type) -> (Any.Type, QXTableViewCell.Type) {
    return (lhs, rhs)
}
public func >> (lhs: Any.Type, rhs: QXTableViewHeaderFooterView.Type) -> (Any.Type, QXTableViewHeaderFooterView.Type) {
    return (lhs, rhs)
}

public struct QXTableViewAdapter {
    
    private let cellsInfoDic: [String: QXTableViewCell.Type]
    private let headerViewsInfoDic: [String: QXTableViewHeaderFooterView.Type]?
    private let footerViewsInfoDic: [String: QXTableViewHeaderFooterView.Type]?
    
    public init(_ cellsMappings: [(Any.Type, QXTableViewCell.Type)]) {
        self.init(cellsMappings, headerMappings: nil, footerMappings: nil)
    }
    public init(_ cellsMappings: [(Any.Type, QXTableViewCell.Type)],
                headerMappings: [(Any.Type, QXTableViewHeaderFooterView.Type)]?,
                footerMappings: [(Any.Type, QXTableViewHeaderFooterView.Type)]?) {
        do {
            var dic = [String: QXTableViewCell.Type]()
            for e in cellsMappings {
                dic["\(e.0)"] = e.1
            }
            self.cellsInfoDic = dic
        }
        if let ms = headerMappings {
            var dic = [String: QXTableViewHeaderFooterView.Type]()
            for e in ms {
                dic["\(e.0)"] = e.1
            }
            self.headerViewsInfoDic = dic
        } else {
            self.headerViewsInfoDic = nil
        }
        if let ms = footerMappings {
            var dic = [String: QXTableViewHeaderFooterView.Type]()
            for e in ms {
                dic["\(e.0)"] = e.1
            }
            self.footerViewsInfoDic = dic
        } else {
            self.footerViewsInfoDic = nil
        }
    }
    public func cellClass(_ model: Any?) -> QXTableViewCell.Type? {
        if let m = model {
            return cellsInfoDic["\(type(of: m))"]
        }
        return nil
    }
    public func headerViewClass(_ model: Any?) -> QXTableViewHeaderFooterView.Type? {
        if let m = model, let ms = headerViewsInfoDic {
            return ms["\(type(of: m))"]
        }
        return nil
    }
    public func footerViewClass(_ model: Any?) -> QXTableViewHeaderFooterView.Type? {
        if let m = model, let ms = footerViewsInfoDic {
            return ms["\(type(of: m))"]
        }
        return nil
    }
}

open class QXTableView: QXView, UIGestureRecognizerDelegate {
    
    public var adapter: QXTableViewAdapter?
    public weak var delegate: QXTableViewDelegate?
    
    public var respondTapBackground: (() -> ())?
    
    public func reloadData() {
        uiTableView.reloadData()
    }
    
    open var sections: [QXTableViewSection] = [] {
        didSet {
            var ss: [QXTableViewSection] = []
            for s in sections {
                if s.isDisplay {
                    var ms: [Any?] = []
                    for c in s.models {
                        if let c = c as? QXStaticCell {
                            if c.isDisplay {
                                ms.append(c)
                            }
                        } else {
                            ms.append(c)
                        }
                    }
                    if ms.count > 0 {
                        let s = QXTableViewSection(ms, s.header, s.footer)
                        ss.append(s)
                    }
                }
            }
            _cacheSections = ss
        }
    }
    fileprivate var _cacheSections: [QXTableViewSection] = []

    public var sectionHeaderSpace: CGFloat = QXTableViewNoneHeight
    public var sectionFooterSpace: CGFloat = QXTableViewNoneHeight
    
    public var headView: UIView? {
        set {
            if let e = newValue {
                if e.frame.width == 0 && e.frame.height == 0 {
                    let h = e.intrinsicContentSize.height
                    e.frame = CGRect(x: 0, y: 0, width: 1, height: h)
                }
                uiTableView.tableHeaderView = e
            } else {
                uiTableView.tableHeaderView = nil
            }
        }
        get {
            return uiTableView.tableHeaderView
        }
    }
    public func updateHeadView() {
        if let e = uiTableView.tableHeaderView {
            uiTableView.tableHeaderView = nil
            uiTableView.tableHeaderView = e
        }
    }
    
    public var footView: UIView? {
       set {
           if let e = newValue {
               if e.frame.width == 0 && e.frame.height == 0 {
                   let h = e.intrinsicContentSize.height
                   e.frame = CGRect(x: 0, y: 0, width: 1, height: h)
               }
               uiTableView.tableFooterView = e
           }
       }
       get {
           return uiTableView.tableFooterView
       }
    }
    public func updateFootView() {
        if let e = uiTableView.tableFooterView {
            uiTableView.tableFooterView = nil
            uiTableView.tableFooterView = e
        }
    }
    
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
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        uiTableView.frame = bounds.qxSubRect(padding.uiEdgeInsets)
    }
    
//    open override func natureContentSize() -> QXSize {
//        var h: CGFloat = 0
//        for (i, e) in _cacheSections.enumerated() {
//
//
//        }
//
//
//    }
        
    required override public init() {
        super.init()
        updateUITableView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapOnBackground))
        tap.delegate = self
        addGestureRecognizer(tap)
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view === uiTableView || touch.view === self {
            return true
        }
        return false
    }
    @objc func handleTapOnBackground() {
        respondTapBackground?()
    }

}
extension QXTableView: UITableViewDelegate, UITableViewDataSource {
        
    open func numberOfSections(in tableView: UITableView) -> Int {
        return _cacheSections.count
    }
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _cacheSections[section].models.count
    }
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = _cacheSections[indexPath.section]
        let model = section.models[indexPath.row]
        let cell: QXTableViewCell
        if let e = model as? QXStaticCell {
            cell = e
        } else {
            let id: String
            if let e = model {
                id = "\(type(of: e))"
            } else {
                id = "NULL"
            }
            let cls: QXTableViewCell.Type
            if let e = adapter?.cellClass(model) ?? delegate?.qxTableViewCellClass(model) {
                cls = e
            } else {
                if model is QXSpace {
                    cls = QXTableViewSpaceCell.self
                } else {
                    cls = QXTableViewDebugCell.self
                }
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
        cell.respondClickCell = { [weak self] in
            self?.delegate?.qxTableViewDidSelectCell(model)
        }
        return cell
    }
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = _cacheSections[indexPath.section]
        let model = section.models[indexPath.row]
        if let e = model as? QXStaticCell {
            if !e.isDisplay {
                return 0
            }
            if let e = e.fixHeight {
                return e
            } else if let e = type(of: e).height(model, uiTableView.bounds.width) {
                return e
            }
        } else if let e = adapter?.cellClass(model) ?? delegate?.qxTableViewCellClass(model) {
            if let e = e.height(model, uiTableView.bounds.width) {
                return e
            }
        } else if let e = model as? QXSpace {
            return e.space
        }
        return QXTableViewAutoHeight
    }
    
    open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let _section = _cacheSections[section]
        let model = _section.header
        let view: QXTableViewHeaderFooterView?
        if let e = model as? QXStaticHeaderFooterView {
            view = e
        } else {
            let id: String
            if let e = model {
                id = "\(type(of: e))"
            } else {
                id = "NULL"
            }
            if let e = delegate?.qxTableViewHeaderViewClass(model) {
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
            e.respondClickView = { [weak self] in
                self?.delegate?.qxTableViewDidSelectHeaderView(model)
            }
            return e
        }
        return nil
    }
    open func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let _section = _cacheSections[section]
        let model = _section.footer
        let view: QXTableViewHeaderFooterView?
        if let e = model as? QXStaticHeaderFooterView {
            view = e
        } else {
            let id: String
            if let e = model {
                id = "\(type(of: e))"
            } else {
                id = "NULL"
            }
            if let e = delegate?.qxTableViewFooterViewClass(model) {
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
            e.respondClickView = { [weak self] in
                self?.delegate?.qxTableViewDidSelectFooterView(model)
            }
            return e
        }
        return nil
    }
         
    open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let section = _cacheSections[section]
        let model = section.header
        if let e = model as? QXStaticHeaderFooterView {
            if let e = e.fixHeight {
                return e
            } else if let e = type(of: e).height(model, uiTableView.bounds.width) {
                return e
            }
        } else if let e = delegate?.qxTableViewHeaderViewClass(model) {
            if let e = e.height(model, uiTableView.bounds.width) {
                return e
            }
        } else if let e = model as? QXSpace {
            return e.space
        }
        return sectionHeaderSpace
    }
    open func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let section = _cacheSections[section]
        let model = section.footer
        if let e = model as? QXStaticHeaderFooterView {
            if let e = e.fixHeight {
                return e
            } else if let e = type(of: e).height(model, uiTableView.bounds.width) {
                return e
            }
        } else if let e = delegate?.qxTableViewFooterViewClass(model) {
            if let e = e.height(model, uiTableView.bounds.width) {
                return e
            }
        } else if let e = model as? QXSpace {
            return e.space
        }
        return sectionHeaderSpace
    }
    open func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = _cacheSections[indexPath.section]
        let model = section.models[indexPath.row]
        if let e = adapter?.cellClass(model) ?? delegate?.qxTableViewCellClass(model) {
            return e.estimatedHeight(model, uiTableView.bounds.width)
        }
        return QXTableViewAutoHeight
    }
    
    public func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
//        let section = _cacheSections[indexPath.section]
//        let model = section.models[indexPath.row]
//        if let e = adapter?.cellClass(model) ?? delegate?.qxTableViewCellClass(model) {
//            return e.editingStyle(model)
//        }
        return .none
    }
    open func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let section = _cacheSections[indexPath.section]
        let model = section.models[indexPath.row]
        if let e = adapter?.cellClass(model) ?? delegate?.qxTableViewCellClass(model) {
            return e.canEdit(model)
        }
        return false
    }
    open func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
//        let section = _cacheSections[indexPath.section]
//        let model = section.models[indexPath.row]
//        if let e = adapter?.cellClass(model) ?? delegate?.qxTableViewCellClass(model) {
//            return e.canMove(model)
//        }
        return false
    }
    
    open func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        let section = _cacheSections[indexPath.section]
//        let model = section.models[indexPath.row]
//        (adapter?.cellClass(model) ?? delegate?.qxTableViewCellClass(model))?.editCommit(model, editingStyle)
    }
    
    open func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let section = _cacheSections[indexPath.section]
        let model = section.models[indexPath.row]
        return (adapter?.cellClass(model) ?? delegate?.qxTableViewCellClass(model))?.editActions(model)
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
        reloadData()
    }
    public func qxUpdateModels(_ models: [Any]) {
        if let e = models as? [QXTableViewSection] {
            self.sections = e
        } else {
            let section = QXTableViewSection(models, nil, nil)
            self.sections = [section]
        }
        reloadData()
    }
}

open class QXTableViewCell: UITableViewCell {
    
    open var model: Any?
    
    public weak fileprivate(set) var tableView: QXTableView?
    public fileprivate(set) var indexPath: IndexPath?
    public fileprivate(set) var isFirstCellInSection: Bool = false
    public fileprivate(set) var isLastCellInSection: Bool = false
    public fileprivate(set) var cellWidth: CGFloat = 0

    open class func height(_ model: Any?, _ width: CGFloat) -> CGFloat? { return nil }
    
//    open class func editingStyle(_ model: Any?) -> UITableViewCell.EditingStyle { return .insert }
    
    open class func canEdit(_ model: Any?) -> Bool { return false }
    open class func editActions(_ model: Any?) -> [UITableViewRowAction]? { return nil }
//    open class func editCommit(_ model: Any?, _ editingStyle: UITableViewCell.EditingStyle) {}
//    open class func canMove(_ model: Any?) -> Bool { return true }
    open class func estimatedHeight(_ model: Any?, _ width: CGFloat) -> CGFloat { QXTableViewAutoHeight }
    open func willDisplay() { }
    open func didEndDisplaying() { }
    open func didClickCell() { respondClickCell?() }

    open func initializedWithTable() { }
    
    fileprivate var respondClickCell: (() -> ())?
    public final lazy var backButton: QXButton = {
        let e = QXButton()
        e.backView.backgroundColorHighlighted = QXColor.dynamicHiglight
        e.respondClick = { [weak self] in
            self?.didClickCell()
        }
        return e
    }()
    
    public required init(_ reuseId: String) {
        super.init(style: .default, reuseIdentifier: reuseId)
        backgroundView = UIView()
        contentView.backgroundColor = UIColor.clear
        backgroundColor = UIColor.clear
        contentView.addSubview(backButton)
        selectionStyle = .none
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override open func layoutSubviews() {
        super.layoutSubviews()
        backButton.frame = contentView.bounds
    }
    open override var description: String {
        return "\(type(of: self))\(self.frame)"
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
    open func didClickView() { respondClickView?() }

    open func initializedWithTable() { }
    
    fileprivate var respondClickView: (() -> ())?
    public final lazy var backButton: QXButton = {
        let e = QXButton()
        e.backView.backgroundColorHighlighted = QXColor.dynamicHiglight
        e.respondClick = { [weak self] in
            self?.didClickView()
        }
        return e
    }()

    public required init(_ reuseId: String) {
        super.init(reuseIdentifier: reuseId)
        backgroundView = UIView()
        contentView.backgroundColor = UIColor.clear
        backgroundColor = UIColor.clear
        contentView.addSubview(backButton)
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override open func layoutSubviews() {
        super.layoutSubviews()
        backButton.frame = contentView.bounds
    }
    open override var description: String {
        return "\(type(of: self))\(self.frame)"
    }
    
}

open class QXTableViewBreakLineCell: QXTableViewCell {
        
    override open func initializedWithTable() {
        super.initializedWithTable()
        breakLine.isHidden = isLastCellInSection
    }

    public final lazy var breakLine: QXLineView = {
        let e = QXLineView.breakLine
        e.isVertical = false
        e.isHidden = false
        e.isUserInteractionEnabled = false
        return e
    }()
    
    public required init(_ reuseId: String) {
        super.init(reuseId)
        contentView.addSubview(breakLine)
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override open func layoutSubviews() {
        super.layoutSubviews()
        let h = breakLine.intrinsicContentSize.height
        breakLine.frame = CGRect(x: 0, y: contentView.frame.height - h, width: contentView.frame.width, height: h)
        bringSubviewToFront(breakLine)
    }

}

class QXTableViewDebugCell: QXTableViewBreakLineCell {
    
    override open func initializedWithTable() {
        super.initializedWithTable()
        label.fixWidth = cellWidth
    }
    
    override var model: Any? {
        didSet {
            super.model = model
            label.text = "\(model ?? "nil")"
        }
    }
    public final lazy var label: QXLabel = {
        let e = QXLabel()
        e.padding = QXEdgeInsets(10, 15, 10, 15)
        e.font = QXFont(14, QXColor.dynamicText)
        
        
        e.numberOfLines = 0
        return e
    }()
    required init(_ reuseId: String) {
        super.init(reuseId)
        contentView.addSubview(label)
        label.IN(contentView).LEFT.RIGHT.TOP.BOTTOM.MAKE()
        breakLine.padding = QXEdgeInsets(0, 15, 0, 15)
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
class QXTableViewSpaceCell: QXTableViewCell {
    override class func height(_ model: Any?, _ width: CGFloat) -> CGFloat? {
        if let e = model as? QXSpace {
            return e.space
        }
        return nil
    }
    required init(_ reuseId: String) {
        super.init(reuseId)
        backButton.isDisplay = false
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class QXDebugTableViewHeaderFooterView: QXTableViewHeaderFooterView {
    
    override open func initializedWithTable() {
        super.initializedWithTable()
        label.fixWidth = viewWidth
    }
    
    override var model: Any? {
        didSet {
            super.model = model
            label.text = "\(model ?? "nil")"
        }
    }
    public final lazy var label: QXLabel = {
        let e = QXLabel()
        e.padding = QXEdgeInsets(10, 15, 10, 15)
        e.font = QXFont(14, QXColor.dynamicText)
        e.numberOfLines = 0
        return e
    }()
    required init(_ reuseId: String) {
        super.init(reuseId)
        contentView.addSubview(label)
        label.IN(contentView).LEFT.RIGHT.TOP.BOTTOM.MAKE()
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


