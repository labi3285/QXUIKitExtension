//
//  QXCollectionView.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/7/27.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit
import MJRefresh
import JQCollectionViewAlignLayout

public let QXCollectionViewNoneHeight: CGFloat = 0.0001

public protocol QXCollectionViewDelegate: class {
    func collectionViewDidSetupCell(_ cell: QXCollectionViewCell, for model: Any, in section: QXCollectionViewSection)
    func collectionViewDidSelectCell(_ cell: QXCollectionViewCell, for model: Any, in section: QXCollectionViewSection)
    
    func collectionViewDidSetupHeaderView(_ headerView: QXCollectionViewHeaderFooterView, for model: Any, in section: QXCollectionViewSection)
    func collectionViewDidSelectHeaderView(_ headerView: QXCollectionViewHeaderFooterView, for model: Any, in section: QXCollectionViewSection)
    
    func collectionViewDidSetupFooterView(_ footerView: QXCollectionViewHeaderFooterView, for model: Any, in section: QXCollectionViewSection)
    func collectionViewDidSelectFooterView(_ footerView: QXCollectionViewHeaderFooterView, for model: Any, in section: QXCollectionViewSection)

    func collectionViewDidMove(from: IndexPath, to: IndexPath, in sections: [QXCollectionViewSection])
    
    func collectionViewNeedsReloadData()
}
extension QXCollectionViewDelegate {
    func collectionViewDidSetupCell(_ cell: QXCollectionViewCell, for model: Any, in section: QXCollectionViewSection) { }
    func collectionViewDidSelectCell(_ cell: QXCollectionViewCell, for model: Any, in section: QXCollectionViewSection) { }
    
    func collectionViewDidSetupHeaderView(_ headerView: QXCollectionViewHeaderFooterView, for model: Any, in section: QXCollectionViewSection) { }
    func collectionViewDidSelectHeaderView(_ headerView: QXCollectionViewHeaderFooterView, for model: Any, in section: QXCollectionViewSection) { }
    
    func collectionViewDidSetupFooterView(_ footerView: QXCollectionViewHeaderFooterView, for model: Any, in section: QXCollectionViewSection) { }
    func collectionViewDidSelectFooterView(_ footerView: QXCollectionViewHeaderFooterView, for model: Any, in section: QXCollectionViewSection) { }

    func collectionViewDidMove(from: IndexPath, to: IndexPath, in sections: [QXCollectionViewSection]) { }
    
    func collectionViewNeedsReloadData() { }
}

public class QXCollectionViewSection {

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

public func >> (lhs: Any.Type, rhs: QXCollectionViewCell.Type) -> (Any.Type, QXCollectionViewCell.Type) {
    return (lhs, rhs)
}
public func >> (lhs: Any.Type, rhs: QXCollectionViewHeaderFooterView.Type) -> (Any.Type, QXCollectionViewHeaderFooterView.Type) {
    return (lhs, rhs)
}

public struct QXCollectionViewAdapter {

    fileprivate let cellsInfoDic: [String: QXCollectionViewCell.Type]
    fileprivate let headerViewsInfoDic: [String: QXCollectionViewHeaderFooterView.Type]?
    fileprivate let footerViewsInfoDic: [String: QXCollectionViewHeaderFooterView.Type]?

