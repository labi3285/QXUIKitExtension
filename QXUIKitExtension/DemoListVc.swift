//
//  TestTableVc.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/10/24.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

class TestTipHeadCell: QXStaticCell {
    lazy var slogonView: QXRunLogonView<String> = {
        let e = QXRunLogonView<String>()
        e.models = ["注意：当一个QXStaticCell遵循QXLoadStatusProtocol的时候，那么页面的加载状态也会指示在这个Cell"]
        e.qxBackgroundColor = QXColor.yellow
        e.respondModel = { str in
            print(str)
        }
        return e
    }()
    required init() {
        super.init()
        fixHeight = 30
        contentView.qxBackgroundColor = QXColor.orange
        contentView.addSubview(slogonView)
        slogonView.IN(contentView).LEFT.RIGHT.TOP.BOTTOM.MAKE()
    }
    public required init(_ reuseId: String) {
        fatalError("init(_:) has not been implemented")
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class DemoListVc: QXTableViewController<Any> {
    
    lazy var headTipCell: TestTipHeadCell = {
        let e = TestTipHeadCell()
        return e
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "ListVc"
        tableView.isPlain = true
        contentView.canRefresh = true
        contentView.canPage = true
        //tableView.sectionHeaderSpace = 100
        //tableView.sectionFooterSpace = 100

        tableView.adapter = QXTableViewAdapter([
            String.self >> QXTableViewDebugCell.self,
        ])
             
        contentView.staticModels = [
            QXTableViewSection([
                self.headTipCell
            ])
        ]

        navigationBarRightItem = QXBarButtonItem.titleItem("xxx", {
            self._isFailed = true
            self.contentView.reloadData()
        })
    }
    
    override func tableViewDidSelectCell(_ cell: QXTableViewCell, for model: Any, in section: QXTableViewSection) {
        let vc = DemoTestVc()
        push(vc)
    }
    
    override func didSetup() {
        super.didSetup()
        contentView.filter.dictionary["123"] = 345
        contentView.reloadData()
    }
    
    private var _isFailed: Bool = false
    override func loadData(_ filter: QXFilter, _ done: @escaping (QXRequest.RespondPage<Any>) -> Void) {
        print(filter.dictionary)
        DispatchQueue.main.qxAsyncAfter(1) {
            if self._isFailed {
                done(.failed(QXError("-1", "失败了")))
            } else {
                self._isFailed = true
                let ms = (0..<10).map { _ in QXDebugRandomText(999) }
                done(.succeed(ms, true))
            }
        }
    }
    
}

