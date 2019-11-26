//
//  QXView.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/7/20.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit


extension QXView {
    
    /// 很大的长度
    public static let extendLength: CGFloat = 99999
    /// 很大的尺寸
    public static let extendSize: QXSize = QXSize(99999, 99999)

    /// 容易变形
    public static let resistanceEasyDeform: CGFloat = 250
    /// 正常
    public static let resistanceNormal: CGFloat = 750
    /// 不怎么变形
    public static let resistanceStable: CGFloat = 1000
    
}

public protocol QXViewProtocol {

    /// 是否显示
    var isDisplay: Bool { get set }
    /// 固有的大小
    var natureSize: QXSize { get }
    /// 添加到父视图
    func addAsQXSubview(_ superview: UIView)
    /// 更新尺寸
    func updateRect(_ rect: QXRect)
    /// 水平抵抗拉伸的等级
    var compressResistanceX: CGFloat { get set }
    /// 垂直抵抗拉伸的等级
    var compressResistanceY: CGFloat { get set }
    /// 水平抵抗延展的等级
    var stretchResistanceX: CGFloat { get set }
    /// 垂直抵抗延展的等级
    var stretchResistanceY: CGFloat { get set }
    
    /// 在容器里面如何均摊，nil表示不均摊
    var divideRatioX: CGFloat? { get set }
    /// 在容器里面如何均摊，nil表示不均摊
    var divideRatioY: CGFloat? { get set }
    
}
extension QXViewProtocol {
    public var isDisplay: Bool { get { return true } set {} }
    public var natureSize: QXSize { return QXSize.zero  }
    public func addAsQXSubview(_ superview: UIView) { }
    public func updateRect(_ rect: QXRect) { }
    public var compressResistanceX: CGFloat { get { return 0 } set {} }
    public var compressResistanceY: CGFloat { get { return 0 } set {} }
    public var stretchResistanceX: CGFloat { get { return 0 } set {} }
    public var stretchResistanceY: CGFloat { get { return 0 } set {} }
    public var divideRatioX: CGFloat? { get { return nil } set {} }
    public var divideRatioY: CGFloat? { get { return nil } set {} }
    
}

open class QXView: UIView, QXViewProtocol {
    
    open var padding: QXEdgeInsets = QXEdgeInsets.zero
    
    public init() {
        super.init(frame: CGRect.zero)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        setNeedsDisplay()
    }
    
    public var respondNeedsLayout: (() -> ())?
    
    override open func invalidateIntrinsicContentSize() {
        super.invalidateIntrinsicContentSize()
        respondNeedsLayout?()
    }
    
    public var extendSize: Bool {
        set {
            extendWidth = newValue
            extendHeight = newValue
        }
        get {
            return extendWidth && extendHeight
        }
    }
    public var extendWidth: Bool = false
    public var extendHeight: Bool = false

    public var fixSize: QXSize?
    public var fixWidth: CGFloat?
    public var fixHeight: CGFloat?
    public var maxWidth: CGFloat?
    public var minWidth: CGFloat?
    public var maxHeight: CGFloat?
    public var minHeight: CGFloat?
    open func natureContentSize() -> QXSize {
        return QXSize.zero
    }
    
    //MARK:- System
    
