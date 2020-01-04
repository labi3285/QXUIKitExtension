//
//  QXLoadStatusView.swift
//  QXViewController
//
//  Created by labi3285 on 2019/7/5.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

open class QXLoadStatusViewController<Model>: QXViewController {

    public final lazy var loadStatusView: QXLoadStatusView = {
        let e = QXLoadStatusView()
        return e
    }()
    public final lazy var contentView: QXContentLoadStatusView<Model> = {
        let e = QXContentLoadStatusView<Model>(contentView: UIView(), loadStatusView: self.loadStatusView)
        e.api = { [weak self] done in
            self?.loadData(done)
        }
        return e
    }()
    
    open func loadData(_ done: @escaping (QXRequest.Respond<Model>) -> Void) {
        done(.failed(QXError(-1, "请重写loadData或者提供api")))
    }

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
