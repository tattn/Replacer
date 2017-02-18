//
//  TestReplacerTests.swift
//  TestReplacerTests
//
//  Created by Tatsuya Tanaka on 2017/02/12.
//  Copyright © 2017年 tattn. All rights reserved.
//

import XCTest
import Alamofire
@testable import TestReplacer

class TestReplacerTests: XCTestCase {

    var url = URL(string: "http://echo.jsontest.com/key/value/one/two")!

    #if !SPM // https://bugs.swift.org/browse/SR-2866
    func testJSONFile() {
        self.urlStub.url("echo.jsontest.com").json(filename: "sample", bundle: nil)

        let expectation = self.expectation(description: "")
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            let json = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String: String]
            XCTAssert(json["test"] == "data")
            expectation.fulfill()
        }.resume()

        self.waitForExpectations(timeout: 0.02, handler: nil)
    }
    #endif

    func testJSONObject() {
        self.urlStub.url("echo.jsontest.com/[a-z]+/.*").json(["test2": "data2"])

        let expectation = self.expectation(description: "")

        URLSession(configuration: .default).dataTask(with: url) { data, _, _ in
            let json = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String: String]
            XCTAssert(json["test2"] == "data2")
            expectation.fulfill()
        }.resume()

        self.waitForExpectations(timeout: 0.02, handler: nil)
    }

    func testAlamofire() {
        self.urlStub.url("echo.jsontest.com").json(["test3": "data3"])

        let expectation = self.expectation(description: "")

        Alamofire.request(url).responseJSON { response in
            let json = response.result.value as! [String: String]
            XCTAssert(json["test3"] == "data3")
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 0.02, handler: nil)
    }

    func testTimeout() {
        self.urlStub.url("echo.jsontest.com").json([:]).delay(2)

        let expectation = self.expectation(description: "")
        let expectation2 = self.expectation(description: "")

        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 1

        URLSession(configuration: configuration).dataTask(with: url) { _, _, error in
            XCTAssert(error?._code == URLError.timedOut.rawValue)
            expectation.fulfill()
        }.resume()

        SessionManager(configuration: configuration).request(url).responseJSON { response in
            XCTAssert(response.result.error?._code == URLError.cancelled.rawValue)
            expectation2.fulfill()
        }

        self.waitForExpectations(timeout: 3, handler: nil)
    }

    func testError() {
        self.urlStub.url("echo.jsontest.com").error(NSError(domain: "", code: URLError.badServerResponse.rawValue))

        let expectation = self.expectation(description: "")
        let expectation2 = self.expectation(description: "")

        URLSession.shared.dataTask(with: url) { _, _, error in
            XCTAssert(error?._code == URLError.badServerResponse.rawValue)
            expectation.fulfill()
        }.resume()

        SessionManager.default.request(url).responseJSON { response in
            XCTAssert(response.result.error?._code == URLError.badServerResponse.rawValue)
            expectation2.fulfill()
        }

        self.waitForExpectations(timeout: 0.02, handler: nil)
    }

    func testHTTPMethod() {
        self.urlStub.url("echo.jsontest.com").httpMethod(.get).json([:])
        self.urlStub.url("echo.jsontest.com").httpMethod(.post).json(["test4": "data4"])

        let expectation = self.expectation(description: "")
        let expectation2 = self.expectation(description: "")

        Alamofire.request(url).responseJSON { response in
            let json = response.result.value as? [String: String]
            XCTAssertNil(json?["test4"])
            expectation.fulfill()
        }

        Alamofire.request(url, method: .post).responseJSON { response in
            let json = response.result.value as! [String: String]
            XCTAssert(json["test4"] == "data4")
            expectation2.fulfill()
        }

        self.waitForExpectations(timeout: 0.02, handler: nil)
    }

    func testRequestBlock() {
        self.urlStub.response { request in
            let json = try! JSONSerialization.data(withJSONObject: ["test5": "data5"], options: .prettyPrinted)
            return (json, nil)
        }

        let expectation = self.expectation(description: "")

        Alamofire.request(url).responseJSON { response in
            let json = response.result.value as! [String: String]
            XCTAssert(json["test5"] == "data5")
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 0.02, handler: nil)
    }

    func testStatusCode() {
        self.urlStub.statusCode(123).json([:])

        let expectation = self.expectation(description: "")
        let expectation2 = self.expectation(description: "")

        URLSession.shared.dataTask(with: url) { _, response, _ in
            XCTAssert((response as? HTTPURLResponse)?.statusCode == 123)
            expectation.fulfill()
        }.resume()
        
        Alamofire.request(url).responseJSON { response in
            XCTAssert(response.response?.statusCode == 123)
            expectation2.fulfill()
        }

        self.waitForExpectations(timeout: 0.02, handler: nil)
    }
}
