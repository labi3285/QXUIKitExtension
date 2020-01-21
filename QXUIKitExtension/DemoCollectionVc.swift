//
//  DemoCollectionView.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2020/1/19.
//  Copyright © 2020 labi3285_lab. All rights reserved.
//

import UIKit

class DemoCollectionVc: QXCollectionViewController<QXCollectionViewSection> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "QXCollectionView"
        contentView.canRefresh = true
        contentView.canPage = true
        
        collectionView.isPlain = false
        collectionView.adapter = QXCollectionViewAdapter([
            String.self >> QXCollectionViewDebugCell.self,
        ], headerMappings: [
            String.self >> QXCollectionViewDebugHeaderFooterView.self,
        ], footerMappings: [
            String.self >> QXCollectionViewDebugHeaderFooterView.self,
        ])
                
        navigationBarRightItem = QXBarButtonItem.titleItem("xxx", {
            self._isLoad = true
            self.contentView.reloadData()
        })
    }
    
    override func didSetup() {
        super.didSetup()
        contentView.filter.dictionary["123"] = 345
        contentView.reloadData()
    }
    
    private var _isLoad: Bool = false
    override func loadData(_ filter: QXFilter, _ done: @escaping (QXRequest.RespondPage<QXCollectionViewSection>) -> Void) {
        print(filter.dictionary)
        DispatchQueue.main.qxAsyncAfter(1) {
            if self._isLoad {
                done(.succeed([], false))
            } else {
                let ms = (0..<20).map { _ in QXDebugRandomText(99) }
                let s = QXCollectionViewSection(ms, "header", "footer")
                done(.succeed([s], true))
            }
        }
    }
    
    override func collectionViewDidSelectCell(_ cell: QXCollectionViewCell, for model: Any, in section: QXCollectionViewSection) {
        let vc = DemoTestVc()
        push(vc)
    }

    
}
