//
//  ViewController.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/6/22.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

class TestVc: QXViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "xx"
        view.qxBackgroundColor = QXColor.backgroundGray
        navigationBarBackArrowImage = QXImage("icon_back")
        navigationBarBackItem = QXBarButtonItem.titleItem(title: "x", styles: nil)
        isNavigationBarLineShow = false
        navigationBarBackgroundColor = QXColor.green
        navigationBarTitle = "test"
        navigationBarTitleFont = QXFont(size: 20, color: QXColor.brown)
        navigationBarTintColor = QXColor.red
        //isNavigationBarShow = true
    }
    
    @objc func dismiss1() {
        dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let vc = TestVc()
        push(vc)
//        let nav = QXNavigationController(rootViewController: vc)
//        present(nav)
        
//        dismiss1()
//        navigationController?.qxRemoveViewController(0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

class ViewController: QXViewController {

    lazy var button: QXButton = {
        let one = QXButton()
        one.qxBackgroundColor = QXColor.white
//        one.qxShadow = QXShadow()
//        one.qxBorder = QXBorder.border
        one.qxCornerRadius = 5
        
        one.backgroundColorNormal = QXColor.red
        one.backgroundColorSelected = QXColor.blue
        
//        one.borderNormal = QXBorder.border.setColor(QXColor.fmtHex("#00ff00"))
//        one.borderHighlighted = QXBorder.border.setColor(QXColor.fmtHex("#0000ff"))

        one.shadowNormal = QXShadow.shadow.setColor(QXColor.red)
//        one.shadowDisabled = QXShadow.shadow.setColor(QXColor.blue)
        
//        one.respondTouchUpOutside = {
//            print("respondTouchUpOutside")
//        }
//        one.respondTouchUpInside = {
//            print("respondTouchUpInside")
//        }
//        one.respondTouchBegan = {
//            print("respondTouchBegan")
//        }
//        one.respondTouchMoved = {
//            print("respondTouchMoved")
//        }
//        one.respondTouchCancelled = {
//            print("respondTouchCancelled")
//        }
//        one.respondTouchEnded = {
//            print("respondTouchEnded")
//        }
        one.respondClick = {
//            let vc = TestVc()
//            self.navigationController?.pushViewController(vc, animated: true)
            print("respondClick")
            self.button.isSelected = !self.button.isSelected
        }
        return one
    }()
    
//    lazy var label: UILabel = {
//        let one = UILabel()
//        one.qxBackgroundColor = QXColor.white
//        one.qxShadow = QXShadow()
//        one.qxBorder = QXBorder.border
//        one.qxCornerRadius = 5
////        one.qxFont = QXFont(fmt: "16 #ff0000 B")
////        one.qxText = "标签"
//        one.qxRichTexts =
//            QXRichText.image(QXImage("icon"), QXRect(0, -3, 20, 20)) +
//            QXRichText.text("标签", QXFont(fmt: "16 #ff0000"))
//        return one
//    }()
//
    lazy var back: UIView = {
        let one = UIView()
        one.qxBackgroundColor = QXColor.white
        return one
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        navigationBarTitle = "Home"
        view.addSubview(back)
        
        view.addSubview(button)
        
        back.qxRect = view.qxBounds.insideRect(.left(10), .right(10), .top(10), .bottom(10))
        button.qxRect = back.qxRect.insideRect(.center, .size(80, 40))
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
//        let vc = TestVc()
//        let nav = QXNavigationController(rootViewController: vc)
//        present(nav)
        
//        push(vc)
    }


}

