//
//  QXButton.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/7/13.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

open class QXButton: UIView {
    
    public var isEnabled: Bool =  true { didSet { update() } }
    public var isSelected: Bool = false { didSet { update() } }

    public var respondTouchUpInside: (() -> ())?
    public var respondTouchUpOutside: (() -> ())?

    public var respondTouchDown: (() -> ())?
    public var respondTouchMoved: (() -> ())?
    public var respondTouchEnded: (() -> ())?
    public var respondTouchCancelled: (() -> ())?
    
    public var backgroundColorNormal: QXColor? { set { qxBackgroundColor = newValue } get { return qxBackgroundColor } }
    public var shadowNormal: QXShadow? { set { qxShadow = newValue } get { return qxShadow } }
    public var borderNormal: QXBorder? { set { qxBorder = newValue } get { return qxBorder } }

    public var backgroundColorHighlighted: QXColor?
    public var shadowHighlighted: QXShadow?
    public var borderHighlighted: QXBorder?

    public var backgroundColorSelected: QXColor?
    public var shadowSelected: QXShadow?
    public var borderSelected: QXBorder?
 
    public var backgroundColorDisabled: QXColor?
    public var shadowDisabled: QXShadow?
    public var borderDisabled: QXBorder?
    
    public var respondClick: (() -> ())?
    /// 触发点击的容忍距离
    public var clickMoveTolerance: CGFloat = 20
    /// 点击的高光效果持续时间，默认0.3秒, nil 表示不会延时
    public var clickHighlightDelaySecs: Double? = 0.3
    
    /// 高亮的alpha，nil表示不生效
    public var highlightAlpha: CGFloat?
    /// 无效的alpha，nil表示不生效
    public var disableAlpha: CGFloat? = 0.3

    open func update() {
        if isEnabled {
            isUserInteractionEnabled = true
            if isSelected {
                handleSelected()
            } else {
                handleNormalize()
            }
        } else {
            isUserInteractionEnabled = false
            handleDisabled(isSelected: isSelected)
        }
    }
    
    open func handlePrepareOrigins() {
        _originBackgoundColor = backgroundColorNormal
        _originShadow = shadowNormal
        _originBorder = borderNormal
        _originAlpha = alpha
    }
    open func handleNormalize() {
        qxBackgroundColor = _originBackgoundColor
        qxShadow = _originShadow
        qxBorder = _originBorder
        alpha = _originAlpha ?? 1
    }
    open func handleHighlighted() {
        if !_isOriginPrepared {
            handlePrepareOrigins()
            _isOriginPrepared = true
        }
        qxBackgroundColor = backgroundColorHighlighted ?? _originBackgoundColor
        qxShadow = shadowHighlighted ?? _originShadow!
        qxBorder = borderHighlighted ?? _originBorder!
        if let a = highlightAlpha {
            alpha = a
        }
    }
    open func handleSelected() {
        if !_isOriginPrepared {
            handlePrepareOrigins()
            _isOriginPrepared = true
        }
        qxBackgroundColor = backgroundColorSelected ?? _originBackgoundColor
        qxShadow = shadowSelected ?? _originShadow!
        qxBorder = borderSelected ?? _originBorder!
    }
    open func handleDisabled(isSelected: Bool) {
        if !_isOriginPrepared {
            handlePrepareOrigins()
            _isOriginPrepared = true
        }
        qxBackgroundColor = backgroundColorDisabled ?? _originBackgoundColor
        qxShadow = shadowDisabled ?? _originShadow!
        qxBorder = borderDisabled ?? _originBorder!
        if let a = disableAlpha {
            alpha = a
        } else {
            alpha = 1
        }
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        respondTouchDown?()
        handleHighlighted()
        _touchBeganPoint = touches.first?.location(in: self)
    }
    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        respondTouchMoved?()
    }
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        respondTouchEnded?()
        if let t = touches.first, let p = _touchBeganPoint {
            let p1 = t.location(in: self)
            if bounds.contains(p1) {
                var isClickTriggered: Bool = false
                if sqrt(pow(p.x - p1.x, 2) + pow(p.y - p1.y, 2)) < clickMoveTolerance {
                    if let f = respondClick {
                        isClickTriggered = true
                        f()
                    }
                }
                respondTouchUpInside?()
                if isClickTriggered {
                    if let e = clickHighlightDelaySecs {
                        UIView.animate(withDuration: e) {
                            self.update()
                        }
                    } else {
                        update()
                    }
                } else {
                    update()
                }
            } else {
                respondTouchUpOutside?()
                update()
            }
        }
    }
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        respondTouchCancelled?()
    }
    private var _touchBeganPoint: CGPoint?
    private var _isOriginPrepared: Bool = false
    private var _originBackgoundColor: QXColor?
    private var _originShadow: QXShadow?
    private var _originBorder: QXBorder?
    private var _originAlpha: CGFloat?

}
