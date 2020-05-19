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
    /// 从父视图移除
    func removeFromSuperview()
    
    /// 更新尺寸
    func updateRect(_ rect: QXRect)
    /// 水平抵抗压缩的等级
    var compressResistanceX: CGFloat { get set }
    /// 垂直抵抗压缩的等级
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
    public func removeFromSuperview() { }
    
    public func updateRect(_ rect: QXRect) { }
    public var compressResistanceX: CGFloat { get { return 0 } set {} }
    public var compressResistanceY: CGFloat { get { return 0 } set {} }
    public var stretchResistanceX: CGFloat { get { return 0 } set {} }
    public var stretchResistanceY: CGFloat { get { return 0 } set {} }
    public var divideRatioX: CGFloat? { get { return nil } set {} }
    public var divideRatioY: CGFloat? { get { return nil } set {} }
    
    public var isSelected: Bool { get { return false } set {} }

}

open class QXView: UIView, QXViewProtocol {
    
    open var padding: QXEdgeInsets = QXEdgeInsets.zero
    
    public init() {
        super.init(frame: CGRect.zero)
    }
    open var backLayers: [QXLayer]? {
        didSet {
            if let es = oldValue {
                for e in es {
                    e.layer.removeFromSuperlayer()
                }
            }
            if let es = backLayers {
                for e in es {
                    backLayersContainerLayer.addSublayer(e.layer)
                }
                if backLayersContainerLayer.superlayer == nil {
                    layer.insertSublayer(backLayersContainerLayer, at: 0)
                }
            }
            setNeedsLayout()
        }
    }
    open var backColor: QXColor? {
        set {
            qxBackgroundColor = newValue
        }
        get {
            return qxBackgroundColor
        }
    }
    
    open var shadow: QXShadow? {
        set {
            self.qxShadow = newValue
        }
        get {
            return qxShadow
        }
    }
    
    open var border: QXBorder? {
        set {
            self.qxBorder = newValue
        }
        get {
            return qxBorder
        }
    }
    
    public final lazy var backLayersContainerLayer: CALayer = {
        let e = CALayer()
        e.masksToBounds = true
        return e
    }()
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        setNeedsDisplay()
        if let es = backLayers {
            backLayersContainerLayer.frame = bounds
            backLayersContainerLayer.cornerRadius = layer.cornerRadius
            for e in es {
                e.layer.frame = bounds
                e.layer.cornerRadius = layer.cornerRadius
            }
        }
    }
    
    public var respondNeedsLayout: (() -> Void)?
    
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
        let wh = natureSize
        var w = wh.w
        var h = wh.h
        w = min(size.width, w)
        h = min(size.height, h)
        return CGSize(width: w, height: h)
    }
    override open func sizeToFit() {
        let wh = natureSize
        frame = CGRect(x: frame.minX, y: frame.minY, width: wh.w, height: wh.h)
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
    override open func removeFromSuperview() {
        super.removeFromSuperview()
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

extension UIView {
    
    public func qxSetNeedsLayout() {
        invalidateIntrinsicContentSize()
        setNeedsLayout()
        setNeedsDisplay()
    }
    
    public var uiViewController: UIViewController? {
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
    public var qxViewController: QXViewController? {
        return uiViewController as? QXViewController
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



