//
//  QXSwitch.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/10/24.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

open class QXSwitchView: QXView {
    
    public var respondChange: ((_ isOn: Bool) -> Void)?
    
    open var isEnabled: Bool {
        set {
            uiSwitch.isEnabled = newValue
        }
        get {
            return uiSwitch.isEnabled
        }
    }
    
    public var isOn: Bool {
        set {
            uiSwitch.isOn = newValue
        }
        get {
            return uiSwitch.isOn
        }
    }
        
    public final lazy var uiSwitch: UISwitch = {
        let e = UISwitch()
        e.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
        return e
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
    
    open override func natureContentSize() -> QXSize {
        return uiSwitch.qxIntrinsicContentSize.sizeByAdd(padding)
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        uiSwitch.qxRect = qxBounds.rectByReduce(padding)
    }
        
}

