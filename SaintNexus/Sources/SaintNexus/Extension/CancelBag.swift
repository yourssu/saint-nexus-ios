//
//  CancelBag.swift
//  
//
//  Created by 김윤서 on 2023/08/07.
//

import Combine

class CancelBag {
    var subscriptions = Set<AnyCancellable>()

    func cancel() {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
    }

    init() { }
}

extension AnyCancellable {
    func store(in cancelBag: CancelBag) {
        cancelBag.subscriptions.insert(self)
    }
}
