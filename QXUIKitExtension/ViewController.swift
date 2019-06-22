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
        label.qxFont = QXFont(size: 40, color: QXColor.hex("#FF0000", 1))
        label.text = "hello"

        
        
        
        
        // Do any additional setup after loading the view.
    }


}

