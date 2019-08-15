//
//  UIBarButtonItem_ext.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/7/5.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

open class QXBarButtonItem: UIBarButtonItem {
    
    public static func backItem(title: String, styles: QXControlStateStyles?) -> QXBarButtonItem {
        let e = QXBarButtonItem()
        e.title = title
        if let styles = styles {
            do {
                let style = styles.normal
                if let dic = style.font?.nsAttributtes {
                    e.setTitleTextAttributes(dic, for: .normal)
                }
            }
            if let style = styles.disabled {
                if let dic = style.font?.nsAttributtes {
                    e.setTitleTextAttributes(dic, for: .disabled)
                }
            }
            if let style = styles.highlighted {
                if let dic = style.font?.nsAttributtes {
                    e.setTitleTextAttributes(dic, for: .highlighted)
                }
            }
            if let style = styles.selected {
                if let dic = style.font?.nsAttributtes {
                    e.setTitleTextAttributes(dic, for: .selected)
                }
            }
        }
        return e
    }
    
    public static func titleItem(title: String, styles: QXControlStateStyles?) -> QXBarButtonItem {
        let e = QXBarButtonItem(title: title, style: .plain, target: nil, action: #selector(itemClick))
        e.target = e
        if let styles = styles {
            do {
                let style = styles.normal
                if let dic = style.font?.nsAttributtes {
                    e.setTitleTextAttributes(dic, for: .normal)
                }
            }
            if let style = styles.disabled {
                if let dic = style.font?.nsAttributtes {
                    e.setTitleTextAttributes(dic, for: .disabled)
                }
            }
            if let style = styles.highlighted {
                if let dic = style.font?.nsAttributtes {
                    e.setTitleTextAttributes(dic, for: .highlighted)
                }
            }
            if let style = styles.selected {
                if let dic = style.font?.nsAttributtes {
                    e.setTitleTextAttributes(dic, for: .selected)
                }
            }
        }
        return e
    }
    
    public static func iconItem(icon: String, styles: QXControlStateStyles?) -> QXBarButtonItem {
        let e = QXBarButtonItem(image: UIImage(named: icon), style: .plain, target: self, action: #selector(itemClick))
        return e
    }
    
    @objc func itemClick() {
        respondClick?()
    }
    public var respondClick: (() -> ())?
    
}
