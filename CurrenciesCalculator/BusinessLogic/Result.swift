//
//  Result.swift
//  CurrenciesCalculator
//
//  Created by i.zarubin on 05/10/2018.
//  Copyright © 2018 i.zarubin. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case error(Error)
}
