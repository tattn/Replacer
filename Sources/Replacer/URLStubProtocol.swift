//
//  URLStubProtocol.swift
//  Replacer
//
//  Created by Tatsuya Tanaka (tattn) on 2017/02/12.
//  Copyright © 2017年 tattn. All rights reserved.
//

import Foundation

public class URLStubProtocol: URLProtocol {

    override open class func canInit(with request: URLRequest) -> Bool {
        return URLStubManager.shared.findStub(by: request) != nil
    }

    override open class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override open func startLoading() {
        let stub = URLStubManager.shared.findStub(by: request)!
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + stub._delay) {
            if let responseBlock = stub._responseBlock {
                (stub._data, stub._error) = responseBlock(self.request)
                stub._responseBlock = nil
            }
            if let statusCode = stub._statusCode {
                let response = HTTPURLResponse(url: self.request.url!, statusCode: statusCode, httpVersion: nil, headerFields: nil)
                self.client?.urlProtocol(self, didReceive: response!, cacheStoragePolicy: .notAllowed)
            }
            if let error = stub._error {
                self.client?.urlProtocol(self, didFailWithError: error)
            } else if let data = stub._data {
                self.client?.urlProtocol(self, didLoad: data)
            } else {
                preconditionFailure("response is not set")
            }
            self.client?.urlProtocolDidFinishLoading(self)
        }
    }

    override open func stopLoading() {
        // noop
    }
}
