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

public class QXCollectionViewSection {

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
    
    public var respondSelectCell: ((_ model: Any?) -> Void)?
    public var respondSelectHeaderView: ((_ model: Any?) -> Void)?
    public var respondSelectFooterView: ((_ model: Any?) -> Void)?
    public var respondMove: ((_ from: IndexPath, _ to: IndexPath) -> Void)?

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
                    var ms: [Any?] = []
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

    open func cell(for model: Any?, givenWidth: CGFloat, cellMinMargin: CGFloat, indexPath: IndexPath) -> QXCollectionViewCell {
        let cell: QXCollectionViewCell
        let id: String
        if let e = model {
            id = "\(type(of: e))"
        } else {
            id = "NULL"
        }
        if let e = uiCollectionView.dequeueReusableCell(withReuseIdentifier: id, for: indexPath) as? QXCollectionViewCell {
            cell = e
        } else {
            let cls: QXCollectionViewCell.Type
            if let e = adapter?.cellClass(model) {
                cls = e
            } else {
                if model is QXSpace {
                    cls = QXCollectionViewSpaceCell.self
                } else {
                    cls = QXCollectionViewDebugCell.self
                }
            }
            cell = cls.init()
        }
        cell.collectionView = self
        cell.givenWidth = givenWidth
        cell.cellMinMargin = cellMinMargin
        cell.indexPath = indexPath
        cell.initializedWithCollectionView()
        cell.model = model
        cell.respondClickCell = { [weak self] in
            self?.respondSelectCell?(model)
        }
        return cell
    }
    open func cellSize(for model: Any?, givenWidth: CGFloat, cellMinMargin: CGFloat) -> QXSize {
        if let e = adapter?.cellClass(model) {
            return e.size(model, givenWidth, cellMinMargin)
        } else if let e = model as? QXSpace {
            return QXSize(e.w, e.h)
        }
        return QXSize(QXCollectionViewNoneHeight, QXCollectionViewNoneHeight)
    }
    open func headerView(for model: Any?, givenWidth: CGFloat, indexPath: IndexPath) -> QXCollectionViewHeaderFooterView {
        let view: QXCollectionViewHeaderFooterView
        let id: String
        if let e = model {
            id = "\(type(of: e))"
        } else {
            id = "NULL"
        }
        if let e = uiCollectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: id, for: indexPath) as? QXCollectionViewHeaderFooterView {
            view = e
        } else {
            if let cls = adapter?.headerViewClass(model) {
                if let e = uiCollectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: id, for: indexPath) as? QXCollectionViewHeaderFooterView {
                    view = e
                } else {
                    view = cls.init()
                }
            } else {
                view = QXCollectionViewHeaderFooterView()
            }
        }
        view.collectionView = self
        view.givenWith = givenWidth
        view.initializedWithCollectionView()
        view.model = model
        view.respondClickView = { [weak self] in
            self?.respondSelectHeaderView?(model)
        }
        return view
    }
    open func footerView(for model: Any?, givenWidth: CGFloat, indexPath: IndexPath) -> QXCollectionViewHeaderFooterView {
        let view: QXCollectionViewHeaderFooterView
        let id: String
        if let e = model {
            id = "\(type(of: e))"
        } else {
            id = "NULL"
        }
        if let e = uiCollectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: id, for: indexPath) as? QXCollectionViewHeaderFooterView {
            view = e
        } else {
            if let cls = adapter?.footerViewClass(model) {
                view = cls.init()
            } else {
                view = QXCollectionViewHeaderFooterView()
            }
        }
        view.collectionView = self
        view.givenWith = givenWidth
        view.initializedWithCollectionView()
        view.model = model
        view.respondClickView = { [weak self] in
            self?.respondSelectFooterView?(model)
        }
        return view
    }

    open func headerViewHeight(for model: Any?, givenWidth: CGFloat) -> CGFloat {
        if let e = adapter?.headerViewClass(model) {
            return e.height(model, givenWidth)
        } else if let e = model as? QXSpace {
            return e.h
        }
        return QXCollectionViewNoneHeight
    }
    open func footerViewHeight(for model: Any?, givenWidth: CGFloat) -> CGFloat {
        if let e = adapter?.footerViewClass(model)  {
            return e.height(model, givenWidth)
        } else if let e = model as? QXSpace {
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
        let section = _cacheSections[indexPath.section]
        let model = section.models[indexPath.row]
        let givenW = collectionView.bounds.width - flowLayout.sectionInset.left - flowLayout.sectionInset.right
        let e = cell(for: model, givenWidth: givenW, cellMinMargin: flowLayout.minimumInteritemSpacing, indexPath: indexPath)
        e.indexPath = indexPath
        return e
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let section = _cacheSections[indexPath.section]
        let model = section.models[indexPath.row]
        let givenW = collectionView.bounds.width - flowLayout.sectionInset.left - flowLayout.sectionInset.right
        return cellSize(for: model, givenWidth: givenW, cellMinMargin: flowLayout.minimumInteritemSpacing).cgSize
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let givenW = collectionView.bounds.width - flowLayout.sectionInset.left - flowLayout.sectionInset.right
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let _section = _cacheSections[indexPath.section]
            let model = _section.header
            let e = headerView(for: model, givenWidth: givenW, indexPath: indexPath)
            e.section = indexPath.section
            return e
        case UICollectionView.elementKindSectionFooter:
            let _section = _cacheSections[indexPath.section]
            let model = _section.footer
            let e = footerView(for: model, givenWidth: givenW, indexPath: indexPath)
            e.section = indexPath.section
            return e
        default:
            return QXDebugFatalError("not support yet", UICollectionReusableView())
        }
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let section = _cacheSections[section]
        let model = section.header
        let givenW = collectionView.bounds.width - flowLayout.sectionInset.left - flowLayout.sectionInset.right
        let h = headerViewHeight(for: model, givenWidth: givenW)
        return CGSize(width: givenW, height: h)
    }


    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let section = _cacheSections[section]
        let model = section.footer
        let givenW = collectionView.bounds.width - flowLayout.sectionInset.left - flowLayout.sectionInset.right
        let h = footerViewHeight(for: model, givenWidth: givenW)
        return CGSize(width: givenW, height: h)
    }

