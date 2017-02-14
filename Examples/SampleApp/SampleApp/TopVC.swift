//
//  TopVC.swift
//  SampleApp
//
//  Created by Tatsuya Tanaka on 2017/02/12.
//  Copyright © 2017年 tattn. All rights reserved.
//

import UIKit
import Alamofire
import Replacer

class TopVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Replacer.urlStub.url("stuburl").json(["key": "value"])

        Alamofire.request("stuburl").responseJSON { response in
            if let json = response.result.value as? [String: String] {
                print("URLStub ============")
                print(json)
            }
        }

        class A: NSObject {
            @objc class func a() -> String { return "a" }
        }

        class B: NSObject {
            @objc class func b() -> String { return "b" }
        }

        
        replaceStatic(#selector(A.a), of: A.self, with: #selector(B.b), of: B.self)

        print(A.a())

        replaceStatic(#selector(A.a), of: A.self, with: #selector(B.b), of: B.self)

        print(A.a())
    }
}

