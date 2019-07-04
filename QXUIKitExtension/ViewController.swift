//
//  ViewController.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/6/22.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    lazy var label: UILabel = {
        let one = UILabel()
        return one
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(label)
        
        label.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        var f = QXFont(size: 40, color: QXColor.hex("#FF0000", 1))
        f.backColor = QXColor.hex("#ff0000", 1)
        f.underline = true
        f.strikethrough = true
        f.color = QXColor.hex("#0000ff", 1)
        
        label.qxFont = f
        label.qxText = "hello"
        
        // Do any additional setup after loading the view.
    }


}

