//
//  DemoTestVc.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/10/29.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

let kClrOrange = QXColor.fmtHex("#ff6800")
let kClrBlue = QXColor.fmtHex("#3082fb")
let kClr333 = QXColor.fmtHex("#333333")
let kClr999 = QXColor.fmtHex("#999999")
let kClrFFF = QXColor.white
let kClr000 = QXColor.black

let kr = UIScreen.main.bounds.width / 375

class DemoTestVc: QXViewController {
    
    lazy var titleLabel: QXLabel = {
        let e = QXLabel()
        e.font = QXFont(size: 24 * kr, color: kClr333, bold: true)
        e.intrinsicWidth = 9999
        e.text = "欢迎注册网通宝"
        return e
    }()
    lazy var phoneField: QXTextField = {
        let e = QXTextField()
        e.padding = QXEdgeInsets(0, 20, 0, 20)
        e.intrinsicSize = QXSize(9999, 50 * kr)
        e.placeHolderfont = QXFont(size: 14 * kr, color: kClr999)
        e.placeHolder = "请输入手机号"
        e.filter = QXTextFilter.number(limit: 11)
        e.font = QXFont(size: 14 * kr, color: kClr333)
        let line = QXLineView.breakLine
        e.addSubview(line)
        line.IN(e).BOTTOM.LEFT.RIGHT.MAKE()
        return e
    }()
    lazy var verifyField: QXTextField = {
        let e = QXTextField()
        e.padding = QXEdgeInsets(0, 120, 0, 20)
        e.intrinsicSize = QXSize(9999, 50 * kr)
        e.placeHolderfont = QXFont(size: 14 * kr, color: kClr999)
        e.placeHolder = "请输入验证码"
        e.filter = QXTextFilter.number(limit: 4)
        e.font = QXFont(size: 14 * kr, color: kClr333)
        let line = QXLineView.breakLine
        e.addSubview(line)
        line.IN(e).BOTTOM.LEFT.RIGHT.MAKE()
        e.addSubview(self.verifyButton)
        self.verifyButton.IN(e).RIGHT(20).CENTER.MAKE()
        return e
    }()
    lazy var verifyButton: QXTitleButton = {
        let e = QXTitleButton()
        e.backView.qxBackgroundColor = kClrOrange
        e.backView.qxBorder = QXBorder().setCornerRadius(4)
        e.backView.backgroundColorDisabled = kClr999
        e.font = QXFont(size: 14 * kr, color: kClrFFF)
        e.title = "获取验证码"
        e.intrinsicSize = QXSize(90 * kr, 35 * kr)
        e.respondClick = { [weak self] in
            self?.handleCountDown()
        }
        return e
    }()
    private var _verifyCounting: Bool = false
    private var _verifyCount: Int = 60
    func handleCountDown() {
//        let phone = Account.shared.mine.phone
//        let model = PhoneModel()
//        model.number = phone
//        if let msg = model.invalidate {
//            showWarning(msg: msg)
//            return
//        }
//        codeCell.verifyButton.isEnabled = false
//        view.isUserInteractionEnabled = false
//        model.getVerifyCode(type: .changeOldPhone, succeed: { [weak self] in
//            self?.view.isUserInteractionEnabled = true
//            self?.updateText("验证码已发送至：\(AppSecurePhone(Account.shared.mine.phone))")
//            self?._verifyCounting = true
//            self?._verifyCountDown()
//        }) { [weak self] (err) in
//            self?.view.isUserInteractionEnabled = true
//            self?.codeCell.verifyButton.isEnabled = true
//            self?.showFailure(msg: err.message)
//        }
        
        _verifyCounting = true
        verifyButton.isEnabled = false
        _verifyCountDown()
    }
    private func _verifyCountDown() {
        if _verifyCounting == false {
            return
        }
        verifyButton.title = "\(_verifyCount)s"
        _verifyCount -= 1
        if _verifyCount < 0 {
            _verifyCount = 5
            _verifyCounting = false
            verifyButton.isEnabled = true
            verifyButton.title = "获取验证码"
            return
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) { [weak self] in
            self?._verifyCountDown()
        }
    }
    
    
    lazy var passwordField: QXTextField = {
        let e = QXTextField()
        e.padding = QXEdgeInsets(0, 20, 0, 20)
        e.intrinsicSize = QXSize(9999, 50 * kr)
        e.placeHolderfont = QXFont(size: 14 * kr, color: kClr999)
        e.placeHolder = "请输入密码"
        e.filter = QXTextFilter.characters(limit: 20, regex: nil)
        e.uiTextField.isSecureTextEntry = true
        e.font = QXFont(size: 14 * kr, color: kClr333)
        let line = QXLineView.breakLine
        e.addSubview(line)
        line.IN(e).BOTTOM.LEFT.RIGHT.MAKE()
        return e
    }()
    lazy var passwordField1: QXTextField = {
        let e = QXTextField()
        e.padding = QXEdgeInsets(0, 20, 0, 20)
        e.intrinsicSize = QXSize(9999, 50 * kr)
        e.placeHolderfont = QXFont(size: 14 * kr, color: kClr999)
        e.placeHolder = "请再输入密码"
        e.filter = QXTextFilter.characters(limit: 20, regex: nil)
        e.uiTextField.isSecureTextEntry = true
        e.font = QXFont(size: 14 * kr, color: kClr333)
        let line = QXLineView.breakLine
        e.addSubview(line)
        line.IN(e).BOTTOM.LEFT.RIGHT.MAKE()
        return e
    }()
    
