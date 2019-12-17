//
//  TestTableVc.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/10/24.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

class DemoListVc: QXTableViewController<QXTableViewSection> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "ListVc"
        contentView.canRefresh = true
        contentView.canPage = true
        //tableView.sectionHeaderSpace = 100
        //tableView.sectionFooterSpace = 100

        tableView.adapter = QXTableViewAdapter([
            String.self >> QXTableViewDebugCell.self,
        ])
//        let api = QXModelsApi<QXTableViewSection> { (filter, succeed, failed) in
//            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
//                failed(QXError.unknown)
//            }
//        }
//        let ms = (0..<10).map { _ in QXDebugRandomText(999) }
//        let s = QXTableViewSection(ms)
//        let mock = QXModelsMock<QXTableViewSection> { (filter) -> [QXTableViewSection] in
//            return [s]
//        }
//        api.mock = mock
                
        contentView.filter.dictionary["123"] = 345
//        contentView.api = api
    }
    
    override func didSetup() {
        super.didSetup()
        contentView.reloadData()
    }
    
    override func loadData(_ filter: QXFilter, _ done: @escaping (QXRequest.Respond<[QXTableViewSection]>) -> ()) {
        print(filter.dictionary)
        let ms = (0..<10).map { _ in QXDebugRandomText(999) }
        let s = QXTableViewSection(ms)
        done(.succeed([s]))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
//    override func qxTableViewCellClass(_ model: Any?) -> QXTableViewCell.Type? {
//        return QXTableViewDebugCell.self
//    }
    override func qxTableViewDidSelectCell(_ model: Any?) {
         print("cell")
    }
    override func qxTableViewDidSelectHeaderView(_ model: Any?) {
        print("header")
    }
    override func qxTableViewDidSelectFooterView(_ model: Any?) {
        print("footer")
    }

}