    public init(_ cellsMappings: [(Any.Type, QXCollectionViewCell.Type)]) {
        self.init(cellsMappings, headerMappings: nil, footerMappings: nil)
    }
    public init(_ cellsMappings: [(Any.Type, QXCollectionViewCell.Type)],
                headerMappings: [(Any.Type, QXCollectionViewHeaderFooterView.Type)]?,
                footerMappings: [(Any.Type, QXCollectionViewHeaderFooterView.Type)]?) {
        do {
            var dic = [String: QXCollectionViewCell.Type]()
            for e in cellsMappings {
                dic["\(e.0)"] = e.1
            }
            self.cellsInfoDic = dic
        }
        if let ms = headerMappings {
            var dic = [String: QXCollectionViewHeaderFooterView.Type]()
            for e in ms {
                dic["\(e.0)"] = e.1
            }
            self.headerViewsInfoDic = dic
        } else {
            self.headerViewsInfoDic = nil
        }
        if let ms = footerMappings {
            var dic = [String: QXCollectionViewHeaderFooterView.Type]()
            for e in ms {
                dic["\(e.0)"] = e.1
            }
            self.footerViewsInfoDic = dic
        } else {
            self.footerViewsInfoDic = nil
        }
    }
    public func cellClass(_ model: Any?) -> QXCollectionViewCell.Type? {
        if let m = model {
            return cellsInfoDic["\(type(of: m))"]
        }
        return nil
    }
    public func headerViewClass(_ model: Any?) -> QXCollectionViewHeaderFooterView.Type? {
        if let m = model, let ms = headerViewsInfoDic {
            return ms["\(type(of: m))"]
        }
        return nil
    }
    public func footerViewClass(_ model: Any?) -> QXCollectionViewHeaderFooterView.Type? {
        if let m = model, let ms = footerViewsInfoDic {
            return ms["\(type(of: m))"]
        }
        return nil
    }
}

open class QXCollectionView: QXView {
    
    public weak var delegate: QXCollectionViewDelegate?

    public var adapter: QXCollectionViewAdapter?  {
        didSet {
            if let e = adapter {
                for (k, v) in e.cellsInfoDic {
                    uiCollectionView.register(v, forCellWithReuseIdentifier: k)
                }
                if let e = e.headerViewsInfoDic {
                    for (k, v) in e {
                        uiCollectionView.register(v, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: k)
                    }
               }
               if let e = e.footerViewsInfoDic {
                   for (k, v) in e {
                       uiCollectionView.register(v, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: k)
                   }
               }
           }
       }
   }

    public func reloadData() {
        uiCollectionView.reloadData()
    }

    open var sections: [QXCollectionViewSection] = [] {
        didSet {
            var ss: [QXCollectionViewSection] = []
            for s in sections {
                if s.isDisplay {
                    var header: Any?
                    if let e = s.header {
                        header = e
                    }
                    var ms: [Any] = []
                    for c in s.models {
                        ms.append(c)
                    }
                    var footer: Any?
                    if let e = s.footer {
                        footer = e
                    }
                    let s = QXCollectionViewSection(ms, header, footer)
                    ss.append(s)
                }
            }
            _cacheSections = ss
        }
    }
    fileprivate var _cacheSections: [QXCollectionViewSection] = []
    
    public var isVertical: Bool = true {
        didSet {
            if isVertical {
                flowLayout.scrollDirection = .vertical
            } else {
                flowLayout.scrollDirection = .horizontal
            }
        }
    }
    
    public var cellMinMargin: CGFloat {
        set {
            flowLayout.minimumInteritemSpacing = newValue
        }
        get {
            return flowLayout.minimumInteritemSpacing
        }
    }
    public var lineMargin: CGFloat {
        set {
            flowLayout.minimumLineSpacing = newValue
        }
        get {
            return flowLayout.minimumLineSpacing
        }
    }
    public var contentPadding: QXEdgeInsets {
        set {
            uiCollectionView.contentInset = newValue.uiEdgeInsets
        }
        get {
            return uiCollectionView.contentInset.qxEdgeInsets
        }
    }
    public var sectionPadding: QXEdgeInsets {
        set {
            flowLayout.sectionInset = newValue.uiEdgeInsets
        }
        get {
            return flowLayout.sectionInset.qxEdgeInsets
        }
    }
    
