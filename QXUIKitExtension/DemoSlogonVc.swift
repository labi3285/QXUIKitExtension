//
//  DemoSlogonVc.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/12/5.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

class DemoSlogonVc: QXViewController {
    
    lazy var slogonView: QXSlogonView<String> = {
        let e = QXSlogonView<String>()
        e.models = ["11111111", "222222222", "3333333333", "444444444"]
        e.modelToQXRichTextsParser = { str in
            return [QXRichText.text(str, QXFont.init(16, QXColor.red))]
        }
        e.textAlignmentX = .center
        e.respondModel = { str in
            print(str)
        }
        return e
    }()
    
    lazy var slogon1View: QXRunLogonView<String> = {
        let e = QXRunLogonView<String>()
        e.models = ["11111111", "222222222", "3333333333", "444444444"]
        e.qxBackgroundColor = QXColor.yellow
        e.respondModel = { str in
            print(str)
        }
        return e
    }()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "QXSlogonView"
        view.addSubview(slogonView)
        view.addSubview(slogon1View)

        
        slogonView.IN(view).CENTER.TOP(100).WIDTH(200).MAKE()
        slogon1View.IN(view).CENTER.TOP(200).WIDTH(200).HEIGHT(30).MAKE()

    }
    
}
