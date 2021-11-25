//
//  QXSlogonView.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/12/5.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

open class QXSlogonView<Model>: QXButton {
        
    public var respondModel: ((_ model: Model) -> Void)?
    
    public var models: [Model] = [] {
        didSet {
            if let e = models.first {
                abView.a.qxRichTexts = modelToQXRichTextsParser(e)
            }
            clipView.layoutIfNeeded()
            if models.count > 1 {
                _removeTimer()
                _fireTimer()
            }
        }
    }
    
    public var modelToQXRichTextsParser: (_ model: Model) -> [QXRichText]
        = { e in
        let t = QXRichText.text("\(e)", QXFont.init(14, QXColor.dynamicText))
        return [t]
    }
    
    public var duration: TimeInterval = 3

    public var textAlignmentX: QXAlignmentX = .left {
        didSet {
            abView.a.textAlignment = textAlignmentX.nsTextAlignment
            abView.b.textAlignment = textAlignmentX.nsTextAlignment
        }
    }
    public var textHeight: CGFloat = 25 {
        didSet {
            _contentHeightCons?.constant = textHeight * 2
        }
    }
    
    open override func natureContentSize() -> QXSize {
        return QXSize(0, textHeight).sizeByAdd(padding)
    }

    private var _contentTopCons: NSLayoutConstraint!
    private var _contentHeightCons: NSLayoutConstraint!
    private final lazy var abView: ABView = {
        let e = ABView()
        return e
    }()
    public final lazy var clipView: UIView = {
        let e = UIView()
        e.clipsToBounds = true
        e.backgroundColor = UIColor.clear
        e.addSubview(self.abView)
        self.abView.IN(e).LEFT.RIGHT.MAKE()
        self._contentHeightCons = self.abView.HEIGHT.EQUAL(self.textHeight * 2).MAKE()
        self._contentTopCons = self.abView.TOP.EQUAL(e).MAKE()
        return e
    }()
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        let x: CGFloat = 0
        let h = textHeight
        let w = backView.qxBounds.w
        let y = (backView.qxBounds.h - h) / 2
        clipView.qxRect = QXRect(x, y, w, h)
    }
        
    override public init() {
        super.init()
        backView.addSubview(clipView)
        respondClick = { [weak self] in
            if let s = self {
                if s.models.count > 0 && s._currentIndex < s.models.count {
                    s.respondModel?(s.models[s._currentIndex])
                }
            }
        }
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var _timer: QXTimer?
    private func _fireTimer() {
        let e = QXTimer(duration: self.duration)
        e.loop = { [weak self] t in
            self?._timerLoop()
        }
        _timer = e
    }
    private func _timerLoop() {
        _tryToPage()
    }
    private func _removeTimer() {
        _timer?.remove()
        _timer = nil
    }
    deinit {
        _timer?.remove()
    }
    
    /// 采用A,B两个页面来回切换的方式实现错觉轮播
    private var _currentIndex: Int = 0
    private func _tryToPage() {
        if models.count < 2 { return }
        if _currentIndex == models.count - 1 {
            _currentIndex = -1
            abView.a.qxRichTexts = modelToQXRichTextsParser(models.last!)
            abView.b.qxRichTexts = modelToQXRichTextsParser(models.first!)
        } else {
            abView.a.qxRichTexts = modelToQXRichTextsParser(models[_currentIndex])
            abView.b.qxRichTexts = modelToQXRichTextsParser(models[_currentIndex + 1])
        }
        UIView.animate(withDuration: 1, animations: {
            self._contentTopCons.constant = -self.textHeight
            self.clipView.layoutIfNeeded()
            }, completion: { (_) in
                let a = self.abView.a.qxRichTexts
                self.abView.a.qxRichTexts = self.abView.b.qxRichTexts
                self.abView.b.qxRichTexts = a
                self._contentTopCons.constant = 0
                self.clipView.layoutIfNeeded()
        })
        _currentIndex += 1
    }
    
    private class ABView: UIView {
        lazy var a: UILabel = {
            let e = UILabel()
            e.numberOfLines = 0
            return e
        }()
        lazy var b: UILabel = {
            let e = UILabel()
            e.numberOfLines = 0
            return e
        }()
        required init() {
            super.init(frame: CGRect.zero)
            addSubview(a)
            addSubview(b)
        }
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        override func layoutSubviews() {
            super.layoutSubviews()
            a.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height / 2)
            b.frame = CGRect(x: 0, y: bounds.height / 2, width: bounds.width, height: bounds.height / 2)
        }
        
    }
    
}


open class QXRunLogonView<Model>: QXButton {
            
    public var respondModel: ((_ model: Model) -> Void)?

    public var models: [Model] = [] {
        didSet {
            _initPage()
            _removeTimer()
            _fireTimer()
        }
    }
    
    public var modelToQXRichTextsParser: (_ model: Model) -> [QXRichText]
        = { e in
        let t = QXRichText.text("\(e)", QXFont.init(14, QXColor.dynamicText))
        return [t]
    }
    
    public var step: CGFloat = 1

    private final lazy var uiLabel: UILabel = {
        let e = UILabel()
        e.textAlignment = .left
        return e
    }()
    public final lazy var clipView: UIView = {
        let e = UIView()
        e.clipsToBounds = true
        e.backgroundColor = UIColor.clear
        return e
    }()
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        clipView.qxRect = backView.qxBounds
    }
        
    override public init() {
        super.init()
        backView.addSubview(clipView)
        clipView.addSubview(uiLabel)
        respondClick = { [weak self] in
            if let s = self {
                if s.models.count > 0 && s._currentIndex < s.models.count {
                    s.respondModel?(s.models[s._currentIndex])
                }
            }
        }
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var _timer: QXTimer?
    private var _offsetX: CGFloat = 0
    private func _fireTimer() {
        let e = QXTimer(triggerCount: nil, runLoop: RunLoop.main, mode: .commons)
        e.loop = { [weak self] t in
            self?._timerLoop()
        }
        _timer = e
    }
    deinit {
        _timer?.remove()
    }
    private func _timerLoop() {
        _offsetX -= 1
        if uiLabel.frame.maxX <= 1 {
            _currentIndex += 1
            _offsetX = 0
            _initPage()
        }
        uiLabel.frame = CGRect(x: clipView.bounds.width + _offsetX, y: 0, width: uiLabel.frame.width, height: clipView.bounds.height)
    }
    private func _removeTimer() {
        _timer?.remove()
        _timer = nil
    }
    
    /// 采用A,B两个页面来回切换的方式实现错觉轮播
    private var _currentIndex: Int = 0
    private func _initPage() {
        if models.count == 0 {
            return
        } else if models.count == 2 {
            _currentIndex = 0
            if let e = models.first {
                uiLabel.qxRichTexts = modelToQXRichTextsParser(e)
            }
        } else {
            if _currentIndex > models.count - 1 {
                _currentIndex = 0
                uiLabel.qxRichTexts = modelToQXRichTextsParser(models.first!)
            } else {
                uiLabel.qxRichTexts = modelToQXRichTextsParser(models[_currentIndex])
            }
        }
        uiLabel.sizeToFit()
        uiLabel.frame = CGRect(x: clipView.bounds.width, y: 0, width: uiLabel.frame.width, height: clipView.bounds.height)
    }
    
}
