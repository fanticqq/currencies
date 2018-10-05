//
//  Sampler.swift
//  CurrenciesCalculator
//
//  Created by Igor Zarubin on 05/10/2018.
//  Copyright © 2018 i.zarubin. All rights reserved.
//

import Foundation

final class Sampler {
    let limit: TimeInterval
    
    private var item: DispatchWorkItem?
    private let queue: DispatchQueue
    
    init(limit: TimeInterval, queue: DispatchQueue) {
        self.queue = queue
        self.limit = limit
    }
    
    func invalidate() {
        item?.cancel()
    }
    
    func execute(action: @escaping () -> Void) {
        self.item?.cancel()
        let item = DispatchWorkItem {
            action()
        }
        self.item = item
        queue.asyncAfter(deadline: .now() + limit, execute: item)
    }
}
