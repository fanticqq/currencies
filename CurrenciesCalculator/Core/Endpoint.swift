//
//  Endpoint.swift
//  CurrenciesCalculator
//
//  Created by Igor Zarubin on 05/10/2018.
//  Copyright © 2018 i.zarubin. All rights reserved.
//

import Foundation

enum Endpoint {
    private static let baseURL = "https://revolut.duckdns.org/"
    case currencies(base: String)
    
    var url: URL {
        let urlString: String
        switch self {
        case .currencies(let base):
            urlString = "latest?base=\(base)"
        }
        guard let url = URL(string: Endpoint.baseURL + urlString) else {
            fatalError("Unable to build url")
        }
        return url
    }
}
