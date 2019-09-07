//
//  URLStub.swift
//  Replacer
//
//  Created by Tatsuya Tanaka (tattn) on 2017/01/01.
//  Copyright © 2017年 tattn. All rights reserved.
//

import Foundation

public class URLStub {
    var _url: String = ""
    var _method: HTTPMethod = .get
    var _statusCode: Int?
    var _data: Data?
    var _error: Error?
    var _delay: Double = 0

    public typealias ResponseBlock = (URLRequest) -> (Data?, Error?)
    var _responseBlock: ResponseBlock?
    
    public var bundle: Bundle!


    init(bundle: Bundle = Bundle.main) {
        self.bundle = bundle
    }
    
    /// Set a URL you want to replace
    ///
    /// - Parameter url: URL you want to replace
    @discardableResult
    public func url(_ url: String) -> Self {
        _url = url
        return self
    }

    /// Set a HTTP Method
    ///
    /// - Parameter method: HTTP method
    @discardableResult
    public func httpMethod(_ method: HTTPMethod) -> Self {
        _method = method
        return self
    }

    /// Set a status code
    ///
    /// - Parameter statusCode: Status code
    @discardableResult
    public func statusCode(_ statusCode: Int) -> Self {
        _statusCode = statusCode
        return self
    }
    
    /// Set a JSON for response
    ///
    /// - Parameter json: json of response
    @discardableResult
    public func json(_ json: [String: Any]) -> Self {
        return self.json(json as Any)
    }

    /// Set a JSON for response
    ///
    /// - Parameter json: json of response
    @discardableResult
    public func json(_ json: [Any]) -> Self {
        return self.json(json as Any)
    }

    private func json(_ json: Any) -> Self {
        do {
            _data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        } catch {
            preconditionFailure("Failed to load a JSON: \(error.localizedDescription)")
        }
        return self
    }

    /// Set a filename of JSON for response
    ///
    /// - Parameter json: json of response
    @discardableResult
    public func json(filename: String, bundle: Bundle? = nil) -> Self {
        if let bundle = bundle {
            self.bundle = bundle
        }
        _data = loadJSON(filename: filename)
        return self
    }

    /// Set an error for response
    ///
    /// - Parameter error: error of response
    @discardableResult
    public func error(_ error: Error) -> Self {
        _error = error
        return self
    }

    /// Set a delay of response
    ///
    /// - Parameter seconds: wait time [s]
    @discardableResult
    public func delay(_ seconds: Double) -> Self {
        self._delay = seconds
        return self
    }

    @discardableResult
    public func response(block: @escaping ResponseBlock) -> Self {
        self._responseBlock = block
        return self
    }

    /// Load JSON from the bundle.
    ///
    /// - Parameter name: JSON file name (without the extension)
    /// - Returns: JSON data
    private func loadJSON(filename: String) -> Data {
        guard let path = bundle.url(forResource: filename, withExtension: "json"),
            let data = try? Data(contentsOf: path) else {
                preconditionFailure("Failed to load a JSON file[\(filename)]")
        }
        return data
    }
}

public extension URLStub {
    /// HTTP method definitions.
    enum HTTPMethod: String {
        case get     = "GET"
        case post    = "POST"
        case put     = "PUT"
        case patch   = "PATCH"
        case delete  = "DELETE"
        case head    = "HEAD"
        case options = "OPTIONS"
        case trace   = "TRACE"
        case connect = "CONNECT"
    }
}
