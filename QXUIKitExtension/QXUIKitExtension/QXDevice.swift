//
//  QXDevice.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/8/19.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

public struct QXDevice {
    
    /// 设备别名
    public static var deviceAlice: String {
        return UIDevice.current.name
    }
    /// 设备名称
    public static var deviceName: String {
        return UIDevice.current.systemName
    }
    /// 系统版本
    public static var systemVersion: String {
        return UIDevice.current.systemVersion
    }

    /// 设备型号
    public static var deviceModel: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone9,1":                               return "iPhone 7 (CDMA)"
        case "iPhone9,3":                               return "iPhone 7 (GSM)"
        case "iPhone9,2":                               return "iPhone 7 Plus (CDMA)"
        case "iPhone9,4":                               return "iPhone 7 Plus (GSM)"
            
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,7", "iPad6,8":                      return "iPad Pro"
        case "AppleTV5,3":                              return "Apple TV"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
    
    /// app名称
    public static var appName: String {
        return Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? ""
    }
    /// 设备型号
    public static var appVersion: String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }
    
    /// 是否刘海屏
    public static var isLiuHaiScreen: Bool {
        switch UIApplication.shared.statusBarOrientation {
        case .landscapeLeft, .landscapeRight:
            return UIScreen.main.bounds.width / UIScreen.main.bounds.height > 1.8
        default:
            return UIScreen.main.bounds.height / UIScreen.main.bounds.width > 1.8
        }
    }
    
    /// 状态栏高度
    public static var statusBarHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.height
    }
    
    /// 导航栏高度
    public static var navigationBarHeight: CGFloat {
        switch UIApplication.shared.statusBarOrientation {
        case .landscapeLeft, .landscapeRight:
            return 32
        default:
            return 44
        }
    }
    
    /// tabbar高度
    public static var tabBarHeight: CGFloat {
        return 49
    }
    
}

extension QXDevice {
    
    public static var isAppRelease: Bool {
        var e = true
        #if DEBUG
            e = false
        #endif
        return e
    }
    
    public static let schemaPhone = "telprompt://"
    public static let schemaEmail = "mailto://"
    
    public static func openUrl(_ url: String, _ onVc: UIViewController?) {
        func _openUrl(_ url: String, _ onVc: UIViewController?) {
            if isOpenningURL { return }
            isOpenningURL = true
            /// 防止频繁调用
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
                isOpenningURL = false
            }
            if canOpenUrl(url) {
                UIApplication.shared.openURL(URL(string: url)!)
            } else {
                onVc?.showFailure(msg: "无效访问")
            }
        }
        #if TARGET_IPHONE_SIMULATOR
            if url.hasPrefix(schemaPhone) {
                onVc.showWarning(msg: "模拟器不支持电话")
            } else {
                _openUrl(url, onVc)
            }
        #else
            _openUrl(url, onVc)
        #endif
    }
    public static func canOpenUrl(_ url: String) -> Bool {
        if let url = URL(string: url) {
            return UIApplication.shared.canOpenURL(url)
        }
        return false
    }
    public private(set) static var isOpenningURL = false
    
}


extension QXDevice {
    
    public enum AuthorStatus {
        case authorized
        case notDetermined
        case denied
    }
    
}

extension QXDevice {
    
    /// 查看话筒权限
    public static var microphoneAuthorStatus: AuthorStatus {
        let status = AVCaptureDevice.authorizationStatus(for: .audio)
        switch status {
        case .authorized:
            return .authorized
        case .denied, .restricted:
            return .denied
        case .notDetermined:
            return .notDetermined
        @unknown default:
            QXDebugPrint("未知话筒状态")
            return .notDetermined
        }
    }
    
    /// 申请话筒权限
    public static func checkOrRequestMicrophoneAuthorization(done: @escaping ((_ granted: Bool) -> Void)) {
        switch microphoneAuthorStatus {
        case .authorized:
            done(true)
        default:
            AVAudioSession.sharedInstance().requestRecordPermission { (granted) in
                done(granted)
            }
        }
    }
}

extension QXDevice {
    
    /// 保存图片
    public static func saveImage(_ image: UIImage?, _ done: @escaping () -> (), _ onVc: UIViewController?) {
        guard let image = image else {
            onVc?.showWarning(msg: "图片无效")
            return
        }
        weak var vc = onVc
        func todo() {
            vc?.showLoading(msg: nil)
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAsset(from: image)
            }, completionHandler: { success, error in
                DispatchQueue.main.async {
                    vc?.hideLoading()
                    if success {
                        done()
                    } else {
                        vc?.showSuccess(msg: "保存失败")
                    }
                }
            })
        }
        func checkAlbumAuthor() -> Bool {
            let status = PHPhotoLibrary.authorizationStatus()
            switch status {
            case .authorized:
                return true
            case .denied, .restricted:
                vc?.view.endEditing(true)
                let alert = UIAlertController(title: "访问受限", message: "请到设置中检查相册访问权限。", preferredStyle: .alert)
                alert.addAction(UIAlertAction.init(title: "设置", style: .default, handler: { (a) in
                    openUrl(UIApplication.openSettingsURLString, vc)
                }))
                alert.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: nil))
                vc?.present(alert, animated: true, completion: nil)
                return false
            default:
                PHPhotoLibrary.requestAuthorization { (s) in
                    switch s {
                    case .authorized:
                        todo()
                    default:
                        break
                    }
                }
                return false
            }
        }
        if checkAlbumAuthor() {
            todo()
        }
    }
    
}

