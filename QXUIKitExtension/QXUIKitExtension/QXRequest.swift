//
//  QXRequest.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/7/24.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit
import Alamofire

extension QXRequest {
    
    static private let NetworkReachability = NetworkReachabilityManager(host: "http://www.baidu.com")
    public static func startListenNetwork() {
        NetworkReachability?.startListening()
    }
    public static func stopListenNetwork() {
        NetworkReachability?.stopListening()
    }
    
    public static var isNetworkOn: Bool {
        return NetworkReachability?.isReachable ?? false
    }
    
    public static var isWwan: Bool {
        if let status = NetworkReachability?.networkReachabilityStatus {
            switch status {
            case .reachable(let t):
                switch t {
                case .wwan:
                    return true
                default:
                    return false
                }
            default:
                return false
            }
        }
        return false
    }
    
}

open class QXRequest {

    public enum Method {
        case get
        case post
        case put
    }
    public enum ParameterEncoding {
        case json
        case url
        case form
    }
    
    /// 地址
    public var url: String = ""
    /// 请求参数
    public var params: [String: Any?]?
    /// 请求头
    public var headers: [String: String?]?
    
    /// 请求类型
    public let method: Method
    /// 请求参数编码
    public let encoding: ParameterEncoding
    
    /// 追加的header字段
    public let appendHeaders: [String: String?]?
    /// 追加的参数
    public let appendParams: [String: Any?]?
    
    /// 测试模式是否打印log
    public var isDebugPrint: Bool = false
            
    /// 构造方法
    public init(method: Method, encoding: ParameterEncoding, appendHeaders: [String: String?]? = nil, appendParams: [String: Any?]? = nil) {
        self.method = method
        self.encoding = encoding
        self.appendHeaders = appendHeaders
        self.appendParams = appendParams
    }
    
    public struct File {
        let data: Data
        let mineType: String
        let name: String
        let suffix: String
    }
        
    public enum Respond<T> {
        case succeed(_ data: T)
        case failed(_ err: QXError)
    }
    public enum RespondPage<T> {
        case succeed(_ models: [T], _ isThereMore: Bool)
        case failed(_ err: QXError)
    }

    public static let globalApiManager: Alamofire.SessionManager = {
        let cfg = URLSessionConfiguration.default
        cfg.timeoutIntervalForRequest = 10
        cfg.urlCredentialStorage = nil
        let e = Alamofire.SessionManager(configuration: cfg)
        return e
    }()
    public static let globalFileManager: Alamofire.SessionManager = {
        let cfg = URLSessionConfiguration.default
        cfg.timeoutIntervalForRequest = 60
        let e = Alamofire.SessionManager(configuration: cfg)
        return e
    }()
    
