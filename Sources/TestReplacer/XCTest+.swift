//
//  XCTest+.swift
//  Replacer
//
//  Created by Tatsuya Tanaka (tattn) on 2017/01/01.
//  Copyright © 2017年 tattn. All rights reserved.
//

import Replacer
import XCTest


extension XCTest {

    private static let swizzleTearDown: Void = {
        let tearDown = class_getInstanceMethod(XCTest.self, #selector(XCTest.tearDown))!
        let replacerTearDown = class_getInstanceMethod(XCTest.self, #selector(XCTest.autoResetTearDown))!
        method_exchangeImplementations(tearDown, replacerTearDown)
    }()

    /// TearDown which resets all configurations automatically.
    @objc private dynamic func autoResetTearDown() {
        autoResetTearDown()

        URLStubManager.shared.unregisterAllStubs()
    }

    /// Register a stub.
    public var urlStub: URLStub {
        _ = XCTest.swizzleTearDown
        URLStubManager.shared.isEnabled = true
        
        let stub = Replacer.urlStub
        stub.bundle = Bundle(for: type(of: self))
        return stub
    }
}