//    open func tableView(_ tableView: UICollectionView, canMoveRowAt indexPath: IndexPath) -> Bool {
////        let section = _cacheSections[indexPath.section]
////        let model = section.models[indexPath.row]
////        if let e = adapter?.cellClass(model) ?? delegate?.qxCollectionViewCellClass(model) {
////            return e.canMove(model)
////        }
//        return false
//    }
//
//    open func tableView(_ tableView: UICollectionView, commit editingStyle: UICollectionViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
////        let section = _cacheSections[indexPath.section]
////        let model = section.models[indexPath.row]
////        (adapter?.cellClass(model) ?? delegate?.qxCollectionViewCellClass(model))?.editCommit(model, editingStyle)
//    }
//
//    open func tableView(_ tableView: UICollectionView, editActionsForRowAt indexPath: IndexPath) -> [UICollectionViewRowAction]? {
//        let section = _cacheSections[indexPath.section]
//        let model = section.models[indexPath.row]
//        return (adapter?.cellClass(model) ?? delegate?.qxCollectionViewCellClass(model))?.editActions(model)
//    }
//
//    open func tableView(_ tableView: UICollectionView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//        delegate?.qxCollectionViewMoveCell(sourceIndexPath, destinationIndexPath)
//    }
    
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

    open var model: Any?

    public weak fileprivate(set) var collectionView: QXCollectionView?
    public fileprivate(set) var indexPath: IndexPath?
    public fileprivate(set) var givenWidth: CGFloat = 0
    public fileprivate(set) var cellMinMargin: CGFloat = 0

    open class func size(_ model: Any?, _ givenWidth: CGFloat, _ cellMinMargin: CGFloat) -> QXSize { return QXSize(100, 100) }

//    open class func canMove(_ model: Any?) -> Bool { return true }
    open func willDisplay() { }
    open func didEndDisplaying() { }
    open func didClickCell() { respondClickCell?() }

    open func initializedWithCollectionView() { }

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

    open var model: Any?

    public weak fileprivate(set) var collectionView: QXCollectionView?
    public fileprivate(set) var section: Int?
    public fileprivate(set) var givenWith: CGFloat = 0

    open class func height(_ model: Any?, _ givenWidth: CGFloat) -> CGFloat { return QXCollectionViewNoneHeight }
    open func willDisplay() {}
    open func didEndDisplaying() {}
    open func didClickView() { respondClickView?() }

    open func initializedWithCollectionView() { }

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

    open override class func size(_ model: Any?, _ givenWidth: CGFloat, _ cellMinMargin: CGFloat) -> QXSize {
        Label.text = "\(model ?? "nil")"
        Label.maxWidth = givenWidth / 2
        return Label.natureSize
    }
    override open func initializedWithCollectionView() {
        super.initializedWithCollectionView()
        label.maxWidth = givenWidth
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
    open override class func size(_ model: Any?, _ givenWidth: CGFloat, _ cellMinMargin: CGFloat) -> QXSize {
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
    open override class func height(_ model: Any?, _ givenWidth: CGFloat) -> CGFloat {
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

    override open func initializedWithCollectionView() {
        super.initializedWithCollectionView()
        label.fixWidth = givenWith
    }

    open override class func height(_ model: Any?, _ givenWidth: CGFloat) -> CGFloat {
        Label.text = "\(model ?? "nil")"
        Label.fixWidth = givenWidth
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