    public var isPlain: Bool = false {
        didSet {
            if #available(iOS 9.0, *) {
                flowLayout.sectionHeadersPinToVisibleBounds = isPlain
                flowLayout.sectionFootersPinToVisibleBounds = isPlain
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    public var isSortMode: Bool = false {
        didSet {
            if isSortMode {
                uiCollectionView.addGestureRecognizer(sortLongGestureRecognizer)
            } else {
                if let view = sortLongGestureRecognizer.view {
                    view.removeGestureRecognizer(sortLongGestureRecognizer)
                }
            }
        }
    }
    
    public var alignmentX: QXAlignmentX = .left {
        didSet {
            switch alignmentX {
            case .left:
                flowLayout.itemsHorizontalAlignment = .left
            case .center:
                flowLayout.itemsHorizontalAlignment = .center
            case .right:
                flowLayout.itemsHorizontalAlignment = .right
            }
        }
    }
    public var alignmentY: QXAlignmentY = .top {
        didSet {
            switch alignmentY {
            case .top:
                flowLayout.itemsVerticalAlignment = .top
            case .center:
                flowLayout.itemsVerticalAlignment = .center
            case .bottom:
                flowLayout.itemsVerticalAlignment = .bottom
            }
        }
    }
    
    final private lazy var flowLayout: JQCollectionViewAlignLayout = {
        let e = JQCollectionViewAlignLayout()
        e.minimumLineSpacing = 0
        e.minimumInteritemSpacing = 0
        e.sectionInset = UIEdgeInsets.zero
        e.itemsDirection = .LTR
        e.itemsHorizontalAlignment = .left
        e.itemsVerticalAlignment = .top
        return e
    }()
    final public lazy var uiCollectionView: UICollectionView = {
        let e = UICollectionView(frame: CGRect.zero, collectionViewLayout: self.flowLayout)
        e.backgroundColor = UIColor.clear
        e.register(QXCollectionViewCell.self, forCellWithReuseIdentifier: "NULL")
        e.register(QXCollectionViewHeaderFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "NULL")
        e.register(QXCollectionViewHeaderFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "NULL")
        e.register(QXCollectionViewSpaceCell.self, forCellWithReuseIdentifier: "\(type(of: QXSpace(1)))")
        e.register(QXCollectionViewSpaceHeadFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "\(type(of: QXSpace(1)))")
        e.register(QXCollectionViewSpaceHeadFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "\(type(of: QXSpace(1)))")
        e.bounces = true
        e.alwaysBounceVertical = true
        e.delegate = self
        e.dataSource = self
        return e
    }()
    
    public final lazy var sortLongGestureRecognizer: UILongPressGestureRecognizer = {
        let e = UILongPressGestureRecognizer(target: self, action: #selector(sortLongGesture(_:)))
        e.minimumPressDuration = 0.1
        return e
    }()
    // 拖动手势，需要9.0支持
    @objc func sortLongGesture(_ recognizer: UILongPressGestureRecognizer) {
        let point = recognizer.location(in: recognizer.view!)
        switch recognizer.state {
        case .began:
            if let indexPath = uiCollectionView.indexPathForItem(at: point) {
                if #available(iOS 9.0, *) {
                    uiCollectionView.beginInteractiveMovementForItem(at: indexPath)
                } else {
                    // Fallback on earlier versions
                }
            }
        case .changed:
            if #available(iOS 9.0, *) {
                uiCollectionView.updateInteractiveMovementTargetPosition(point)
            } else {
                // Fallback on earlier versions
            }
        case .ended:
            if #available(iOS 9.0, *) {
                uiCollectionView.endInteractiveMovement()
            } else {
                // Fallback on earlier versions
            }
        default:
            if #available(iOS 9.0, *) {
                uiCollectionView.cancelInteractiveMovement()
            } else {
                // Fallback on earlier versions
            }
        }
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        uiCollectionView.qxRect = qxBounds.rectByReduce(padding)
    }

