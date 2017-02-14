//
//  Replacer.swift
//  Replacer
//
//  Created by Tatsuya Tanaka (tattn) on 2017/01/01.
//  Copyright © 2017年 tattn. All rights reserved.
//

import Foundation

@discardableResult
public func replaceStatic(_ fromSelector: Selector,
                          of fromClass: AnyClass? = nil,
                          with toSelector: Selector,
                          of toClass: AnyClass) -> Bool {

    let fromClass: AnyClass = fromClass ?? toClass

    guard let from = class_getClassMethod(fromClass, fromSelector),
        let to = class_getClassMethod(toClass, toSelector) else {
            return false
    }
    
    method_exchangeImplementations(from, to)

    return true
}

@discardableResult
public func replaceInstance(_ fromSelector: Selector,
                            of fromClass: AnyClass? = nil,
                            with toSelector: Selector,
                            of toClass: AnyClass) -> Bool {

    let fromClass: AnyClass = fromClass ?? toClass

    guard let from = class_getInstanceMethod(fromClass, fromSelector),
        let to = class_getInstanceMethod(toClass, toSelector) else {
            return false
    }
    
    addOrExchangeMethod(fromSelector: fromSelector,
                        fromMethod: from,
                        of: fromClass,
                        toSelector: toSelector,
                        toMethod: to,
                        of: toClass)
    return true
}

private func addOrExchangeMethod(fromSelector: Selector,
                                 fromMethod: Method,
                                 of fromClass: AnyClass,
                                 toSelector: Selector,
                                 toMethod: Method,
                                 of toClass: AnyClass) {
    // add if not exists
    if class_addMethod(fromClass,
                       fromSelector,
                       method_getImplementation(toMethod),
                       method_getTypeEncoding(toMethod)) {

        // replace added method
        class_replaceMethod(fromClass,
                            toSelector,
                            method_getImplementation(fromMethod),
                            method_getTypeEncoding(fromMethod))
    } else {
        // exchange if exists
        method_exchangeImplementations(fromMethod, toMethod)
    }
}

/// Register a stub.
public var urlStub: URLStub {
    URLStubManager.shared.isEnabled = true
    
    let stub = URLStub()
    URLStubManager.shared.register(stub)
    return stub
}
