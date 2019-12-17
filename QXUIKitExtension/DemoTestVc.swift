//
//  DemoTestVc.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/10/29.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

class TestCell: UITableViewCell {
    
    lazy var label: QXLabel = {
        let e = QXLabel()
        e.text = QXDebugText(9999)
        e.numberOfLines = 0
        return e
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
        label.IN(contentView).LEFT.RIGHT.TOP.BOTTOM.MAKE()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class DemoTestVc: QXViewController {
    
    lazy var table: QXTableView = {
        let e = QXTableView()
        let c = QXStaticTextCell()
        c.label.text = QXDebugText(99)
        
        let h = QXStaticHeaderView()
        h.label.text = QXDebugText(99)
        let f = QXStaticHeaderView()
        f.label.text = QXDebugText(99)
        
        e.adapter = QXTableViewAdapter([
            String.self >> QXTableViewDebugCell.self
        ])

        e.sections = [
            QXTableViewSection([c, QXDebugText(99)], h, f)
        ]
        
        e.backgroundColor = UIColor.green
        return e
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "测试"
        view.backgroundColor = UIColor.yellow
        
        view.addSubview(table)
        table.fixWidth = 300
        table.IN(view).TOP.CENTER.MAKE()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let t = CFAbsoluteTimeGetCurrent()
        let cell = TestCell(style: .default, reuseIdentifier: "123")
        for i in 0...1000 {
           let size = CGSize(width: UIScreen.main.bounds.width, height: 0)
           let size1 = cell.systemLayoutSizeFitting(size, withHorizontalFittingPriority: UILayoutPriority.required, verticalFittingPriority: UILayoutPriority.defaultLow)
           print(size1)
        }
        let t1 = CFAbsoluteTimeGetCurrent()
        print(t1 - t)
        
    }
    
//
//    override func loadData(_ done: @escaping (QXRequest.Respond<Any>) -> ()) {
//
//        done(.succeed(123))
//
//    }
//
}