    required public override init() {
        super.init()
        addSubview(uiCollectionView)
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open func cell(for indexPath: IndexPath) -> QXCollectionViewCell {
        let s = _cacheSections[indexPath.section]
        let ms = s.models
        let m = ms[indexPath.item]
        let cell: QXCollectionViewCell
        let id = "\(type(of: m))"
        if let e = uiCollectionView.dequeueReusableCell(withReuseIdentifier: id, for: indexPath) as? QXCollectionViewCell {
            cell = e
        } else {
            let cls: QXCollectionViewCell.Type
            if let e = adapter?.cellClass(m) {
                cls = e
            } else {
                if m is QXSpace {
                    cls = QXCollectionViewSpaceCell.self
                } else {
                    cls = QXCollectionViewDebugCell.self
                }
            }
            cell = cls.init()
        }
        cell.respondReloadData = { [weak self] in
            self?.delegate?.collectionViewNeedsReloadData()
        }
        delegate?.collectionViewDidSetupCell(cell, for: m, in: s)
        cell.context = QXCollectionViewCell.Context(collectionView: self,
                                                    indexPath: indexPath,
                                                    givenWidth: uiCollectionView.bounds.width - flowLayout.sectionInset.left - flowLayout.sectionInset.right - uiCollectionView.contentInset.left - uiCollectionView.contentInset.right,
                                                    cellMinMargin: flowLayout.minimumInteritemSpacing,
                                                    isFirstCellInSection: indexPath.item == 0,
                                                    isLastCellInSection: indexPath.item == ms.count - 1)
        cell.section = s
        cell.contextDidSetup()
        cell.model = m
        cell.respondClickCell = { [weak self, weak cell] in
            if let ws = self, let c = cell {
                ws.delegate?.collectionViewDidSelectCell(c, for: m, in: s)
            }
        }
        return cell
    }
    open func cellSize(for indexPath: IndexPath) -> QXSize {
        let ms = _cacheSections[indexPath.section].models
        let m = ms[indexPath.item]
        if let e = adapter?.cellClass(m) {
            let context = QXCollectionViewCell.Context(collectionView: self,
                                                       indexPath: indexPath,
                                                       givenWidth: uiCollectionView.bounds.width - flowLayout.sectionInset.left - flowLayout.sectionInset.right - uiCollectionView.contentInset.left - uiCollectionView.contentInset.right,
                                                       cellMinMargin: flowLayout.minimumInteritemSpacing,
                                                       isFirstCellInSection: indexPath.item == 0,
                                                       isLastCellInSection: indexPath.item == ms.count - 1)
            return e.size(m, context)
        } else if let e = m as? QXSpace {
            return QXSize(e.w, e.h)
        }
        return QXSize(QXCollectionViewNoneHeight, QXCollectionViewNoneHeight)
    }
    open func headerView(for indexPath: IndexPath) -> QXCollectionViewHeaderFooterView {
        let s = _cacheSections[indexPath.section]
        if let m = s.header {
            let view: QXCollectionViewHeaderFooterView
            let id = "\(type(of: m))"
            if let e = uiCollectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: id, for: indexPath) as? QXCollectionViewHeaderFooterView {
                view = e
            } else {
                if let cls = adapter?.headerViewClass(m) {
                    if let e = uiCollectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: id, for: indexPath) as? QXCollectionViewHeaderFooterView {
                        view = e
                    } else {
                        view = cls.init()
                    }
                } else {
                    view = QXCollectionViewHeaderFooterView()
                }
            }
            view.respondReloadData = { [weak self] in
                self?.delegate?.collectionViewNeedsReloadData()
            }
            delegate?.collectionViewDidSetupHeaderView(view, for: m, in: s)
            view.context = QXCollectionViewHeaderFooterView.Context(collectionView: self,
                                                                    section: indexPath.section,
                                                                    givenWidth: uiCollectionView.bounds.width - flowLayout.sectionInset.left - flowLayout.sectionInset.right - uiCollectionView.contentInset.left - uiCollectionView.contentInset.right,
                                                                    isFirstSection: indexPath.section == 0,
                                                                    isLastSection: indexPath.section == _cacheSections.count - 1)
            view.section = s
            view.contextDidSetup()
            view.model = m
            view.respondClickView = { [weak self, weak view] in
                if let ws = self, let view = view {
                    ws.delegate?.collectionViewDidSelectHeaderView(view, for: m, in: s)
                }
            }
            return view
        }
        return QXCollectionViewHeaderFooterView()
    }
    open func footerView(for indexPath: IndexPath) -> QXCollectionViewHeaderFooterView {
        let s = _cacheSections[indexPath.section]
        if let m = s.footer {
            let view: QXCollectionViewHeaderFooterView
            let id = "\(type(of: m))"
            if let e = uiCollectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: id, for: indexPath) as? QXCollectionViewHeaderFooterView {
                view = e
            } else {
                if let cls = adapter?.footerViewClass(m) {
                    if let e = uiCollectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: id, for: indexPath) as? QXCollectionViewHeaderFooterView {
                        view = e
                    } else {
                        view = cls.init()
                    }
                } else {
                    view = QXCollectionViewHeaderFooterView()
                }
            }
            view.respondReloadData = { [weak self] in
                self?.delegate?.collectionViewNeedsReloadData()
            }
            delegate?.collectionViewDidSetupFooterView(view, for: m, in: s)
            view.context = QXCollectionViewHeaderFooterView.Context(collectionView: self,
                                                                    section: indexPath.section,
                                                                    givenWidth: uiCollectionView.bounds.width - flowLayout.sectionInset.left - flowLayout.sectionInset.right - uiCollectionView.contentInset.left - uiCollectionView.contentInset.right,
                                                                    isFirstSection: indexPath.section == 0,
                                                                    isLastSection: indexPath.section == _cacheSections.count - 1)
            view.section = s
            view.contextDidSetup()
            view.model = m
            view.respondClickView = { [weak self, weak view] in
                if let ws = self, let view = view {
                    ws.delegate?.collectionViewDidSelectFooterView(view, for: m, in: s)
                }
            }
            return view
        }
        return QXCollectionViewHeaderFooterView()
    }

    open func headerViewHeight(for indexPath: IndexPath) -> CGFloat {
        let m = _cacheSections[indexPath.section].header
        if let e = adapter?.headerViewClass(m) {
            let context = QXCollectionViewHeaderFooterView.Context(collectionView: self,
                                                                   section: indexPath.section,
                                                                   givenWidth: uiCollectionView.bounds.width - flowLayout.sectionInset.left - flowLayout.sectionInset.right - uiCollectionView.contentInset.left - uiCollectionView.contentInset.right,
                                                                   isFirstSection: indexPath.section == 0,
                                                                   isLastSection: indexPath.section == _cacheSections.count - 1)
            return e.height(m, context)
        } else if let e = m as? QXSpace {
            return e.h
        }
        return QXCollectionViewNoneHeight
    }
    open func footerViewHeight(for indexPath: IndexPath) -> CGFloat {
        let m = _cacheSections[indexPath.section].footer
        if let e = adapter?.footerViewClass(m)  {
            let context = QXCollectionViewHeaderFooterView.Context(collectionView: self,
                                                                   section: indexPath.section,
                                                                   givenWidth: uiCollectionView.bounds.width - flowLayout.sectionInset.left - flowLayout.sectionInset.right - uiCollectionView.contentInset.left - uiCollectionView.contentInset.right,
                                                                   isFirstSection: indexPath.section == 0,
                                                                   isLastSection: indexPath.section == _cacheSections.count - 1)
            return e.height(m, context)
        } else if let e = m as? QXSpace {
            return e.h
        }
        return QXCollectionViewNoneHeight
    }

    fileprivate var _uiCollectionViewAttendViews: [UIView] = []

}

