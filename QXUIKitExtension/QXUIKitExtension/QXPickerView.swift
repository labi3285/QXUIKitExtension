//
//  QXPickerView.swift
//  QXPickerView
//
//  Created by labi3285 on 2017/11/1.
//  Copyright © 2017年 shanlin. All rights reserved.
//

import UIKit

open class QXPickersView: QXStackView {
    
    public var respondItem: ((_ item: QXPickerView.Item?) -> Void)?

    open var items: [QXPickerView.Item] = [] {
        didSet {
            if pickerViews.count == 1 {
                var arr = items
                if let f = items.first, let s = nonePlaceHolder {
                    let e = QXPickerView.Item.placeHolder(s, f.font)
                    arr.insert(e, at: 0)
                }
                pickerViews[0].items = arr
            } else {
                func scanParent(item: QXPickerView.Item) {
                    for e in item.children {
                        e.parent = item
                        scanParent(item: e)
                    }
                }
                for e in items {
                    scanParent(item: e)
                }
                if let e = pickerViews.first, let i = items.first {
                    e.items = items
                    e.reloadData()
                    
                    if isLazyMode {
                        e.respondPick?(i)
                    } else {
                        e.respondAutoPick?(i)
                    }
                }
                pickerViews.first?.reloadData()
            }
        }
    }
    
    public var bringInPickedItems: [QXPickerView.Item]? {
        didSet {
            if let arr = bringInPickedItems {
                QXDebugAssert(arr.count == pickerViews.count)
                for (i, e) in arr.enumerated() {
                    DispatchQueue.main.qxAsyncWait(TimeInterval(i) / 5) {
                        let picker = self.pickerViews[i]
                        picker.selectItem = e
                        if let e = picker.selectItem {
                            if self.isLazyMode {
                                self.pickerViews[i].respondPick?(e)
                            } else {
                                self.pickerViews[i].respondAutoPick?(e)
                            }
                        }
                    }
                }
            }
        }
    }
        
    public let pickerViews: [QXPickerView]

    public var nonePlaceHolder: String? = "-"
    public let isLazyMode: Bool
    public let isCleanShow: Bool
    
    public func checkOrPerformSelectAtInit() {
        if !isCleanShow {
            if let picker = pickerViews.first, let item = picker.selectItem {
                picker.respondPick?(item)
            }
        }
    }
    
