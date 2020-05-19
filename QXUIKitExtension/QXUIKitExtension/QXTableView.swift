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
    func tableViewDidSetupCell(_ cell: QXTableViewCell, for model: Any, in section: QXTableViewSection)
    func tableViewDidSelectCell(_ cell: QXTableViewCell, for model: Any, in section: QXTableViewSection)
    
    func tableViewDidSetupHeaderView(_ headerView: QXTableViewHeaderFooterView, for model: Any, in section: QXTableViewSection)
    func tableViewDidSelectHeaderView(_ headerView: QXTableViewHeaderFooterView, for model: Any, in section: QXTableViewSection)
    
    func tableViewDidSetupFooterView(_ footerView: QXTableViewHeaderFooterView, for model: Any, in section: QXTableViewSection)
    func tableViewDidSelectFooterView(_ footerView: QXTableViewHeaderFooterView, for model: Any, in section: QXTableViewSection)

    func tableViewDidMove(from: IndexPath, to: IndexPath, in sections: [QXTableViewSection])
    
    func tableViewNeedsReloadData()
}
public extension QXTableViewDelegate {
    func tableViewDidSetupCell(_ cell: QXTableViewCell, for model: Any, in section: QXTableViewSection) { }
    func tableViewDidSelectCell(_ cell: QXTableViewCell, for model: Any, in section: QXTableViewSection) { }
    
    func tableViewDidSetupHeaderView(_ headerView: QXTableViewHeaderFooterView, for model: Any, in section: QXTableViewSection) { }
    func tableViewDidSelectHeaderView(_ headerView: QXTableViewHeaderFooterView, for model: Any, in section: QXTableViewSection) { }
    
    func tableViewDidSetupFooterView(_ footerView: QXTableViewHeaderFooterView, for model: Any, in section: QXTableViewSection) { }
    func tableViewDidSelectFooterView(_ footerView: QXTableViewHeaderFooterView, for model: Any, in section: QXTableViewSection) { }

    func tableViewDidMove(from: IndexPath, to: IndexPath, in sections: [QXTableViewSection]) { }
    
    func tableViewNeedsReloadData() { }
}

public class QXTableViewSection {
    
    public var indexTitle: String? = nil
    public var header: Any? = nil
    public var models: [Any] = []
    public var footer: Any? = nil
    
    public var isDisplay: Bool = true
    
