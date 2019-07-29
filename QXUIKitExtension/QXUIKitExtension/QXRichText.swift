//
//  QXFontText.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/7/13.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

func + (left: QXRichText, right: QXRichText) -> [QXRichText] {
    return [left, right]
}
func + (left: QXRichText, right: [QXRichText]) -> [QXRichText] {
    var arr = right
    arr.insert(left, at: 0)
    return arr
}
func + (left: [QXRichText], right: QXRichText) -> [QXRichText] {
    var arr = left
    arr.append(right)
    return arr
}

public enum QXRichText {
    
    case text(_ text: String, _ font: QXFont)
    case image(_ image: QXImage, _ bounds: QXRect)
    
    public var nsAttributedString: NSAttributedString {
        switch self {
        case .text(let t, let f):
            return f.nsAttributtedString(t)
        case .image(let i, let r):
            let e = NSTextAttachment(data: nil, ofType: nil)
            e.image = i.uiImage
            e.bounds = r.cgRect
            return NSAttributedString(attachment: e)
        }
    }
    
    public static func size(_ arr: [QXRichText]?, width: CGFloat) -> CGSize? {
        return nsAttributedString(arr)?.qxSize(width: width)
    }
    public static func size(_ arr: [QXRichText]?) -> CGSize? {
        return nsAttributedString(arr)?.qxSize
    }
    public func size(width: CGFloat) -> CGSize? {
        return nsAttributedString.qxSize(width: width)
    }
    public var size: CGSize {
        return nsAttributedString.qxSize
    }
    
    public static func nsAttributedString(_ arr: [QXRichText]?) -> NSAttributedString? {
        if let arr = arr {
            let e = NSMutableAttributedString()
            for a in arr {
                e.append(a.nsAttributedString)
            }
            return e.copy() as? NSAttributedString
        }
        return nil
    }
    
}

extension NSAttributedString {
    
    public func qxSize(width: CGFloat) -> CGSize {
        return boundingRect(with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude),
                            options: .usesLineFragmentOrigin,
                            context: nil).size
    }
    public var qxSize: CGSize {
        return qxSize(width: CGFloat.greatestFiniteMagnitude)
    }
    
}

extension UILabel {
    
    public var qxRichText: QXRichText? {
        set {
            if let e = newValue {
                qxRichTexts = [e]
            } else {
                qxRichTexts = nil
            }
        }
        get {
            return qxRichTexts?.first
        }
    }
    
    public var qxRichTexts: [QXRichText]? {
        set {
            objc_setAssociatedObject(self, &UILabel.kUILabelQXRichTextAssociateKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            attributedText = QXRichText.nsAttributedString(newValue)
        }
        get {
            if let e = objc_getAssociatedObject(self, &UILabel.kUILabelQXRichTextAssociateKey) as? [QXRichText] {
                return e
            }
            return nil
        }
    }
    private static var kUILabelQXRichTextAssociateKey: String = "kUILabelQXRichTextAssociateKey"
    
    
}

extension UITextView {
    
    public var qxRichText: QXRichText? {
        set {
            if let e = newValue {
                qxRichTexts = [e]
            } else {
                qxRichTexts = nil
            }
        }
        get {
            return qxRichTexts?.first
        }
    }
    
    public var qxRichTexts: [QXRichText]? {
        set {
            objc_setAssociatedObject(self, &UITextView.kQXRichTextsUITextViewAssociateKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            attributedText = QXRichText.nsAttributedString(newValue)
        }
        get {
            if let e = objc_getAssociatedObject(self, &UITextView.kQXRichTextsUITextViewAssociateKey) as? [QXRichText] {
                return e
            }
            return nil
        }
    }
    private static var kQXRichTextsUITextViewAssociateKey: String = "kQXRichTextsUITextViewAssociateKey"
    
    
}
