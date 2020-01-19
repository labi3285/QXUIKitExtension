//
//  DemoTestVc.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/10/29.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit
import SQLite3

class DemoTestVc: QXViewController {
    
    
    lazy var collectionView: QXCollectionView = {
        let e = QXCollectionView()
        return e
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "测试"
        
        navigationBarBackTitle = "x"
        
        view.backgroundColor = UIColor.yellow
        
        collectionView.isPlain = true
        view.addSubview(collectionView)
        collectionView.IN(view).LEFT.RIGHT.TOP.BOTTOM.MAKE()
        
        collectionView.adapter = QXCollectionViewAdapter([
            String.self >> QXCollectionViewDebugCell.self,
        ], headerMappings: [
            String.self >> QXCollectionViewDebugHeaderFooterView.self,
        ], footerMappings: [
            String.self >> QXCollectionViewDebugHeaderFooterView.self,
        ])
        
        let ss1 = QXCollectionViewSection([
            "cell", "cell", "cell", "cell", "cell", "cell", "cell", "cell", "cell", "cell", "cell",
        ], "test", "test")
        
        let ss2 = QXCollectionViewSection([
            "cell", "cell", "cell", "cell", "cell", "cell", "cell", "cell", "cell", "cell", "cell",
        ], QXSpace(10), QXSpace(10))
        
        collectionView.sections = [
            ss1,
            ss2,
        ]
    }

}