    public init(_ models: [Any]) {
        self.models = models
    }
    public init(_ models: [Any], _ header: Any?, _ footer: Any?) {
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
    
    fileprivate let cellsInfoDic: [String: QXTableViewCell.Type]
    fileprivate let headerViewsInfoDic: [String: QXTableViewHeaderFooterView.Type]?
    fileprivate let footerViewsInfoDic: [String: QXTableViewHeaderFooterView.Type]?
    
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

open class QXTableView: QXView {
        
    public weak var delegate: QXTableViewDelegate?
    public weak var scrollDelegate: UIScrollViewDelegate?
    
    public var adapter: QXTableViewAdapter?
    
    public func reloadData() {
        let ss = sections
        sections = ss
        uiTableView.reloadData()
    }
        
    open var sections: [QXTableViewSection] = [] {
        didSet {
            _cacheFlexRatioTotal = 0
            _cacheTotalFlexSpace = 0
            var ss: [QXTableViewSection] = []
            for s in sections {
                if s.isDisplay {
                    var header: Any?
                    if let e = s.header {
                        if let e = e as? QXStaticHeaderFooterView {
                            if e.isDisplay {
                                header = e
                            }
                        } else {
                            if let c = e as? QXFlexSpace {
                                _cacheFlexRatioTotal += c.ratio
                            }
                            header = e
                        }
                    }
                    var ms: [Any] = []
                    for c in s.models {
                        if let c = c as? QXStaticCell {
                            if c.isDisplay {
                                ms.append(c)
                            }
                        } else {
                            if let c = c as? QXFlexSpace {
                                _cacheFlexRatioTotal += c.ratio
                            }
                            ms.append(c)
                        }
                    }
                    var footer: Any?
                    if let e = s.footer {
                        if let e = e as? QXStaticHeaderFooterView {
                            if e.isDisplay {
                                footer = e
                            }
                        } else {
                            if let c = e as? QXFlexSpace {
                                _cacheFlexRatioTotal += c.ratio
                            }
                            footer = e
                        }
                    }
                    let s = QXTableViewSection(ms, header, footer)
                    ss.append(s)
                }
            }
            _cacheSections = ss
            if _cacheFlexRatioTotal > 0 {
                _cacheTotalFlexSpace = uiTableView.bounds.height - uiTableViewSize().h
                if _cacheTotalFlexSpace <= 0 {
                    _cacheTotalFlexSpace = 0
                }
            }
        }
    }
    fileprivate var _cacheSections: [QXTableViewSection] = []
    fileprivate var _cacheSectionTitles: [QXTableViewSection] = []
    fileprivate var _cacheFlexRatioTotal: CGFloat = 0
    fileprivate var _cacheTotalFlexSpace: CGFloat = 0

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
    
    public var isSortMode: Bool {
        set {
            uiTableView.isEditing = newValue
        }
        get {
            return uiTableView.isEditing
        }
    }

    public private(set) var uiTableView: UITableView = UITableView(frame: CGRect.zero, style: .grouped)
    
    open func updateUITableView() {
        uiTableView.backgroundColor = UIColor.clear
        uiTableView.separatorStyle = .none
        let e = isSortMode
        uiTableView.qxCheckOrRemoveFromSuperview()
        addSubview(uiTableView)
        uiTableView.delegate = self
        uiTableView.dataSource = self
        setNeedsLayout()
        for e in _uiTableViewAttendViews {
            uiTableView.qxCheckOrAddSubview(e)
            e.frame = uiTableView.bounds
        }
        if let e = adapter {
            adapter = e
        }
        self.isSortMode = e
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        uiTableView.frame = bounds.qxSubRect(padding.uiEdgeInsets)
    }
    
    open override func natureContentSize() -> QXSize {
        if let e = fixWidth ?? maxWidth {
            uiTableView.frame = CGRect(x: 0, y: 0, width: e - padding.left - padding.right, height: 999)
        }
        return uiTableViewSize().sizeByAdd(padding)
    }
        
    required override public init() {
        super.init()
        updateUITableView()
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func uiTableViewSize() -> QXSize {
        var h: CGFloat = 0
        for (section, e) in _cacheSections.enumerated() {
            if let e = headerViewHeight(for: section) {
                h += e
            } else {
                if let e = headerView(for: section) {
                    var size = CGSize(width: uiTableView.frame.width, height: 0)
                    size = e.systemLayoutSizeFitting(size, withHorizontalFittingPriority: .required, verticalFittingPriority: .defaultLow)
                    h += size.height
                }
            }
            for (i, _) in e.models.enumerated() {
                let indexPath = IndexPath(row: i, section: section)
                if let e = cellHeight(for: indexPath) {
                    h += e
                } else {
                    let e = cell(for: indexPath)
                    var size = CGSize(width: uiTableView.frame.width, height: 0)
                    size = e.systemLayoutSizeFitting(size, withHorizontalFittingPriority: .required, verticalFittingPriority: .defaultLow)
                    h += size.height
                }
            }
            if let e = footerViewHeight(for: section) {
                h += e
            } else {
                if let e = footerView(for: section) {
                    var size = CGSize(width: uiTableView.frame.width, height: 0)
                    size = e.systemLayoutSizeFitting(size, withHorizontalFittingPriority: .required, verticalFittingPriority: .defaultLow)
                    h += size.height
                }
            }
        }
        return QXSize(uiTableView.frame.width, h)
    }
    
    open func cell(for indexPath: IndexPath) -> QXTableViewCell {
        let s = _cacheSections[indexPath.section]
        let ms = s.models
        let m = ms[indexPath.row]
        let cell: QXTableViewCell
        if let e = m as? QXStaticCell {
            cell = e
        } else {
            let id = "\(type(of: m))"
            if let e = uiTableView.dequeueReusableCell(withIdentifier: id) as? QXTableViewCell {
                cell = e
            } else {
                let cls: QXTableViewCell.Type
                if let e = adapter?.cellClass(m) {
                    cls = e
                } else {
                    if m is QXSpace || m is QXFlexSpace {
                        cls = QXTableViewSpaceCell.self
                    } else {
                        cls = QXTableViewDebugCell.self
                    }
                }
                cell = cls.init(id)
            }
        }
        cell.respondReloadData = { [weak self] in
            self?.delegate?.tableViewNeedsReloadData()
        }
        delegate?.tableViewDidSetupCell(cell, for: m, in: s)
        cell.context = QXTableViewCell.Context(tableView: self, indexPath: indexPath, givenWidth: uiTableView.contentSize.width - uiTableView.contentInset.left - uiTableView.contentInset.right, isFirstCellInSection: indexPath.row == 0, isLastCellInSection: indexPath.row == ms.count - 1, isSortMode: isSortMode)
        cell.section = s
        cell.contextDidSetup()
        cell.model = m
        cell.respondClickCell = { [weak self, weak cell] in
            if let ws = self, let c = cell {
                ws.delegate?.tableViewDidSelectCell(c, for: m, in: s)
            }
        }
        return cell
    }
    open func cellHeight(for indexPath: IndexPath) -> CGFloat? {
        let ms = _cacheSections[indexPath.section].models
        let m = ms[indexPath.row]
        let ctx = QXTableViewCell.Context(tableView: self, indexPath: indexPath, givenWidth: uiTableView.contentSize.width - uiTableView.contentInset.left - uiTableView.contentInset.right, isFirstCellInSection: indexPath.row == 0, isLastCellInSection: indexPath.row == ms.count - 1, isSortMode: isSortMode)
        if let e = m as? QXStaticCell {
            if !e.isDisplay {
                return 0
            }
            if let e = e.fixHeight {
                return e
            } else if let e = type(of: e).height(m, ctx) {
                return e
            }
        } else if let e = adapter?.cellClass(m) {
            if let e = e.height(m, ctx) {
                return e
            }
        } else if let e = m as? QXSpace {
            return e.h
        } else if let e = m as? QXFlexSpace {
            return _cacheTotalFlexSpace * e.ratio / _cacheFlexRatioTotal
        }
        return nil
    }
    open func headerView(for section: Int) -> QXTableViewHeaderFooterView? {
        let s = _cacheSections[section]
        if let m = s.header {
            let view: QXTableViewHeaderFooterView?
            if let e = m as? QXStaticHeaderFooterView {
                view = e
            } else {
                let id = "\(type(of: m))"
                if let e = uiTableView.dequeueReusableHeaderFooterView(withIdentifier: id) as? QXTableViewHeaderFooterView {
                    view = e
                } else {
                    if let e = adapter?.headerViewClass(m) {
                        view = e.init(id)
                    } else {
                        view = nil
                    }
                }
            }
            if let e = view {
                e.respondReloadData = { [weak self] in
                    self?.delegate?.tableViewNeedsReloadData()
                }
                delegate?.tableViewDidSetupHeaderView(e, for: m, in: s)
                e.context = QXTableViewHeaderFooterView.Context(tableView: self, section: section, givenWidth: uiTableView.contentSize.width - uiTableView.contentInset.left - uiTableView.contentInset.right, isFirstSection: section == 0, isLastSection: section == _cacheSections.count - 1)
                e.section = s
                e.contextDidSetup()
                e.model = m
                e.respondClickView = { [weak self, weak e] in
                    if let ws = self, let v = e{
                        ws.delegate?.tableViewDidSelectHeaderView(v, for: m, in: s)
                    }
                }
                return e
            }
        }
        return nil
    }
    
    open func footerView(for section: Int) -> QXTableViewHeaderFooterView? {
        let s = _cacheSections[section]
        if let m = s.footer {
            let view: QXTableViewHeaderFooterView?
            if let e = m as? QXStaticHeaderFooterView {
                view = e
            } else {
                let id = "\(type(of: m))"
                if let e = uiTableView.dequeueReusableHeaderFooterView(withIdentifier: id) as? QXTableViewHeaderFooterView {
                    view = e
                } else {
                    if let e = adapter?.footerViewClass(m) {
                        view = e.init(id)
                    } else {
                        view = nil
                    }
                }
            }
            if let e = view {
                e.respondReloadData = { [weak self] in
                    self?.delegate?.tableViewNeedsReloadData()
                }
                delegate?.tableViewDidSetupFooterView(e, for: m, in: s)
                e.context = QXTableViewHeaderFooterView.Context(tableView: self, section: section, givenWidth: uiTableView.contentSize.width - uiTableView.contentInset.left - uiTableView.contentInset.right, isFirstSection: section == 0, isLastSection: section == _cacheSections.count - 1)
                e.section = s
                e.contextDidSetup()
                e.model = m
                e.respondClickView = { [weak self, weak e] in
                    if let ws = self, let v = e{
                        ws.delegate?.tableViewDidSelectFooterView(v, for: m, in: s)
                    }
                }
                return e
            }
            
        }
        return nil
    }
    
    open func headerViewHeight(for section: Int) -> CGFloat? {
        let m = _cacheSections[section].header
        let ctx = QXTableViewHeaderFooterView.Context(tableView: self, section: section, givenWidth: uiTableView.contentSize.width - uiTableView.contentInset.left - uiTableView.contentInset.right, isFirstSection: section == 0, isLastSection: section == _cacheSections.count - 1)
        if let e = m as? QXStaticHeaderFooterView {
            if let e = e.fixHeight {
                return e
            } else if let e = type(of: e).height(m, ctx) {
                return e
            }
        } else if let e = adapter?.headerViewClass(m) {
            if let e = e.height(m, ctx) {
                return e
            }
        } else if let e = m as? QXSpace {
            return e.h
        }
        return sectionHeaderSpace
    }
    open func footerViewHeight(for section: Int) -> CGFloat? {
        let m = _cacheSections[section].footer
        let ctx = QXTableViewHeaderFooterView.Context(tableView: self, section: section, givenWidth: uiTableView.contentSize.width - uiTableView.contentInset.left - uiTableView.contentInset.right, isFirstSection: section == 0, isLastSection: section == _cacheSections.count - 1)
        if let e = m as? QXStaticHeaderFooterView {
            if let e = e.fixHeight {
                return e
            } else if let e = type(of: e).height(m, ctx) {
                return e
            }
        } else if let e = adapter?.footerViewClass(m) {
            if let e = e.height(m, ctx) {
                return e
            }
        } else if let e = m as? QXSpace {
            return e.h
        }
        return sectionFooterSpace
    }
    
    fileprivate var _uiTableViewAttendViews: [UIView] = []

}
extension QXTableView: UITableViewDelegate, UITableViewDataSource {
        
    open func numberOfSections(in tableView: UITableView) -> Int {
        return _cacheSections.count
    }
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _cacheSections[section].models.count
    }
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cell(for: indexPath)
    }
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight(for: indexPath) ?? QXTableViewAutoHeight
    }
    open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerView(for: section)
    }
    open func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return footerView(for: section)
    }
         
    open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerViewHeight(for: section) ?? QXTableViewAutoHeight
    }
    open func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return footerViewHeight(for: section) ?? QXTableViewAutoHeight
    }
    open func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let ms = _cacheSections[indexPath.section].models
        let m = ms[indexPath.row]
        if let e = adapter?.cellClass(m) {
            let ctx = QXTableViewCell.Context(tableView: self, indexPath: indexPath, givenWidth: uiTableView.contentSize.width - uiTableView.contentInset.left - uiTableView.contentInset.right, isFirstCellInSection: indexPath.row == 0, isLastCellInSection: indexPath.row == ms.count - 1, isSortMode: isSortMode)
            return e.estimatedHeight(m, ctx)
        }
        return QXTableViewAutoHeight
    }
    
    public func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    open func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let ms = _cacheSections[indexPath.section].models
        let m = ms[indexPath.row]
        if let e = m as? QXStaticCell {
            return (e.editActions?.count ?? 0 > 0) || e.canMove
        } else if let e = adapter?.cellClass(m) {
            let ctx = QXTableViewCell.Context(tableView: self, indexPath: indexPath, givenWidth: uiTableView.contentSize.width - uiTableView.contentInset.left - uiTableView.contentInset.right, isFirstCellInSection: indexPath.row == 0, isLastCellInSection: indexPath.row == ms.count - 1, isSortMode: isSortMode)
            return (e.editActions(m, ctx)?.count ?? 0 > 0) || e.canMove(m, ctx)
        }
        return false
    }
    
    open func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let ms = _cacheSections[indexPath.section].models
        let m = ms[indexPath.row]
        if let e = m as? QXStaticCell {
            return e.editActions
        } else if let e = adapter?.cellClass(m) {
            let ctx = QXTableViewCell.Context(tableView: self, indexPath: indexPath, givenWidth: uiTableView.contentSize.width - uiTableView.contentInset.left - uiTableView.contentInset.right, isFirstCellInSection: indexPath.row == 0, isLastCellInSection: indexPath.row == ms.count - 1, isSortMode: isSortMode)
            return e.editActions(m, ctx)
        }
        return nil
    }
        
    open func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        let ms = _cacheSections[indexPath.section].models
        let m = ms[indexPath.row]
        if let e = m as? QXStaticCell {
            return e.canMove
        } else if let e = adapter?.cellClass(m) {
            let ctx = QXTableViewCell.Context(tableView: self, indexPath: indexPath, givenWidth: uiTableView.contentSize.width - uiTableView.contentInset.left - uiTableView.contentInset.right, isFirstCellInSection: indexPath.row == 0, isLastCellInSection: indexPath.row == ms.count - 1, isSortMode: isSortMode)
            return e.canMove(m, ctx)
        }
        return false
    }
    public func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        return proposedDestinationIndexPath
    }
    open func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let e = _cacheSections[sourceIndexPath.section].models[sourceIndexPath.row]
        _cacheSections[sourceIndexPath.section].models.remove(at: sourceIndexPath.row)
        _cacheSections[destinationIndexPath.section].models.insert(e, at: destinationIndexPath.row)
        delegate?.tableViewDidMove(from: sourceIndexPath, to: destinationIndexPath, in: _cacheSections)
        tableView.reloadData()
    }
    
    open func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // do noth
    }

    open func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if sections.first(where: { $0.isDisplay && $0.indexTitle != nil }) == nil {
            return nil
        } else {
            return sections.map { (e) -> String in
                if e.isDisplay, let t = e.indexTitle {
                    return t
                } else {
                    return ""
                }
            }
        }
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
    
    
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollDelegate?.scrollViewDidScroll?(scrollView)
    }
    open func scrollViewDidZoom(_ scrollView: UIScrollView) {
        scrollDelegate?.scrollViewDidZoom?(scrollView)
    }
    open func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollDelegate?.scrollViewWillBeginDragging?(scrollView)
    }
    open func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        scrollDelegate?.scrollViewWillEndDragging?(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
    open func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        scrollDelegate?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
    }
    open func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        scrollDelegate?.scrollViewWillBeginDecelerating?(scrollView)
    }
    open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollDelegate?.scrollViewDidEndDecelerating?(scrollView)
    }
    open func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        scrollDelegate?.scrollViewDidEndScrollingAnimation?(scrollView)
    }
    open func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        scrollDelegate?.scrollViewDidScrollToTop?(scrollView)
    }
    
}

