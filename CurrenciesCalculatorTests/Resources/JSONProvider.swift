//
//  JSONProvider.swift
//  CurrenciesCalculatorTests
//
//  Created by Igor Zarubin on 06/10/2018.
//  Copyright © 2018 i.zarubin. All rights reserved.
//

import Foundation

final class JSONProvider {
    private init() {}
    
    static func json(from file: String) -> [String: Any] {
        let path = Bundle(for: self).path(forResource: file, ofType: "json")!
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            return try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String: Any]
        } catch {
            fatalError("Unable to get json from file: \(file)")
        }
    }
}
