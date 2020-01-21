//
//  QXCollectionViewController.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2020/1/19.
//  Copyright © 2020 labi3285_lab. All rights reserved.
//

import UIKit

open class QXCollectionViewController<Model>: QXViewController, QXCollectionViewDelegate {
    
    public final lazy var collectionView: QXCollectionView = {
        let e = QXCollectionView()
        e.delegate = self
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
        
    override open func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(contentView)
    }
    
    open override func viewDidLayoutSubviews() {
        contentView.qxRect = view.qxBounds
        contentView.layoutSubviews()
        collectionView.layoutSubviews()
        super.viewDidLayoutSubviews()
    }
    
    open func collectionViewDidSetupCell(_ cell: QXCollectionViewCell, for model: Any, in section: QXCollectionViewSection) {}
    open func collectionViewDidSelectCell(_ cell: QXCollectionViewCell, for model: Any, in section: QXCollectionViewSection) {}
    
    open func collectionViewDidSetupHeaderView(_ headerView: QXCollectionViewHeaderFooterView, for model: Any, in section: QXCollectionViewSection) {}
    open func collectionViewDidSelectHeaderView(_ headerView: QXCollectionViewHeaderFooterView, for model: Any, in section: QXCollectionViewSection) {}
    
    open func collectionViewDidSetupFooterView(_ footerView: QXCollectionViewHeaderFooterView, for model: Any, in section: QXCollectionViewSection) {}
    open func collectionViewDidSelectFooterView(_ footerView: QXCollectionViewHeaderFooterView, for model: Any, in section: QXCollectionViewSection) {}

    open func collectionViewDidMove(from: IndexPath, to: IndexPath, in sections: [QXCollectionViewSection]) {}
    
    open func collectionViewNeedsReloadData() {}

}