extension QXTableView {
    
    @discardableResult public func mapModels<T>(_ modelType: T.Type) -> [T] {
        var ms: [T] = []
        for (_, s) in sections.enumerated() {
            for (_, r) in s.models.enumerated() {
                if let m = r as? T {
                    ms.append(m)
                }
            }
            if let m = s.header as? T {
                ms.append(m)
            } else if let m = s.footer as? T {
                ms.append(m)
            }
        }
        return ms
    }
    
    @discardableResult public func mapModels<T>(_ modelType: T.Type, _ todo: (T) -> Void) -> [T] {
        var ms: [T] = []
        for (_, s) in sections.enumerated() {
            for (_, r) in s.models.enumerated() {
                if let m = r as? T {
                    todo(m)
                    ms.append(m)
                }
            }
            if let m = s.header as? T {
                todo(m)
                ms.append(m)
            } else if let m = s.footer as? T {
                todo(m)
                ms.append(m)
            }
        }
        return ms
    }
    
    @discardableResult public func mapModels<T>(_ modelType: T.Type, _ todo: (T) -> T?) -> [T] {
        var ms: [T] = []
        for (_, s) in sections.enumerated() {
            for (_, r) in s.models.enumerated() {
                if let m = r as? T {
                    if let m = todo(m) {
                        ms.append(m)
                    }
                }
            }
            if let m = s.header as? T {
                if let m = todo(m) {
                    ms.append(m)
                }
            } else if let m = s.footer as? T {
                if let m = todo(m) {
                    ms.append(m)
                }
            }
        }
        return ms
    }
    