extension QXCollectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return _cacheSections.count
    }
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _cacheSections[section].models.count
    }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return cell(for: indexPath)
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize(for: indexPath).cgSize
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            return headerView(for: indexPath)
        case UICollectionView.elementKindSectionFooter:
            return footerView(for: indexPath)
        default:
            return QXDebugFatalError("not support yet", UICollectionReusableView())
        }
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 1, height: headerViewHeight(for: IndexPath(item: 0, section: section)))
    }


    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: 1, height: footerViewHeight(for: IndexPath(item: 0, section: section)))
    }
    
    public func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        let s = _cacheSections[indexPath.section]
        let ms = s.models
        let m = ms[indexPath.item]
        if let e = adapter?.cellClass(m) {
            return e.canMove(m)
        }
        return false
    }

    public func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let e = _cacheSections[sourceIndexPath.section].models[sourceIndexPath.row]
        _cacheSections[sourceIndexPath.section].models.remove(at: sourceIndexPath.row)
        _cacheSections[destinationIndexPath.section].models.insert(e, at: destinationIndexPath.row)
        delegate?.collectionViewDidMove(from: sourceIndexPath, to: destinationIndexPath, in: _cacheSections)
        collectionView.reloadData()
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        (cell as? QXCollectionViewCell)?.willDisplay()
    }
    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        (cell as? QXCollectionViewCell)?.didEndDisplaying()
    }

    public func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        (view as? QXCollectionViewHeaderFooterView)?.willDisplay()
    }
    
    public func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        (view as? QXCollectionViewHeaderFooterView)?.didEndDisplaying()
    }
    public func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        return false
    }
}