    /// 上传文件
    public func uploadFormData(file: File, done: @escaping (_ respond: Respond<Any>) -> Void) {
        assert(self.url.count > 0, "请填写url")
        let url = self.url
        let method = _makeMethod()
        let params = _makeParams()
        let headers = _makeHeaders()
        if isDebugPrint {
            let params = (params as NSDictionary?)?.description ?? "nil"
            let headers = (headers as NSDictionary?)?.description ?? "nil"
            QXDebugPrint("QXRequest/Upload:\(url)\nHEADERS:\(headers)\nPARAMS:\(params)")
        }
        QXRequest.globalFileManager.upload(multipartFormData: { (formData) in
            for (k, v) in params ?? [:] {
                formData.append("\(v)".data(using: .utf8)!, withName: k)
            }
            formData.append(file.data, withName: "file", fileName: file.name, mimeType: file.mineType)
        }, to: url, method: method, headers: headers) { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.uploadProgress { (progress) in
                }
                upload.responseJSON(completionHandler: { (response) in
                    if let e = response.result.value {
                        done(.succeed(e))
                    } else {
                        if let e = response.error as? AFError {
                            done(.failed(e.toQXError()))
                        } else {
                            done(.failed(QXError.unknown))
                        }
                    }
                })
            case .failure(let err):
                if let e = err as? AFError {
                    done(.failed(e.toQXError()))
                } else {
                    done(.failed(QXError.unknown))
                }
            }
        }
    }
    
    /// 上传文件列表
    public func uploadFormData(files: [File], done: @escaping (_ respond: Respond<Any>) -> Void) {
        assert(self.url.count > 0, "请填写url")
        let url = self.url
        let method = _makeMethod()
        let params = _makeParams()
        let headers = _makeHeaders()
        if isDebugPrint {
            let params = (params as NSDictionary?)?.description ?? "nil"
            let headers = (headers as NSDictionary?)?.description ?? "nil"
            QXDebugPrint("QXRequest/Upload:\(url)\nHEADERS:\(headers)\nPARAMS:\(params)")
        }
        QXRequest.globalFileManager.upload(multipartFormData: { (formData) in
            for (k, v) in params ?? [:] {
                formData.append("\(v)".data(using: .utf8)!, withName: k)
            }
            for file in files {
                formData.append(file.data, withName: "files", fileName: file.name, mimeType: file.mineType)
            }
        }, to: url, method: method, headers: headers) { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.uploadProgress { (progress) in
                }
                upload.responseJSON(completionHandler: { (response) in
                    if let e = response.result.value {
                        done(.succeed(e))
                    } else {
                        if let e = response.error as? AFError {
                            done(.failed(e.toQXError()))
                        } else {
                            done(.failed(QXError.unknown))
                        }
                    }
                })
            case .failure(let err):
                if let e = err as? AFError {
                    done(.failed(e.toQXError()))
                } else {
                    done(.failed(QXError.unknown))
                }
            }
        }
    }
    
    /// 请求 data
    public func fetchData(done: @escaping (_ respond: Respond<Any>) -> Void) {
        QXDebugAssert(url.count > 0, "请填写url")
        let url = self.url
        let method = _makeMethod()
        let encoding = _makeEncoding()
        let params = _makeParams()
        let headers = _makeHeaders()
        
        if isDebugPrint {
            let params = (params as NSDictionary?)?.description ?? "nil"
            let headers = (headers as NSDictionary?)?.description ?? "nil"
            QXDebugPrint("QXRequest/\(method):\(url)\nHEADERS:\(headers)\nPARAMS:\(params)")
        }
        
        QXRequest.globalApiManager
            .request(url, method: method, parameters: params, encoding: encoding, headers: headers)
            .validate()
            .responseJSON { (response) in
                if let e = response.result.value {
                    done(.succeed(e))
                } else {
                    var err: QXError
                    if let e = response.error as? AFError {
                        err = e.toQXError()
                    } else if let e = response.error as NSError?  {
                        err = QXError(e.code, "网络错误")
                    } else {
                        err = QXError.unknown
                        done(.failed(QXError.unknown))
                    }
                    err.info = response.data
                    done(.failed(err))
                }
        }
    }
    
    /// 请求 arr
    public func fetchArray(done: @escaping (_ respond: Respond<[Any]>) -> Void) {
        fetchData { (respond) in
            switch respond {
            case .succeed(let t):
                if let e = t as? [Any] {
                    done(.succeed(e))
                } else {
                    done(.failed(QXError.format))
                }
            case .failed(let e):
                done(.failed(e))
            }
        }
    }
    
    /// 请求 dic
    public func fetchDictionary(done: @escaping (_ respond: Respond<[String: Any]>) -> Void) {
        fetchData { (respond) in
            switch respond {
            case .succeed(let t):
                if let e = t as? [String: Any] {
                    done(.succeed(e))
                } else {
                    done(.failed(QXError.format))
                }
            case .failed(let e):
                done(.failed(e))
            }
        }
    }
    
}

extension QXRequest {
    
    fileprivate func _makeMethod() -> Alamofire.HTTPMethod {
        switch method {
        case .get:
            return HTTPMethod.get
        case .post:
            return HTTPMethod.post
        case .put:
            return HTTPMethod.put
        }
    }
    fileprivate func _makeEncoding() -> Alamofire.ParameterEncoding {
        switch encoding {
        case .url:
            return URLEncoding.default
        case .json:
            return JSONEncoding.default
        case .form:
            return PropertyListEncoding.default
        }
    }
    
    fileprivate func _makeHeaders() -> [String: String]? {
        var e = [String: String]()
        if let headers = appendHeaders {
            for (key, value) in headers {
                if let value = value {
                    e[key] = value
                }
            }
        }
        if let headers = headers {
            for (key, value) in headers {
                if let value = value {
                    e[key] = value
                }
            }
        }
        if e.count > 0 {
            return e
        }
        return nil
    }
    
    fileprivate func _makeParams() -> [String: Any]? {
        var e = [String: Any]()
        if let params = appendParams {
            for (key, value) in params {
                if let value = value {
                    e[key] = value
                }
            }
        }
        if let params = params {
            for (key, value) in params {
                if let value = value {
                    e[key] = value
                }
            }
        }
        if e.count > 0 {
            return e
        }
        return nil
    }
    
}

extension AFError {
    func toQXError() -> QXError {
        switch self {
        case .invalidURL(url: _):
            return QXError(-1, "网址无效")
        case .multipartEncodingFailed(reason: _):
            return QXError(-1, "编码错误")
        case .parameterEncodingFailed(reason: _):
            return QXError(-1, "编码错误")
        case .responseSerializationFailed(reason: _):
            return QXError(-1, "解析错误")
        case .responseValidationFailed(reason: let reason):
            switch reason {
            case .dataFileNil:
                return QXError(-1, "文件丢失")
            case .dataFileReadFailed(_):
                return QXError(-1, "读取失败")
            case .missingContentType(_):
                return QXError(-1, "字段缺失")
            case .unacceptableContentType(_, _):
                return QXError(-1, "字段不匹配")
            case .unacceptableStatusCode(let code):
                return QXError(code, "其他错误")
            }
        }
    }
}




