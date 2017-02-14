//
//  SampleAppTests.swift
//  SampleAppTests
//
//  Created by Tatsuya Tanaka on 2017/02/12.
//  Copyright © 2017年 tattn. All rights reserved.
//

import XCTest
import Alamofire
import Replacer
import TestReplacer

@testable import SampleApp

class SampleAppTests: XCTestCase {

    var url = URL(string: "http://echo.jsontest.com/key/value/one/two")!

    func testJSONFile() {
        self.urlStub.url("echo.jsontest.com").json(filename: "sample")

        let expectation = self.expectation(description: "")
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            let json = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String: String]
            XCTAssert(json["test"] == "data")
            expectation.fulfill()
        }.resume()

        self.waitForExpectations(timeout: 0.02, handler: nil)
    }

    func testXmlString() {
        self.urlStub.url("echo.jsontest.com").xmlString()

        let expectation = self.expectation(description: "")

        URLSession.shared.dataTask(with: url) { data, _, _ in
            XCTAssert(String(data: data!, encoding: .utf8) == "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"true\"?>")
            expectation.fulfill()
        }.resume()

        self.waitForExpectations(timeout: 0.02, handler: nil)
    }
}

extension Replacer.URLStub {
    @discardableResult
    func xmlString() -> Self {
        return response { request -> (Data?, Error?) in
            ("<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"true\"?>".data(using: .utf8), nil)
        }
    }
}