    lazy var protocolSelectButton: QXImageButton = {
        let e = QXImageButton()
        e.padding = QXEdgeInsets(10, 5, 10, 10)
        e.highlightAlpha = 0.3
        e.image = QXImage("icon_option0").setSize(QXSize(15 * kr, 15 * kr))
        e.imageSelected = QXImage("icon_option1").setSize(QXSize(15 * kr, 15 * kr))
        e.respondClick = { [unowned e] in
            e.isSelected = !e.isSelected
        }
        return e
    }()
    lazy var protocolLabel: QXLabel = {
        let e = QXLabel()
        e.font = QXFont(size: 14 * kr, color: kClr333)
        e.text = "已阅读并同意"
        return e
    }()
    lazy var protocolButton: QXTitleButton = {
        let e = QXTitleButton()
        e.font = QXFont(size: 14 * kr, color: kClrBlue)
        e.intrinsicMinHeight = 40 * kr
        e.highlightAlpha = 0.3
        e.title = "《网通宝隐私协议》"
        return e
    }()
    
    lazy var commitButton: QXTitleButton = {
        let e = QXTitleButton()
        e.qxBackgroundColor = kClrOrange
        e.qxBorder = QXBorder().setCornerRadius(5)
        e.font = QXFont(size: 14 * kr, color: kClrFFF)
        e.title = "下一步"
        e.intrinsicMinHeight = 50 * kr
        e.intrinsicWidth = 9999
        return e
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isNavigationBarShow = false

        let stack1: QXStackView = {
            let e = QXStackView()
            e.alignmentY = .center
            e.alignmentX = .left
            e.intrinsicWidth = 9999
            e.setupViews(
                protocolSelectButton,
                protocolLabel,
                protocolButton
            )
            return e
        }()
        let stack: QXStackView = {
            let e = QXStackView()
            e.isVertical = true
            e.viewMargin = 10
            e.alignmentX = .center
            e.padding = QXEdgeInsets(QXDevice.statusBarHeight + 50 * kr, 20, 50 * kr, 20)
            e.setupViews(
                titleLabel,
                QXFlexView(1),
                phoneField,
                verifyField,
                passwordField,
                passwordField1,
                stack1,
                QXFlexView(5),
                commitButton
            )
            return e
        }()
        
        view.addSubview(stack)
        stack.IN(view).LEFT.RIGHT.TOP.BOTTOM.MAKE()

        
    }
    
}
