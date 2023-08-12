//
//  CancelBag.swift
//  
//
//  Created by 김윤서 on 2023/08/07.
//

import Combine

public class CancelBag {
    public var subscriptions = Set<AnyCancellable>()

    public func cancel() {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
    }

    public init() { }
}

extension AnyCancellable {
    public func store(in cancelBag: CancelBag) {
        cancelBag.subscriptions.insert(self)
    }
}
