//
//  QXSwitch.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/10/24.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

open class QXSwitchView: QXView {
    
    public var respondChange: ((_ isOn: Bool) -> ())?
    
    public var isOn: Bool {
        set {
            uiSwitch.isOn = newValue
        }
        get {
            return uiSwitch.isOn
        }
    }
        
    public lazy var uiSwitch: UISwitch = {
        let one = UISwitch()
        one.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
        return one
    }()
    @objc func valueChanged() {
        respondChange?(uiSwitch.isOn)
    }
    
    public override init() {
        super.init()
        addSubview(uiSwitch)
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override var intrinsicContentSize: CGSize {
        if isDisplay {
            if let e = intrinsicSize {
                return e.cgSize
            } else {
                let wh = uiSwitch.intrinsicContentSize
                return CGSize(width: wh.width + padding.left + padding.right, height: wh.height + padding.top + padding.bottom)
            }
        } else {
            return CGSize.zero
        }
    }
    open override func layoutSubviews() {
        super.layoutSubviews()
        uiSwitch.qxRect = qxBounds.rectByReduce(padding)
    }
        
}