extension QXCollectionView: QXRefreshableViewProtocol {
    public func qxAddSubviewToRefreshableView(_ view: UIView) {
        uiCollectionView.addSubview(view)
        _uiCollectionViewAttendViews.append(view)
    }
    public func qxRefreshableViewFrame() -> CGRect {
        return uiCollectionView.frame
    }
    public func qxResetOffset() {
        uiCollectionView.contentOffset = CGPoint.zero
    }
    public func qxDisableAutoInserts() {
        uiCollectionView.qxDisableAutoInserts()
    }
    public func qxSetRefreshHeader(_ header: QXRefreshHeader?) {
        uiCollectionView.mj_header = header
    }
    public func qxSetRefreshFooter(_ footer: QXRefreshFooter?) {
        uiCollectionView.mj_footer = footer
    }
    public func qxReloadData() {
        reloadData()
    }
    public func qxUpdateModels(_ models: [Any]) {
        if let e = models as? [QXCollectionViewSection] {
            self.sections = e
        } else {
            let section = QXCollectionViewSection(models, nil, nil)
            self.sections = [section]
        }
        reloadData()
    }
}



open class QXCollectionViewCell: UICollectionViewCell {

    open var section: QXCollectionViewSection?
    open var model: Any?
    open var respondReloadData: (() -> Void)?
    
    public struct Context {
        public private(set) weak var collectionView: QXCollectionView?
        public let indexPath: IndexPath
        public let givenWidth: CGFloat
        public let cellMinMargin: CGFloat
        public let isFirstCellInSection: Bool
        public let isLastCellInSection: Bool
    }
    public var context: Context!

    open class func size(_ model: Any?, _ context: Context) -> QXSize { return QXSize(100, 100) }

    open class func canMove(_ model: Any?) -> Bool { return true }
    
    open func willDisplay() { }
    open func didEndDisplaying() { }
    open func didClickCell() { respondClickCell?() }

    open func contextDidSetup() { }