    @discardableResult public func reduceModels<T>(_ modelType: T.Type, _ todo: (T) -> T?) -> [T] {
        var ms: [T] = []
        for (_, s) in sections.enumerated() {
            for (i, r) in s.models.enumerated() {
                if let m = r as? T {
                    if let m = todo(m) {
                        ms.append(m)
                    } else {
                        s.models.remove(at: i)
                    }
                }
            }
            if let m = s.header as? T {
                if let m = todo(m) {
                    s.header = m
                    ms.append(m)
                } else {
                    s.header = nil
                }
            } else if let m = s.footer as? T {
                if let m = todo(m) {
                    s.footer = m
                    ms.append(m)
                } else {
                    s.footer = nil
                }
            }
        }
        return ms
    }
    
}

extension QXTableView: QXRefreshableViewProtocol {
    public func qxAddSubviewToRefreshableView(_ view: UIView) {
        uiTableView.addSubview(view)
        _uiTableViewAttendViews.append(view)
    }
    public func qxRefreshableViewFrame() -> CGRect {
        return uiTableView.frame
    }
    public func qxResetOffset() {
        uiTableView.contentOffset = CGPoint.zero
    }
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
    
    open var section: QXTableViewSection?
    open var model: Any?
    open var respondReloadData: (() -> Void)?
    
