//
//  DemoModelsVc.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/12/12.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

class TestAnimal: QXModelProtocol {
    required public init() { }
    var age: Int = 0
}
class TestPerson: TestAnimal {
    enum TestGender: Int, QXEnumProtocol {
        case man = 1
        case woman = 2
        case unknown = 3
    }
    var name: String?
    var gender: TestGender = .unknown
}

struct TestPoint: QXModelProtocol {
    var x: Double = 0
    var y: Double = 0
}

class DemoModelVc: QXViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "测试模型解析"
                
        let point = TestPoint(dictionary: [
            "x": 123,
            "y": "456"
        ])
        print(point.toDictionary())
        
        let s = TestPerson(any: "{\"age\":12}")
        print(s)
        
        let a = CGFloat(any: "123")
        print(a)

        let stu = TestPerson(dictionary: [
            "age": 12,
            "name": "xiaohua",
            "gender": 1,
        ])
        print(stu.toDictionary())
        
    }
    
}
