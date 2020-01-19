//
//  QXCollectionViewController.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2020/1/19.
//  Copyright © 2020 labi3285_lab. All rights reserved.
//

import UIKit

open class QXCollectionViewController<Model>: QXViewController {
    
    public final lazy var collectionView: QXCollectionView = {
        let e = QXCollectionView()
        return e
    }()
    public final lazy var loadStatusView: QXLoadStatusView = {
        let e = QXLoadStatusView()
        return e
    }()
    
    public final lazy var contentView: QXModelsLoadStatusView<Model> = {
        let e = QXModelsLoadStatusView<Model>(contentView: self.collectionView, loadStatusView: self.loadStatusView)
        e.api = { [weak self] filter, done in
            self?.loadData(filter, done)
        }
        return e
    }()
        
    open func loadData(_ filter: QXFilter, _ done: @escaping (QXRequest.RespondPage<Model>) -> Void) {
        done(.failed(QXError(-1, "请重写loadData或者提供api")))
    }
    
    open override func viewDidLayoutSubviews() {
        contentView.qxRect = view.qxBounds
        contentView.layoutSubviews()
        collectionView.layoutSubviews()
        super.viewDidLayoutSubviews()
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(contentView)
        
//        contentView.canPageFilter = true
//        contentView.canRefresh = true
//        contentView.api = { ok, failed in
//             DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
//                 let ms = (0..<5).map { _ in QXDebugRandomText(333) }
//                 ok(ms, true)
//             }
//         }
    }

}