    public struct Context {
        public private(set) weak var tableView: QXTableView?
        public let indexPath: IndexPath
        public let givenWidth: CGFloat
        public let isFirstCellInSection: Bool
        public let isLastCellInSection: Bool
        public let isSortMode: Bool
    }
    public var context: Context!

    open class func height(_ model: Any?, _ context: Context) -> CGFloat? { return nil }
    
    open class func canMove(_ model: Any?, _ context: Context) -> Bool { return true }
    open class func editActions(_ model: Any?, _ context: Context) -> [UITableViewRowAction]? { return nil }
    
    open class func estimatedHeight(_ model: Any?, _ context: Context) -> CGFloat { QXTableViewAutoHeight }
    open func willDisplay() { }
    open func didEndDisplaying() { }
    open func didClickCell() { respondClickCell?() }
    
    open func contextDidSetup() { }
    
    fileprivate var respondClickCell: (() -> Void)?
    public final lazy var backButton: QXButton = {
        let e = QXButton()
        e.backView.backColorHighlighted = QXColor.dynamicHiglight
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
        if context?.isSortMode ?? false {
            contentView.frame = bounds
        }
        backButton.frame = contentView.bounds
    }
    open override var description: String {
        return "\(type(of: self))\(self.frame)"
    }
    
}

