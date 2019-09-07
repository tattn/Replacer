//
//  URLSessionConfiguration+.swift
//  Replacer
//
//  Created by Tatsuya Tanaka on 2017/02/12.
//  Copyright © 2017年 tattn. All rights reserved.
//

import Foundation

extension URLSessionConfiguration {

    @objc dynamic class var mock: URLSessionConfiguration {
        let configuration = self.mock
        configuration.protocolClasses?.insert(URLStubProtocol.self, at: 0)
        return configuration
    }
}
