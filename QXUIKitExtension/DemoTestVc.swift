//
//  DemoTestVc.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/10/29.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit
import SQLite3

let kr = UIScreen.main.bounds.width / 375

class DemoTestVc: QXTableViewController<Any> {
    
    lazy var textCell: QXStaticTextCell = {
        let e = QXStaticTextCell()
        e.label.font = QXFont(16 * kr, QXColor.red)
        e.label.padding = QXEdgeInsets(16 * kr, 24 * kr, 16 * kr, 24 * kr)
        e.label.text = "呵呵呵：\n分类为你奉为你发呢为你奉为丰富温暖"
        e.label.qxDebugRandomColor()
        return e
    }()
    
    lazy var imageView: QXImageView = {
        let e = QXImageView()
//        let url = URL(string: "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fc-ssl.duitang.com%2Fuploads%2Fitem%2F202003%2F29%2F20200329043918_2FUvk.thumb.400_0.gif&refer=http%3A%2F%2Fc-ssl.duitang.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1650108971&t=5f83e8b4ea724051a802dfff5fa2df1a")
//                
//        e.uiImageView.yy_setImage(with: url, options: [])
//        e.qxDebugRandomColor()
        e.image = QXImage(url: "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fc-ssl.duitang.com%2Fuploads%2Fitem%2F202003%2F29%2F20200329043918_2FUvk.thumb.400_0.gif&refer=http%3A%2F%2Fc-ssl.duitang.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1650108971&t=5f83e8b4ea724051a802dfff5fa2df1a")
        return e
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "测试"
        navigationBarBackgroundColor = QXColor.red
        navigationBarBackArrowImage = QXImage("icon_option1")
        navigationBarBackTitle = "tt"
        
        if #available(iOS 13.0, *) {
            if #available(iOS 14.0, *) {
                navigationItem.backBarButtonItem = UIBarButtonItem.init(systemItem: .close)
            } else {
                // Fallback on earlier versions
            }
        } else {
            // Fallback on earlier versions
        }
        
        view.addSubview(imageView)
        imageView.IN(view).CENTER.SIZE(100, 100).MAKE()
        
        contentView.models = [
            textCell
        ]
    }
    
    override func didSetup() {
        super.didSetup()
        
        
//        let name = "截屏2020-07-28下午11.15.37.jepg"
//        let path = QXPath.cache /+ "upload" /+ name
//        let dir = path.qxString(start: 0, end: path.count - 1)
//        print(dir)        
    }

}
