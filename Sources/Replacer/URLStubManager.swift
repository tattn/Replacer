//
//  StubManager.swift
//  Replacer
//
//  Created by Tatsuya Tanaka on 2017/02/12.
//  Copyright © 2017年 tattn. All rights reserved.
//

import Foundation

public final class URLStubManager {
    
    public static let shared = URLStubManager()

    fileprivate var stubs: [URLStub] = []

    public var isEnabled: Bool = false {
        didSet {
            guard isEnabled != oldValue else { return }
            swizzleDefaultSessionConfiguration()
        }
    }
    
    
    private init() {}

    private func swizzleDefaultSessionConfiguration() {
        let defaultSessionConfiguration = class_getClassMethod(URLSessionConfiguration.self, #selector(getter: URLSessionConfiguration.default))!
        let swizzledDefaultSessionConfiguration = class_getClassMethod(URLSessionConfiguration.self, #selector(getter: URLSessionConfiguration.mock))!
        method_exchangeImplementations(defaultSessionConfiguration, swizzledDefaultSessionConfiguration)
    }
}

public extension URLStubManager {

    func register(_ stub: URLStub) {
        stubs.append(stub)
        URLProtocol.registerClass(URLStubProtocol.self)
    }

    func unregisterAllStubs() {
        stubs = []
    }

    func findStub(by request: URLRequest) -> URLStub? {
        if let url = request.url?.absoluteString {
            return stubs
                .filter { request.httpMethod == $0._method.rawValue }
                .filter { !".*\($0._url).*".matches(in: url).isEmpty }
                .first
        }
        return nil
    }
}

private extension String {
    func matches(in text: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: self)
            let nsString = text as NSString
            let results = regex.matches(in: text, range: NSRange(location: 0, length: nsString.length))
            return results.map { nsString.substring(with: $0.range) }
        } catch let error {
            preconditionFailure("Invalid regex: \(error.localizedDescription)")
        }
    }
}