    fileprivate var respondClickCell: (() -> Void)?
    public final lazy var backButton: QXButton = {
        let e = QXButton()
        e.backView.backgroundColorHighlighted = QXColor.dynamicHiglight
        e.respondClick = { [weak self] in
            self?.didClickCell()
        }
        return e
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
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

open class QXCollectionViewHeaderFooterView: UICollectionReusableView {

    open var section: QXCollectionViewSection?
    open var model: Any?
    open var respondReloadData: (() -> Void)?
    
    public struct Context {
        public private(set) weak var collectionView: QXCollectionView?
        public let section: Int
        public let givenWidth: CGFloat
        public let isFirstSection: Bool
        public let isLastSection: Bool
    }
    public var context: Context!

    open class func height(_ model: Any?, _ context: Context) -> CGFloat { return QXCollectionViewNoneHeight }
    open func willDisplay() {}
    open func didEndDisplaying() {}
    open func didClickView() { respondClickView?() }

    open func contextDidSetup() { }

    fileprivate var respondClickView: (() -> Void)?
    public final lazy var backButton: QXButton = {
        let e = QXButton()
        e.backView.backgroundColorHighlighted = QXColor.dynamicHiglight
        e.respondClick = { [weak self] in
            self?.didClickView()
        }
        return e
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(backButton)
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override open func layoutSubviews() {
        super.layoutSubviews()
        backButton.frame = bounds
    }
    open override var description: String {
        return "\(type(of: self))\(self.frame)"
    }

}

open class QXCollectionViewDebugCell: QXCollectionViewCell {
    
    open override class func size(_ model: Any?, _ context: QXCollectionViewCell.Context) -> QXSize {
        Label.text = "\(model ?? "nil")"
        Label.maxWidth = context.givenWidth / 2
        return Label.natureSize
    }
    override open func contextDidSetup() {
        super.contextDidSetup()
        label.maxWidth = context.givenWidth
    }

    override open var model: Any? {
        didSet {
            super.model = model
            label.text = "\(model ?? "nil")"
        }
    }

    static let Label: QXLabel = {
        let e = QXLabel()
        e.padding = QXEdgeInsets(10, 15, 10, 15)
        e.font = QXFont(14, QXColor.dynamicText)
        e.numberOfLines = 0
        return e
    }()
    public final lazy var label: QXLabel = {
        let e = QXLabel()
        e.padding = QXEdgeInsets(10, 15, 10, 15)
        e.font = QXFont(14, QXColor.dynamicText)
        e.numberOfLines = 0
        return e
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(label)
        label.IN(contentView).LEFT.RIGHT.TOP.BOTTOM.MAKE()
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
open class QXCollectionViewSpaceCell: QXCollectionViewCell {
    open override class func size(_ model: Any?, _ context: QXCollectionViewCell.Context) -> QXSize {
        if let e = model as? QXSpace {
            return QXSize(e.w, e.h)
        }
        return QXSize.zero
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        backButton.isDisplay = false
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
open class QXCollectionViewSpaceHeadFooterView: QXCollectionViewHeaderFooterView {
    open override class func height(_ model: Any?, _ context: QXCollectionViewHeaderFooterView.Context) -> CGFloat {
        if let e = model as? QXSpace {
            return e.h
        }
        return QXCollectionViewNoneHeight
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        backButton.isDisplay = false
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

open class QXCollectionViewDebugHeaderFooterView: QXCollectionViewHeaderFooterView {

    override open func contextDidSetup() {
        super.contextDidSetup()
        label.fixWidth = context.givenWidth
    }
    
    open override class func height(_ model: Any?, _ context: QXCollectionViewHeaderFooterView.Context) -> CGFloat {
        Label.text = "\(model ?? "nil")"
        Label.fixWidth = context.givenWidth
        return Label.natureSize.h
    }
    
    override open var model: Any? {
        didSet {
            super.model = model
            label.text = "\(model ?? "nil")"
        }
    }
    
    static let Label: QXLabel = {
        let e = QXLabel()
        e.padding = QXEdgeInsets(10, 15, 10, 15)
        e.font = QXFont(14, QXColor.dynamicText)
        e.numberOfLines = 0
        return e
    }()
    public final lazy var label: QXLabel = {
        let e = QXLabel()
        e.padding = QXEdgeInsets(10, 15, 10, 15)
        e.font = QXFont(14, QXColor.dynamicText)
        e.numberOfLines = 0
        return e
    }()
    public override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        label.IN(self).LEFT.RIGHT.TOP.BOTTOM.MAKE()
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
