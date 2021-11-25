//
//  QXTimer.swift
//  Block
//
//  Created by Richard.q.x on 16/6/27.
//  Copyright © 2016年 labi3285_lab. All rights reserved.
//

/// 解决 NSTimer 无法销毁的问题

import UIKit

public enum QXTimerType {
    case timer
    case displayLink
}

public enum QXTimerLinkMode {
    case `default`
    case commons
}

open class QXTimer: NSObject {
    
    public var loop: ((_ timer: QXTimer) -> Void)?
    public func remove() {
        switch _type {
        case .timer:
            _timer?.invalidate()
            _timer = nil
        case .displayLink:
            if let runLoop = _displayRunLoop {
                if let model = _displayLinkMode {
                    _displayLink?.remove(from: runLoop, forMode: RunLoop.Mode(rawValue: model))
                }
            }
            _displayLink = nil
        }
    }
    
    public init(duration: TimeInterval) {
        super.init()
        self._type = .timer
        self._timer = Timer.scheduledTimer(timeInterval: duration, target: self, selector: #selector(QXTimer._loop), userInfo: nil, repeats: true)
    }
    
    public init(triggerCount: CGFloat? = nil, runLoop: RunLoop = RunLoop.main, mode: QXTimerLinkMode) {
        super.init()
        self._type = .displayLink
        self._displayLink = CADisplayLink(target: self, selector: #selector(QXTimer._loop))
        self._displayTriggerCount = triggerCount
        switch mode {
        case .default:
            self._displayLinkMode = RunLoop.Mode.default.rawValue
        case .commons:
            self._displayLinkMode = RunLoop.Mode.common.rawValue
        }
        self._displayRunLoop = RunLoop.main
        self._displayLink?.add(to: self._displayRunLoop!, forMode: RunLoop.Mode(rawValue: self._displayLinkMode!))
    }
    
    fileprivate var _type: QXTimerType = .timer
    fileprivate weak var _timer: Timer?
    fileprivate var _displayLink: CADisplayLink?
    fileprivate var _displayTriggerCount: CGFloat?
    fileprivate var _displayCounter: CGFloat = 0
    fileprivate var _displayLinkMode: String?
    fileprivate var _displayRunLoop: RunLoop?
    
    @objc func _loop() {
        switch _type {
        case .timer:
            loop?(self)
        case .displayLink:
            if let triggerCount  = _displayTriggerCount {
                _displayCounter += 1
                if _displayCounter == triggerCount {
                    loop?(self)
                    _displayCounter = 0
                }
            } else {
                loop?(self)
            }
        }
    }
    
    deinit {
        QXDebugPrint("timer deinit")
    }
    
}
