//
//  DemoTestVc.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/10/29.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

func AppValidatePassword(_ pwd: String) -> String? {
    var passWordRegex = "^[\\x21-\\x7e]{8,20}$"
    var passWordPredicate = NSPredicate(format: "SELF MATCHES %@", passWordRegex)
    if passWordPredicate.evaluate(with: pwd) {
        passWordRegex = ".*[0-9]+.*"
        passWordPredicate = NSPredicate(format: "SELF MATCHES %@", passWordRegex)
        if !passWordPredicate.evaluate(with: pwd) {
            return "密码未包含数字"
        }
        passWordRegex = ".*[A-Z]+.*"
        passWordPredicate = NSPredicate(format: "SELF MATCHES %@", passWordRegex)
        if !passWordPredicate.evaluate(with: pwd) {
            return "密码未包含大写字母"
        }
        passWordRegex = ".*[a-z]+.*"
        passWordPredicate = NSPredicate(format: "SELF MATCHES %@", passWordRegex)
        if !passWordPredicate.evaluate(with: pwd) {
            return "密码未包含小写字母"
        }
        return nil
    } else {
        return "请使用至少8位数字大小写字母组合"
    }
}

class DemoTestVc: QXViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "测试"
        
        navigationBarBackTitle = "x"
        
        view.backgroundColor = UIColor.yellow
        
        let now = QXDate.now
        
        now.endpointsOfDay
        now.endpointsOfWeak
        now.endpointsOfWeak

//        print(AppValidatePassword("12345") ?? "通过")
//        print(AppValidatePassword("12321321321") ?? "通过")
//        print(AppValidatePassword("1wew23213E213dd2") ?? "通过")
//        print(AppValidatePassword("12345") ?? "通过")
//        print(AppValidatePassword("12345678") ?? "通过")

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let t = QXRequest(method: QXRequest.Method.get, encoding: QXRequest.ParameterEncoding.url)
        t.url = "https://www.baidu.com"
        t.fetchData { (r) in
            print(r)
        }
        
        
    }
    
//
//    override func loadData(_ done: @escaping (QXRequest.Respond<Any>) -> ()) {
//
//        done(.succeed(123))
//
//    }
//
}
