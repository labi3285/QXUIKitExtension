//
//  QXSegmentView.swift
//  Project
//
//  Created by labi3285 on 2020/2/4.
//  Copyright © 2020 labi3285_lab. All rights reserved.
//

import UIKit

open class QXSegsControlView: QXView {
    
    public var respondChange: ((_ index: Int) -> Void)?
    
    open var segs: [String] = [] {
        didSet {
            uiSegsControl.removeAllSegments()
            for (i, s) in segs.enumerated() {
                uiSegsControl.insertSegment(withTitle: s, at: i, animated: false)
            }
            uiSegsControl.selectedSegmentIndex = 0
        }
    }
    
    public var current: Int {
        set {
            uiSegsControl.selectedSegmentIndex = newValue
        }
        get {
            return uiSegsControl.selectedSegmentIndex
        }
    }
        
    public final lazy var uiSegsControl: UISegmentedControl = {
        let e = UISegmentedControl()
        
        e.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
        return e
    }()
    @objc func valueChanged() {
        respondChange?(uiSegsControl.selectedSegmentIndex)
    }
    
    public override init() {
        super.init()
        addSubview(uiSegsControl)
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func natureContentSize() -> QXSize {
        return uiSegsControl.qxIntrinsicContentSize.sizeByAdd(padding)
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        uiSegsControl.qxRect = qxBounds.rectByReduce(padding)
    }
        
}

