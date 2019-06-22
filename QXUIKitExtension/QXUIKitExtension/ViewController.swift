//
//  ViewController.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/6/22.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var a = "abc"
        
        a = a.qxSubStringWithoutPrefix("a")
        
        print(a)
        

        
        
        // Do any additional setup after loading the view.
    }


}

