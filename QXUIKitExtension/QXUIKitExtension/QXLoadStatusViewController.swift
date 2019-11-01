//
//  QXLoadStatusView.swift
//  QXViewController
//
//  Created by labi3285 on 2019/7/5.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

open class QXLoadStatusViewController<Model>: QXViewController {

    public lazy var loadStatusView: QXLoadStatusView = {
        let one = QXLoadStatusView()
        return one
    }()
    public lazy var contentView: QXContentLoadStatusView<Model> = {
        let one = QXContentLoadStatusView<Model>(contentView: UIView(), loadStatusView: self.loadStatusView)
        return one
    }()

    override open func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(contentView)
        contentView.IN(view).LEFT.RIGHT.TOP.BOTTOM.MAKE()
        
//        contentView.api = { ok, failed in
//            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
//                let ms = (0..<5).map { _ in QXDebugRandomText(333) }
//                ok(ms, true)
//            }
//        }
    }

}
