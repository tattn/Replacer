//
//  ReplacerTests.swift
//  ReplacerTests
//
//  Created by Tatsuya Tanaka on 2017/02/12.
//  Copyright © 2017年 tattn. All rights reserved.
//

import XCTest
@testable import Replacer


class ReplacerTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testReplaceStaticMethod() {

        class A {
            dynamic class func a() -> String { return "a" }
        }

        class B {
            dynamic class func b() -> String { return "b" }
        }

        replaceStatic(#selector(A.a), of: A.self, with: #selector(B.b), of: B.self)

        XCTAssertEqual(A.a(), "b")
        XCTAssertEqual(B.b(), "a")

        replaceStatic(#selector(A.a), of: A.self, with: #selector(B.b), of: B.self)

        XCTAssertEqual(A.a(), "a")
        XCTAssertEqual(B.b(), "b")
    }

    func testReplaceInstanceMethod() {

        class A {
            dynamic func a() -> String { return "a" }
        }

        class B {
            dynamic func b() -> String { return "b" }
        }

        replaceInstance(#selector(A.a), of: A.self, with: #selector(B.b), of: B.self)

        XCTAssertEqual(A().a(), "b")
        XCTAssertEqual(B().b(), "a")

        replaceInstance(#selector(A.a), of: A.self, with: #selector(B.b), of: B.self)

        XCTAssertEqual(A().a(), "a")
        XCTAssertEqual(B().b(), "b")
    }
    
}