    open override var intrinsicContentSize: CGSize {
        return natureSize.cgSize
    }
    open override func systemLayoutSizeFitting(_ targetSize: CGSize) -> CGSize {
        return sizeThatFits(targetSize)
    }
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        let wh = intrinsicContentSize
        var w = wh.width
        var h = wh.height
        w = min(size.width, w)
        h = min(size.height, h)
        return CGSize(width: w, height: h)
    }
    override open func sizeToFit() {
        let wh = intrinsicContentSize
        frame = CGRect(x: frame.minX, y: frame.minY, width: wh.width, height: wh.height)
    }

    //MARK:- QXViewProtocol
    
    open var isDisplay: Bool = true {
        didSet {
            isHidden = !isDisplay
        }
    }
    open func addAsQXSubview(_ superview: UIView) {
        superview.addSubview(self)
    }
    open func updateRect(_ rect: QXRect) {
        qxRect = rect
    }
    public var natureSize: QXSize {
        if isDisplay {
            if extendSize {
                return QXView.extendSize
            }
            if let e = fixSize {
                return e
            }
            let wh = natureContentSize()
            var w = wh.w
            var h = wh.h
            if let e = minWidth { w = max(e, w) }
            if let e = maxWidth { w = min(e, w) }
            if let e = minHeight { h = max(e, h) }
            if let e = maxHeight { h = min(e, h) }
            if extendWidth {
                w = QXView.extendLength
            } else {
                if let e = fixWidth { w = e }
            }
            if extendHeight {
                h = QXView.extendLength
            } else {
                if let e = fixHeight { h = e }
            }
            return QXSize(w, h)
        }
        return QXSize.zero
    }
    open var compressResistanceX: CGFloat {
        set {
            setContentCompressionResistancePriority(UILayoutPriority(Float(newValue)), for: .horizontal)
        }
        get {
            return CGFloat(contentCompressionResistancePriority(for: .horizontal).rawValue)
        }
    }
    open var compressResistanceY: CGFloat {
        set {
            setContentCompressionResistancePriority(UILayoutPriority(Float(newValue)), for: .vertical)
        }
        get {
            return CGFloat(contentCompressionResistancePriority(for: .vertical).rawValue)
        }
    }
    open var stretchResistanceX: CGFloat {
        set {
            setContentHuggingPriority(UILayoutPriority(Float(newValue)), for: .horizontal)
        }
        get {
            return CGFloat(contentHuggingPriority(for: .horizontal).rawValue)
        }
    }
    open var stretchResistanceY: CGFloat {
        set {
            setContentHuggingPriority(UILayoutPriority(Float(newValue)), for: .vertical)
        }
        get {
            return CGFloat(contentHuggingPriority(for: .vertical).rawValue)
        }
    }
    
    open var compressResistance: CGFloat {
        set {
            compressResistanceX = newValue
            compressResistanceY = newValue
        }
        get {
            return QXDebugFatalError("请不要读取这个值，没有任何意义",
                                     (compressResistanceX + compressResistanceY) / 2)
        }
    }
    
    open var divideRatioX: CGFloat? = nil
    open var divideRatioY: CGFloat? = nil
    
}

extension QXView {
    
    public var viewController: QXViewController? {
        return qxViewController as? QXViewController
    }
    
}

extension UIView {
    
    public var qxViewController: UIViewController? {
        var next: UIResponder? = self
        repeat {
            next = next?.next
            if let vc = next as? UIViewController {
                return vc
            }
            
        } while next != nil
        return nil
    }
    
}


extension UIView {
    
    public func qxSetNeedsLayout() {
        invalidateIntrinsicContentSize()
        setNeedsLayout()
        setNeedsDisplay()
    }
    
    public var qxVc: UIViewController? {
        var view: UIView? = self
        while view != nil {
            if let r = view?.next {
                if r.isKind(of: UIViewController.self) {
                    return r as? UIViewController
                }
            }
            view = view?.superview
        }
        return nil
    }
    
    public var qxIntrinsicContentSize: QXSize{
        return intrinsicContentSize.qxSize
    }
    
    public func qxCheckOrAddSubview(_ view: UIView) {
        if let superview = view.superview {
            if superview === self {
                superview.bringSubviewToFront(view)
            } else {
                view.removeFromSuperview()
                addSubview(view)
            }
        } else {
            addSubview(view)
        }
    }
    
    public func qxCheckOrRemoveFromSuperview() {
        if superview != nil {
           removeFromSuperview()
        }
    }
    
}

extension QXView {
    open override var description: String {
        return "\(type(of: self))\(self.frame)"
    }
}


