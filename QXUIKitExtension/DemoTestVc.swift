//
//  DemoTestVc.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/10/29.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

class DemoTestVc: QXViewController {
    

    var pics: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.yellow
    }
        
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for i in (0..<100) {
            
            let e = Bundle.main.path(forResource: "icon_big.png", ofType: nil)!
            pics.append(UIImage(contentsOfFile: e)!)
//
//            pics.append(UIImage(named: "icon_big")!)
        }
        
        
        
    }
    
}
