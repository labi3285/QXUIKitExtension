//
//  DemoTestVc.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/10/29.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit
import DSImageBrowse

class DemoTestVc: QXViewController {
    

    lazy var v: QXPicturesView = {
        let one = QXPicturesView(9)
        let e = "http://gss0.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/d788d43f8794a4c240e9466f0ef41bd5ac6e39af.jpg"

        one.pictures = [QXImage(url: e), QXImage(url: e), QXImage(url: e), QXImage(url: e), QXImage(url: e), QXImage(url: e), QXImage(url: e), QXImage(url: e), QXImage(url: e), QXImage(url: e), QXImage(url: e)]
//        one.applyConfigs(viewsWidth: 80, viewsHeight: 80)
        one.applyConfigs(intrinsicWidth: 300, xCount: 3, hwRatio: 1)
        return one
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Test"
        view.backgroundColor = UIColor.yellow
        view.addSubview(v)
        v.IN(view).CENTER.MAKE()
    }
        
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        

        
//        for i in (0..<100) {
//
//            let e = Bundle.main.path(forResource: "icon_big.png", ofType: nil)!
//            pics.append(UIImage(contentsOfFile: e)!)
////
////            pics.append(UIImage(named: "icon_big")!)
//        }
//
        
        
    }
    
}
