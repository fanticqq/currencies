//
//  EntityProvider.swift
//  CurrenciesCalculatorTests
//
//  Created by Igor Zarubin on 06/10/2018.
//  Copyright © 2018 i.zarubin. All rights reserved.
//

import Foundation
@testable import CurrenciesCalculator

final class EntityProvider {
    private init() {}
    
    static func currencies() -> [Currency] {
        let json = JSONProvider.json(from: "DummyJSON")
        guard let rates = json["rates"] as? [String: Double] else {
            fatalError("Unable found rates key")
        }
        let currencies = rates.map({ (key, value) -> Currency in
            return Currency(name: key, multiplier: value)
        }).sorted(by: { (lhs, rhs) -> Bool in
            return lhs.name < rhs.name
        })
        return currencies
    }
}
