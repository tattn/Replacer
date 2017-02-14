# Replacer
Replacer is an easy-to-use library to stub HTTP requests and to swizzle methods.

Specifically, URLSession's response can be replaced with any JSON, Data, and so on....  
It uses **method chaining** to set stubs up.

# How to use

## Stub HTTP Request

### XCTest

```swift
import Replacer
import TestReplacer 

class SampleTests: XCTestCase {
    func testJSONFile() {
        // register a stub
        self.stub.url("echo.jsontest.com").json(["test": "data"])
        
        // load sample.json & register a stub.
        self.stub.json(filename: "sample")

        let expectation = self.expectation(description: "")
        
        let url = URL(string: "http://echo.jsontest.com/key/value/one/two")!
        URLSession(configuration: .default).dataTask(with: url) { data, _, _ in
            let json = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String: String]
            XCTAssert(json["test"] == "data")
            expectation.fulfill()
        }.resume()

        self.waitForExpectations(timeout: 0.02, handler: nil)
    }
}
```

### Quick & Alamofire

```swift
class MokeiSpecs: QuickSpec {
    override func spec() {
        describe("Quick compatibility test") {
            context("using JSON file") {
                beforeEach() {
                    // wait for 1.5s
                    self.stub.url("echo.jsontest.com/[a-z]+/.*")
                        .httpMethod(.post)
                        .json(["test": "data"])
                        .delay(1.5)
                }

                it("returns mock data") {
                    var json: [String: String]?

                    Alamofire.request("http://echo.jsontest.com/key/value/one/two", method: .post).responseJSON { response in
                        json = response.result.value as? [String: String]
                    }

					// SessionManager is also OK.
					// SessionManager.default.request("http://echo.jsontest.com/key/value/one/two").responseJSON { _ in }

                    expect(json?["test"]).toEventually(equal("data"))
                }
            }
        }
    }
}
```

# Installation

## Carthage

```ruby
github "tattn/Replacer"
```

## CocoaPods

```ruby
pod 'Replacer'
```

# Documentation

- [Stub Reference](https://github.com/tattn/Replacer/blob/master/Documentation/Reference.md)

# Contributing

1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request :D

# License

Replacer is released under the MIT license. See LICENSE for details.