    /**
     * isLazyMode: 在正常情况下多级picker选中上级下一级清0，lazyMode会尝试保留子级的索引，多用于日期等选择
     */
    public required init(_ pickerViews: [QXPickerView]) {
        self.pickerViews = pickerViews
        self.isLazyMode = false
        self.isCleanShow = true
        super.init()
        qxBackgroundColor = QXColor.clear
        viewMargin = 0
        alignmentX = .center
        alignmentY = .center
        var views: [QXViewProtocol] = []
        for (i, e) in pickerViews.enumerated() {
            if e.fixHeight == nil {
                e.extendHeight = true
            }
            if e.divideRatioX == nil && e.fixWidth == nil {
                e.divideRatioX = 1
            }
            if let e = e.prefixView {
                views.append(e)
            }
            views.append(e)
            if let e = e.suffixView {
                views.append(e)
            }
            if i < pickerViews.count - 1 {
                views.append(QXSpace(10))
            }
        }
        for (i, e) in pickerViews.enumerated() {
            if i + 1 <= pickerViews.count - 1 {
                e.nextPickerView = pickerViews[i + 1]
            }
        }
        self.views = views

        for e in pickerViews {
            if let n = e.nextPickerView {
                e.respondAutoPick = { [weak self, weak n] item in
                    guard let n = n else { return }
                    var children = item.children
                    if children.count == 0 {
                        let e = QXPickerView.Item(item.id, item.text, item.data)
                        e.parent = item.parent
                        children.append(e)
                    }
                    if n.nextPickerView == nil, let s = self?.nonePlaceHolder {
                        let e = QXPickerView.Item.placeHolder(s, children.first!.font)
                        children.insert(e, at: 0)
                    }
                    let first = children[0]
                    n.items = children
                    n.selectItem = first
                    n.respondAutoPick?(first)
                }
            } else {
                e.respondPick = { [weak self] item in
                    if item.isPlaceHolder {
                        self?.respondItem?(nil)
                    } else {
                        self?.respondItem?(item)
                    }
                }
            }
        }

    }
    public required init(_ lazyPickerViews: [QXPickerView], isCleanShow: Bool) {
        self.pickerViews = lazyPickerViews
        self.isLazyMode = true
        self.isCleanShow = isCleanShow
        super.init()
        qxBackgroundColor = QXColor.dynamicBackgroundKeyboard
        viewMargin = 0
        alignmentX = .center
        alignmentY = .center
        var views: [QXViewProtocol] = []
        for (i, e) in pickerViews.enumerated() {
            if e.fixHeight == nil {
                e.extendHeight = true
            }
            if e.divideRatioX == nil && e.fixWidth == nil {
                e.divideRatioX = 1
            }
            if let e = e.prefixView {
                views.append(e)
            }
            views.append(e)
            if let e = e.suffixView {
                views.append(e)
            }
            if i < pickerViews.count - 1 {
                views.append(QXSpace(10))
            }
        }
        for (i, e) in pickerViews.enumerated() {
            if i + 1 <= pickerViews.count - 1 {
                e.nextPickerView = pickerViews[i + 1]
            }
        }
        self.views = views
        
        for e in pickerViews {
            if let n = e.nextPickerView {
                e.respondPick = { [weak self, weak n] item in
                    guard let n = n else { return }
                    var children = item.children
                    if children.count == 0 {
                        let e = QXPickerView.Item(item.id, item.text, item.font, item.data)
                        e.parent = item.parent
                        children.append(e)
                    }
                    if isCleanShow, n.nextPickerView == nil, let s = self?.nonePlaceHolder {
                        let e = QXPickerView.Item.placeHolder(s, children.first!.font)
                        children.insert(e, at: 0)
                    }
                    n.items = children
                    if let i = n._selectIndex {
                        var e = children.first!
                        var d = abs(i - 0)
                        for (_i, _e) in children.enumerated() {
                            if abs(i - _i) < d {
                                d = abs(i - _i)
                                e = _e
                            }
                        }
                        n.selectItem = e
                        n.respondPick?(e)
                    } else {
                        if let e = children.first {
                            n.selectItem = e
                            n.respondPick?(children.first!)
                        }
                    }
                }
            } else {
                e.respondPick = { [weak self] item in
                    if item.isPlaceHolder {
                        self?.respondItem?(nil)
                    } else {
                        self?.respondItem?(item)
                    }
                }
            }
        }
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

open class QXPickerView: QXView, UIPickerViewDataSource, UIPickerViewDelegate {
    
    open class Item: CustomStringConvertible {

        public let id: AnyHashable
        public let data: Any?
        public let text: String
        public let font: QXFont
        public private(set) var isPlaceHolder: Bool = false
        
        public var children: [Item] = []
        weak var parent: Item?
                
        public init(_ id: AnyHashable, _ text: String, _ font: QXFont, _ data: Any?) {
            self.id = id
            self.data = data
            self.font = font
            self.text = text
        }
        public convenience init(_ id: AnyHashable, _ text: String, _ data: Any?) {
            let font = QXFont(14, QXColor.dynamicTitle)
             self.init(id, text, font, data)
        }
        public convenience init(_ id: AnyHashable, _ text: String) {
            let font = QXFont(14, QXColor.dynamicTitle)
            self.init(id, text, font, nil)
        }
        public static func placeHolder(_ text: String, _ font: QXFont) -> Item {
            let e = Item.init(0, text, font, nil)
            e.isPlaceHolder = true
            return e
        }
                
        public var description: String {
            return self.items().map({ $0.text + "(\($0.id))" }).joined(separator: "->")
        }
        public func items() -> [Item] {
            var next: QXPickerView.Item? = self
            var arr: [QXPickerView.Item] = []
            while next != nil {
                arr.append(next!)
                next = next!.parent
            }
            return arr.reversed()
        }
                
    }
    
    open var respondPick: ((_ item: Item) -> Void)?
    open var items: [Item] = [] {
        didSet {
            _selectItem = items.first
            uiPickerView.reloadAllComponents()
        }
    }
    open var selectItem: Item? {
        set {
            if let e = newValue {
                if let i = items.firstIndex(where: { $0.id == e.id }) {
                    uiPickerView.selectRow(i, inComponent: 0, animated: true)
                    _selectItem = items[i]
                    _selectIndex = i
                } else {
                    _selectItem = nil
                    _selectIndex = nil
                }
            } else {
                _selectItem = nil
                _selectIndex = nil
            }
        }
        get {
            return _selectItem
        }
    }
    
    open var rowHeight: CGFloat = 40
    open var alignmentX: QXAlignmentX = .center
    
    public var prefixView: QXView?
    public var suffixView: QXView?
    
    fileprivate weak var nextPickerView: QXPickerView?
    fileprivate var respondAutoPick: ((_ item: Item) -> Void)?
    fileprivate var _selectItem: Item?
    fileprivate var _selectIndex: Int?

    open func reloadData() {
        uiPickerView.reloadAllComponents()
    }

    public final lazy var uiPickerView: UIPickerView = {
        let e = UIPickerView()
        e.delegate = self
        e.dataSource = self
        return e
    }()
    public override init() {
        super.init()
        addSubview(uiPickerView)
        uiPickerView.backgroundColor = UIColor.clear
        backgroundColor = UIColor.clear
    }
    open override func layoutSubviews() {
        super.layoutSubviews()
        uiPickerView.qxRect = qxBounds.rectByReduce(padding)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    open func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return items.count
    }
    open func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return bounds.width - padding.left - padding.right
    }
    open func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return rowHeight
    }
    open func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if items.count > row {
            let item = items[row]
            return item.font.nsAttributtedString(item.text)
        }
        return nil
    }
    open func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if items.count > row {
            let item = items[row]
            _selectItem = item
            _selectIndex = row
            respondPick?(item)
            respondAutoPick?(item)
        }
    }
    
}





