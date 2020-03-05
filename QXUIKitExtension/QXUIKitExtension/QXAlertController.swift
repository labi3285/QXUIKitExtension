//
//  QXAlertViewController.swift
//  Project
//
//  Created by labi3285 on 2020/1/16.
//  Copyright © 2020 labi3285_lab. All rights reserved.
//

import UIKit

open class QXAction {
    public enum Style {
        case normal
        case destructive
        case cancel
    }
    open var title: String?
    open var tip: String?
    open var icon: QXImage?
    open var style: Style = .normal
    open var isEnabled: Bool = true {
        didSet {
            respondUpdateEnabled?(isEnabled)
        }
    }
    open var todo: (() -> Void)?
    
    public init(_ title: String?, _ todo: (() -> Void)?) {
        self.title = title
        self.todo = todo
    }
    
    public var respondUpdateEnabled: ((_ isEnabled: Bool) -> Void)?
}

open class QXInput {
    open var text: String?
    open var placeHolder: String?
    open var filter: QXTextFilter?
    open var respondTextChange: ((_ text: String?, _ isEmpty: Bool) -> Void)?
    public init() { }
}

open class QXAlertController: UIAlertController {
    
    public static func confirm(_ title: String?, _ tips: String?, _ confirm: QXAction, _ cancel: String?) -> QXAlertController {
        let vc = QXAlertController.init(title: title, message: tips, preferredStyle: .alert)
        vc._confirm = confirm
        let style: UIAlertAction.Style
        switch confirm.style {
        case .normal:
            style = .default
        case .cancel:
            style = .cancel
        case .destructive:
            style = .destructive
        }
        let uiAction = UIAlertAction(title: confirm.title, style: style, handler: { [unowned confirm] (a) in
            confirm.todo?()
        })
        uiAction.isEnabled = confirm.isEnabled
        confirm.respondUpdateEnabled = { [unowned uiAction] isEnabled in
            uiAction.isEnabled = isEnabled
        }
        vc.addAction(uiAction)
        if let e = cancel {
            vc.addAction(UIAlertAction.init(title: e, style: .cancel, handler: nil))
        }
        return vc
    }
    
    public static func actionSheet(_ title: String?, _ tips: String?, _ actions: [QXAction], _ cancel: String?) -> QXAlertController {
        let vc = QXAlertController.init(title: title, message: tips, preferredStyle: .actionSheet)
        vc._actions = actions
        for action in actions {
            let style: UIAlertAction.Style
            switch action.style {
            case .normal:
                style = .default
            case .cancel:
                style = .cancel
            case .destructive:
                style = .destructive
            }
            let uiAction = UIAlertAction(title: action.title, style: style, handler: { [unowned action] (a) in
                action.todo?()
            })
            uiAction.isEnabled = action.isEnabled
            action.respondUpdateEnabled = { [unowned uiAction] isEnabled in
                uiAction.isEnabled = isEnabled
            }
            vc.addAction(uiAction)
        }
        if let e = cancel {
            vc.addAction(UIAlertAction.init(title: e, style: .cancel, handler: nil))
        }
        return vc
    }
    
    public static func input(_ title: String?, _ tips: String?, _ input: QXInput, _ confirm: QXAction, _ cancel: String?) -> QXAlertController {
        let vc = QXAlertController.init(title: title, message: tips, preferredStyle: .alert)
        vc.addTextField { [unowned vc] (tf) in
            tf.qxUpdateFilter(input.filter)
            tf.addTarget(vc, action: #selector(textChange(_:)), for: .editingChanged)
            tf.placeholder = input.placeHolder
            tf.text = input.text
        }
        vc._input = input
        vc._confirm = confirm
        let style: UIAlertAction.Style
        switch confirm.style {
        case .normal:
            style = .default
        case .cancel:
            style = .cancel
        case .destructive:
            style = .destructive
        }
        let uiAction = UIAlertAction(title: confirm.title, style: style, handler: { [unowned confirm] (a) in
            confirm.todo?()
        })
        uiAction.isEnabled = confirm.isEnabled
        confirm.respondUpdateEnabled = { [unowned uiAction] isEnabled in
            uiAction.isEnabled = isEnabled
        }
        vc.addAction(uiAction)
        if let e = cancel {
            vc.addAction(UIAlertAction.init(title: e, style: .cancel, handler: nil))
        }
        return vc
    }
    @objc func textChange(_ textField: UITextField) {
        func hasSelectRange() -> Bool {
            if let range =  textField.markedTextRange {
                if textField.position(from: range.start, offset: 0) != nil {
                    return true
                }
            }
            return false
        }
        
        if !hasSelectRange() {
            if let filter = _input?.filter {
                let _text = filter.filte(textField.text ?? "")
                if _text != textField.text {
                    textField.text = _text
                }
            }
        }
        _input?.text = textField.text
        _input?.respondTextChange?(textField.text, {
            if let text = textField.text {
                return text.isEmpty
            }
            return true
        }())
    }
    private var _confirm: QXAction?
    private var _actions: [QXAction]?
    private var _input: QXInput?

}
