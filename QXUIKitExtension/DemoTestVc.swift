//
//  DemoTestVc.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/10/29.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

class DemoTestVc: QXViewController {
    
    typealias Item = QXPickerView.Item
    
    lazy var xx: QXPickerKeyboardView = {
        
        let a = QXPickerView()
        a.suffixView = {
            let e = QXLabel()
            e.text = "省"
            return e
        }()
        
        let b = QXPickerView()
        b.suffixView = {
            let e = QXLabel()
            e.text = "市"
            return e
        }()
        let c = QXPickerView()
        c.suffixView = {
            let e = QXLabel()
            e.text = "区"
            return e
        }()
        
        let e = QXPickerKeyboardView([a, b, c], isLazyMode: false)

        var aa: [QXPickerView.Item] = []
        for i in 0..<3 {
            let item = QXPickerView.Item.init(i, "a\(i)", nil)
            var bb: [QXPickerView.Item] = []
            for j in 0..<QXDebugRandomInt(3) {
                let item = QXPickerView.Item.init(j, "b\(i)\(j)", nil)
                var cc: [QXPickerView.Item] = []
                for k in 0..<QXDebugRandomInt(3) {
                    let item = QXPickerView.Item.init(k, "c\(i)\(j)\(k)", nil)
                    cc.append(item)
                }
                item.children = cc
                bb.append(item)
            }
            item.children = bb
            aa.append(item)
        }
        e.items = aa
        e.respondItem = { item in
            
            print(item)
            
        }
        
        return e
    }()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.yellow
        view.addSubview(xx)
        xx.IN(view).LEFT(5).RIGHT(5).CENTER.HEIGHT(200).MAKE()
    }
    
    func qxPickerView(_ pickerView: QXPickerView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func qxPickerView(_ pickerView: QXPickerView, titleForRow row: Int, inSection section: Int) -> String? {
        return QXDebugRandomText(5)
    }
    func qxPickerView(_ pickerView: QXPickerView, didSelectRow row: Int, inSection section: Int) {
        print("\(section)  - \(row)")
    }
}