open class QXTableViewHeaderFooterView: UITableViewHeaderFooterView {
    
    open var section: QXTableViewSection?
    open var model: Any?
    open var respondReloadData: (() -> Void)?
    
    public struct Context {
        public private(set) weak var tableView: QXTableView?
        public let section: Int
        public let givenWidth: CGFloat
        public let isFirstSection: Bool
        public let isLastSection: Bool
    }
    public var context: Context!
            
    open class func height(_ model: Any?, _ context: Context) -> CGFloat? { return nil }
    open class func estimatedHeight(_ model: Any?, _ context: Context) -> CGFloat { QXTableViewAutoHeight }
    open func willDisplay() {}
    open func didEndDisplaying() {}
    open func didClickView() { respondClickView?() }

    open func contextDidSetup() { }
    
    fileprivate var respondClickView: (() -> Void)?
    public final lazy var backButton: QXButton = {
        let e = QXButton()
        e.backView.backColorHighlighted = QXColor.dynamicHiglight
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
        
    override open func contextDidSetup() {
        super.contextDidSetup()
        breakLine.isHidden = context.isLastCellInSection
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

open class QXTableViewDebugCell: QXTableViewBreakLineCell {
    
    override open func contextDidSetup() {
        super.contextDidSetup()
        label.fixWidth = context.givenWidth
    }
    
    override open var model: Any? {
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
    required public init(_ reuseId: String) {
        super.init(reuseId)
        contentView.addSubview(label)
        label.IN(contentView).LEFT.RIGHT.TOP.BOTTOM.MAKE()
        breakLine.padding = QXEdgeInsets(0, 15, 0, 15)
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
open class QXTableViewSpaceCell: QXTableViewCell {
    open override class func height(_ model: Any?, _ context: QXTableViewCell.Context) -> CGFloat? {
        if let e = model as? QXSpace {
            return e.h
        }
        return nil
    }
    required public init(_ reuseId: String) {
        super.init(reuseId)
        backButton.isDisplay = false
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

open class QXTableViewDebugHeaderFooterView: QXTableViewHeaderFooterView {
    override open func contextDidSetup() {
        super.contextDidSetup()
        label.fixWidth = context.givenWidth
    }
    override open var model: Any? {
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
    required public init(_ reuseId: String) {
        super.init(reuseId)
        contentView.addSubview(label)
        label.IN(contentView).LEFT.RIGHT.TOP.BOTTOM.MAKE()
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}




